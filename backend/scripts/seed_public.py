"""Load the real dataset from database/public.sql, limited to the tables the API reads.

The full dump is ~58 MB and mostly exam-attempt detail (tentative_examinare,
candidati, dosare_instruire, ...) that no endpoint touches. This script copies
only the API tables, with their original column definitions, rows, keys, checks,
indexes and foreign keys, into a dedicated database.

On top of the dump it then:
- adds back the 10 real schools from seed_demo (verified addresses and coordinates);
- generates 2025 and 2026 statistics and exams for every school the dump has no
  statistics for, with theory pass rates strictly between 80% and 95%;
- generates practical-exam attempts and penalties (frequent errors) for those exams,
  sampling penalty types with the dump's own frequencies;
- adjusts the dump's own statistics so every theory pass rate is inside (80%, 95%);
- sets every licence to expire between 2028 and 2031;
- recomputes rank_position for every category, year and month;
- applies database/seed/monthly_statistics.sql for smooth month-by-month curves.

    python -m scripts.seed_public                  # -> postgresql
    python -m scripts.seed_public --db other_name
"""
from __future__ import annotations

import argparse
import datetime as dt
import os
import random
import re
import time
from pathlib import Path

import psycopg2
from dotenv import load_dotenv
from psycopg2.extras import execute_values

from scripts.seed_demo import SCHOOL_ADDRESSES, SCHOOLS as REAL_SCHOOLS

ROOT = Path(__file__).resolve().parents[1]
DUMP = ROOT.parent / 'database' / 'public.sql'
MONTHLY_SQL = ROOT.parent / 'database' / 'seed' / 'monthly_statistics.sql'
load_dotenv(ROOT / '.env')
CONNECTION = dict(
    user=os.getenv('DB_USER', 'postgres'), password=os.getenv('DB_PASSWORD', 'postgres'),
    host=os.getenv('DB_HOST', 'localhost'), port=os.getenv('DB_PORT', '5432'),
)

# Every table referenced by app/routers/*.py
API_TABLES = {
    'raioane', 'localitati', 'categorii_permise', 'scoli_auto', 'categorii_scoli_auto',
    'filiale_scoli_auto', 'statistici_scoli_perioade', 'utilizatori', 'recenzii',
    'examene', 'instructori', 'vehicule',
    # practical-exam attempts and their penalties, for the frequent-errors stats
    'tentative_examinare', 'penalizari_tentative', 'tipuri_penalizari', 'tipuri_probe_practice',
}

# Navicat section headers, e.g. "-- Primary Key structure for table scoli_auto"
SECTION = re.compile(r'^-- (Table structure|Records|Primary Key structure|Indexes structure|'
                     r'Checks structure|Uniques structure|Foreign Keys structure|'
                     r'[A-Z][\w ]*?)(?: for| of)(?: table)? "?(\w+)"?\s*$')
REFERENCES = re.compile(r'REFERENCES "public"\."(\w+)"')
KEPT_SECTIONS = {'Table structure', 'Primary Key structure', 'Indexes structure',
                 'Checks structure', 'Uniques structure', 'Foreign Keys structure'}
BATCH = 2000


def read_dump() -> tuple[list[str], list[str], list[str]]:
    """Split the API tables' part of the dump into DDL, INSERTs and post-data constraints."""
    ddl: list[str] = []
    rows: list[str] = []
    constraints: list[str] = []
    section, table, buffer = None, None, []

    def flush() -> None:
        if table not in API_TABLES or not buffer:
            return
        if section == 'Table structure':
            ddl.append('\n'.join(buffer))
        elif section == 'Foreign Keys structure':
            constraints.extend(line for line in buffer
                               if set(REFERENCES.findall(line)) <= API_TABLES)
        elif section in KEPT_SECTIONS:
            constraints.append('\n'.join(buffer))

    with DUMP.open(encoding='utf-8') as dump:
        for line in dump:
            line = line.rstrip('\n')
            match = SECTION.match(line)
            if match:
                flush()
                section, table, buffer = match.group(1), match.group(2), []
            elif line.startswith('-- ') or line == '--' or line.startswith('-- ---'):
                continue
            elif section == 'Records':
                if table in API_TABLES and line.startswith('INSERT INTO'):
                    rows.append(line)
            elif line.strip() and not line.startswith('SELECT setval'):
                buffer.append(line)
        flush()
    return ddl, rows, constraints


YEAR_MONTHS = {2025: range(1, 13), 2026: range(1, 10)}
STAT_COLUMNS = (
    'school_id, category_code, period_year, period_month, candidates_total, '
    'theory_exams, theory_attempts, theory_passed, theory_first_attempt_passed, '
    'practice_exams, practice_attempts, practice_passed, practice_first_attempt_passed, '
    'avg_attempts_to_pass, avg_penalty_points, avg_rating, reviews_count'
)
EXAM_COLUMNS = (
    'exam_id, exam_type_id, candidate_id, category_code, school_id, result_id, attempts_total, '
    'first_attempt_date, last_attempt_date, passed_date, is_passed_first_attempt'
)
PASSED, FAILED = 1, 2


def add_real_schools(cur, rng: random.Random) -> None:
    """The verified schools from seed_demo, with categories, a seat branch, staff and fleet."""
    for name, city, locality, lat, lon, _theory, _practice, _first, price in REAL_SCHOOLS:
        address = SCHOOL_ADDRESSES[name]
        cur.execute('''
            INSERT INTO scoli_auto (name, short_name, legal_form, license_number, license_issue_date,
                                    license_expiry_date, locality_id, address, latitude, longitude,
                                    description, is_verified, is_active)
            VALUES (%s, %s, 'SRL', NULL, NULL, '2030-12-31', %s, %s, %s, %s, %s, true, true)
            RETURNING school_id
        ''', (name + ' SRL', name, locality, address, lat, lon,
              'Școală auto licențiată, cu instructori și programe pentru pregătirea permisului.'))
        school_id = cur.fetchone()[0]
        cur.execute("UPDATE scoli_auto SET license_number = %s WHERE school_id = %s",
                    (f'MD-AUTO-{school_id:04}', school_id))
        execute_values(cur, '''
            INSERT INTO categorii_scoli_auto (school_id, category_code, price, currency,
                                              theory_hours, practice_hours, duration_weeks)
            VALUES %s''', [(school_id, code, round(price * multiplier), 'MDL', hours, practice, weeks)
                           for code, multiplier, hours, practice, weeks in
                           [('B', 1, 72, 54, 10), ('A1', 0.72, 35, 33, 7), ('C', 1.25, 50, 52, 11)]])
        cur.execute('''
            INSERT INTO filiale_scoli_auto (school_id, name, locality_id, address, latitude, longitude,
                                            has_training_ground)
            VALUES (%s, %s, %s, %s, %s, %s, true)''', (school_id, name + ' — sediu', locality, address, lat, lon))
        for n in range(1, rng.randint(3, 6)):
            cur.execute('''
                INSERT INTO instructori (school_id, lastname, firstname, experience_years, category_codes)
                VALUES (%s, 'INSTRUCTOR', %s, %s, %s)''', (school_id, str(n), rng.randint(3, 25), ['B']))
            cur.execute('''
                INSERT INTO vehicule (reg_number, school_id, category_code, manufacture_year)
                VALUES (%s, %s, 'B', %s)''', (f'GEN{school_id:03}{n}', school_id, rng.randint(2017, 2025)))


def theory_passed(attempts: int, rng: random.Random) -> int:
    """A pass count whose rate is strictly inside (80%, 95%); needs attempts >= 6."""
    target = rng.uniform(0.82, 0.93)
    options = [p for p in range(attempts + 1) if 80 < 100 * p / attempts < 95]
    return min(options, key=lambda p: abs(p / attempts - target))


def theory_counts(exams: int, rng: random.Random) -> tuple[int, int, int, int]:
    """(exams, attempts, passed, first-attempt passed) with a pass rate inside (80%, 95%)."""
    attempts = max(6, exams + round(exams * rng.uniform(0.04, 0.12)))
    passed = theory_passed(attempts, rng)
    exams = max(exams, passed)
    return exams, attempts, passed, min(passed, round(exams * rng.uniform(0.75, 0.9)))


def generate_statistics(cur, rng: random.Random) -> int:
    """Monthly + yearly statistics and matching exam rows for schools with no statistics."""
    cur.execute('''
        SELECT c.school_id, c.category_code
        FROM categorii_scoli_auto c
        WHERE c.is_active
          AND NOT EXISTS (SELECT 1 FROM statistici_scoli_perioade st WHERE st.school_id = c.school_id)
        ORDER BY c.school_id, c.category_code
    ''')
    pairs = cur.fetchall()
    cur.execute('''
        SELECT school_id, category_code, round(avg(rating_overall), 2), count(*)
        FROM recenzii WHERE status <> 'respins' GROUP BY 1, 2
    ''')
    ratings = {(school, code): (avg, count) for school, code, avg, count in cur.fetchall()}
    cur.execute('SELECT coalesce(max(candidate_id), 0) FROM examene')
    candidate_id = cur.fetchone()[0]

    stats, exams = [], []
    for school_id, code in pairs:
        rating, reviews = ratings.get((school_id, code), (None, 0))
        for year, months in YEAR_MONTHS.items():
            yearly = [0] * 9
            for month in months:
                candidates = rng.randint(12, 30) if code == 'B' else rng.randint(5, 10)
                t_exams, t_attempts, t_passed, t_first = theory_counts(candidates, rng)
                p_exams = max(1, round(candidates * rng.uniform(0.8, 0.95)))
                p_attempts = p_exams + round(p_exams * rng.uniform(0.25, 0.5))
                p_passed = min(p_exams, round(p_attempts * rng.uniform(0.6, 0.8)))
                p_first = min(p_passed, round(p_exams * rng.uniform(0.55, 0.75)))
                candidates = max(candidates, t_exams)
                row = [candidates, t_exams, t_attempts, t_passed, t_first,
                       p_exams, p_attempts, p_passed, p_first]
                yearly = [a + b for a, b in zip(yearly, row)]
                stats.append((school_id, code, year, month, *row,
                              round(rng.uniform(1.1, 1.6), 2), round(rng.uniform(8, 18), 2), rating, 0))

                for i in range(candidates):
                    candidate_id += 1
                    day = dt.date(year, month, rng.randint(1, 28))
                    t_ok = i < t_passed
                    exams.append((800_000_000 + candidate_id - 1, 1, candidate_id, code, school_id,
                                  PASSED if t_ok else FAILED, 1 if i < t_first else 2,
                                  day, day, day if t_ok else None, i < t_first))
                    if i < p_exams:
                        p_day = day + dt.timedelta(days=rng.randint(7, 21))
                        p_ok = i < p_passed
                        exams.append((900_000_000 + candidate_id - 1, 2, candidate_id, code, school_id,
                                      PASSED if p_ok else FAILED, 1 if i < p_first else 2,
                                      p_day, p_day, p_day if p_ok else None, i < p_first))
            stats.append((school_id, code, year, 0, *yearly,
                          round(rng.uniform(1.1, 1.6), 2), round(rng.uniform(8, 18), 2), rating, reviews))

    execute_values(cur, f'INSERT INTO statistici_scoli_perioade ({STAT_COLUMNS}) VALUES %s', stats)
    execute_values(cur, f'INSERT INTO examene ({EXAM_COLUMNS}) VALUES %s', exams, page_size=5000)
    return len({school for school, _ in pairs})


POLIGON, CITY = 3, 4  # tipuri_probe_practice


def generate_attempts(cur, rng: random.Random) -> tuple[int, int]:
    """Practical-exam attempts and penalties for practice exams that have none.

    Each exam is a training-ground (poligon) attempt followed by one or two city attempts,
    ending with the exam's result. Penalty types are drawn per category and practice type
    with the frequencies seen in the dump; a passed attempt stays within the 20-point limit,
    a failed one goes over it.
    """
    cur.execute('SELECT practice_type_id, coalesce(max_penalty_points, 20) FROM tipuri_probe_practice')
    limits = dict(cur.fetchall())
    cur.execute('''
        SELECT tp.category_code, tp.practice_type_id, tp.penalty_id, tp.points, tp.is_eliminatory,
               1 + count(pt.id) AS weight
        FROM tipuri_penalizari tp
        LEFT JOIN penalizari_tentative pt
          ON pt.category_code = tp.category_code AND pt.penalty_id = tp.penalty_id
        WHERE tp.is_active
        GROUP BY 1, 2, 3, 4, 5
    ''')
    catalog: dict[tuple[str, int], list[tuple[int, int, bool, int]]] = {}
    for code, practice_type, penalty_id, points, eliminatory, weight in cur.fetchall():
        catalog.setdefault((code, practice_type), []).append((penalty_id, points, eliminatory, weight))

    cur.execute('''
        SELECT e.exam_id, e.category_code, e.result_id, e.attempts_total, e.first_attempt_date
        FROM examene e
        WHERE e.exam_type_id = 2
          AND NOT EXISTS (SELECT 1 FROM tentative_examinare t
                          WHERE t.exam_id = e.exam_id AND t.exam_type_id = e.exam_type_id)
        ORDER BY e.exam_id
    ''')
    exams = cur.fetchall()
    cur.execute('SELECT coalesce(max(attempt_id), 0) FROM tentative_examinare')
    attempt_id = cur.fetchone()[0]

    def penalties(code: str, practice_type: int, passed: bool) -> list[tuple[int, int, int]]:
        options = catalog.get((code, practice_type))
        if not options:
            return []
        limit = limits.get(practice_type, 20)
        lines, total = [], 0
        for _ in range(rng.choice([0, 1, 1, 2, 2, 3]) if passed else 8):
            penalty_id, points, eliminatory, _w = rng.choices(options, [o[3] for o in options])[0]
            quantity = 2 if not eliminatory and rng.random() < 0.1 else 1
            if passed and (eliminatory or total + points * quantity > limit):
                continue
            lines.append((penalty_id, quantity, points * quantity))
            total += points * quantity
            if not passed and (eliminatory or total > limit):
                break
        return lines

    attempts, lines = [], []
    for exam_id, code, result_id, attempts_total, first_date in exams:
        steps = [(POLIGON, True)] + [(CITY, False)] * (max(attempts_total, 1) - 1) + [(CITY, result_id == PASSED)]
        day = first_date
        for number, (practice_type, passed) in enumerate(steps, 1):
            attempt_id += 1
            found = penalties(code, practice_type, passed)
            attempts.append((attempt_id, exam_id, 2, number, day, day.isoweekday(),
                             PASSED if passed else FAILED, practice_type, sum(p[2] for p in found)))
            lines.extend((attempt_id, code, penalty_id, quantity, points)
                         for penalty_id, quantity, points in found)
            day += dt.timedelta(days=rng.randint(7, 21) if not passed else rng.randint(1, 7))

    execute_values(cur, '''
        INSERT INTO tentative_examinare (attempt_id, exam_id, exam_type_id, attempt_number, exam_date,
                                         weekday_id, result_id, practice_type_id, total_points)
        VALUES %s''', attempts, page_size=5000)
    execute_values(cur, '''
        INSERT INTO penalizari_tentative (attempt_id, category_code, penalty_id, quantity, points)
        VALUES %s''', lines, page_size=5000)
    return len(attempts), len(lines)


def refresh_licences(cur, rng: random.Random) -> None:
    """Every licence expires between 2028-01-01 and 2031-12-31, issued five years earlier."""
    cur.execute('SELECT school_id FROM scoli_auto ORDER BY school_id')
    start, span = dt.date(2028, 1, 1), (dt.date(2031, 12, 31) - dt.date(2028, 1, 1)).days
    updates = []
    for (school_id,) in cur.fetchall():
        expiry = start + dt.timedelta(days=rng.randint(0, span))
        updates.append((school_id, expiry, expiry - dt.timedelta(days=5 * 365 + 1)))
    execute_values(cur, '''
        UPDATE scoli_auto s SET license_expiry_date = v.expiry, license_issue_date = v.issued
        FROM (VALUES %s) AS v(school_id, expiry, issued) WHERE s.school_id = v.school_id
    ''', updates)


def normalize_theory(cur, rng: random.Random) -> int:
    """Bring every statistics row's theory pass rate inside (80%, 95%), keeping its exam count."""
    cur.execute('''
        SELECT school_id, category_code, period_year, period_month, theory_exams, candidates_total
        FROM statistici_scoli_perioade
        WHERE theory_pass_rate IS NULL OR theory_pass_rate <= 80 OR theory_pass_rate >= 95
        ORDER BY 1, 2, 3, 4
    ''')
    updates = []
    for school_id, code, year, month, exams, candidates in cur.fetchall():
        exams, attempts, passed, first = theory_counts(exams, rng)
        updates.append((school_id, code, year, month, max(candidates, exams), exams, attempts, passed, first))
    execute_values(cur, '''
        UPDATE statistici_scoli_perioade st
           SET candidates_total = v.candidates, theory_exams = v.exams, theory_attempts = v.attempts,
               theory_passed = v.passed, theory_first_attempt_passed = v.first
        FROM (VALUES %s) AS v(school_id, category_code, period_year, period_month,
                              candidates, exams, attempts, passed, first)
        WHERE (st.school_id, st.category_code, st.period_year, st.period_month)
            = (v.school_id, v.category_code, v.period_year, v.period_month)
    ''', updates, page_size=1000)
    return len(updates)


def recompute_ranks(cur) -> None:
    """Rank schools in every category/year/month by a blend of theory, practice and first-try rates."""
    cur.execute('''
        UPDATE statistici_scoli_perioade st SET rank_position = r.rank
        FROM (
            SELECT school_id, category_code, period_year, period_month,
                   row_number() OVER (
                       PARTITION BY category_code, period_year, period_month
                       ORDER BY 0.3 * coalesce(theory_pass_rate, 0)
                              + 0.4 * coalesce(practice_pass_rate, 0)
                              + 0.3 * coalesce(practice_first_attempt_rate, 0) DESC,
                                candidates_total DESC, school_id
                   ) AS rank
            FROM statistici_scoli_perioade
        ) r
        WHERE (st.school_id, st.category_code, st.period_year, st.period_month)
            = (r.school_id, r.category_code, r.period_year, r.period_month)
    ''')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--db', default='postgresql', help='target database (recreated schema)')
    db_name = parser.parse_args().db

    started = time.perf_counter()
    ddl, rows, constraints = read_dump()

    admin = psycopg2.connect(dbname='postgres', **CONNECTION)
    admin.autocommit = True
    with admin.cursor() as cur:
        cur.execute('SELECT 1 FROM pg_database WHERE datname = %s', (db_name,))
        if not cur.fetchone():
            cur.execute(f'CREATE DATABASE "{db_name}"')
    admin.close()

    db = psycopg2.connect(dbname=db_name, **CONNECTION)
    with db, db.cursor() as cur:
        cur.execute('DROP SCHEMA public CASCADE; CREATE SCHEMA public;')
        cur.execute('\n'.join(ddl))
        for start in range(0, len(rows), BATCH):
            cur.execute('\n'.join(rows[start:start + BATCH]))
        cur.execute('\n'.join(constraints))
        # Rows were inserted with OVERRIDING SYSTEM VALUE, so move identity sequences past them
        cur.execute('''
            SELECT table_name, column_name FROM information_schema.columns
            WHERE table_schema = 'public' AND is_identity = 'YES'
        ''')
        for table, column in cur.fetchall():
            cur.execute(f'''SELECT setval(pg_get_serial_sequence('public."{table}"', %s),
                                          coalesce(max("{column}"), 0) + 1, false)
                            FROM public."{table}"''', (column,))

        rng = random.Random(2026)
        add_real_schools(cur, rng)
        generated = generate_statistics(cur, rng)
        normalized = normalize_theory(cur, rng)
        attempts, penalties = generate_attempts(cur, random.Random(42))
        # Joins behind /frequent-errors: penalties -> attempts -> exams
        cur.execute('''
            CREATE INDEX ix_penalizari_tentative_attempt ON penalizari_tentative (attempt_id);
            CREATE INDEX ix_tentative_examinare_exam ON tentative_examinare (exam_id, exam_type_id);
        ''')
        refresh_licences(cur, rng)
        recompute_ranks(cur)

    # Smooth month-by-month curves; the file manages its own transaction
    db.autocommit = True
    with db.cursor() as cur:
        cur.execute(MONTHLY_SQL.read_text(encoding='utf-8'))
        cur.execute('ANALYZE')
    db.close()

    elapsed = time.perf_counter() - started
    print(f'{db_name} seeded from {DUMP.name}: {len(ddl)} tables, {len(rows)} rows, '
          f'{len(REAL_SCHOOLS)} real schools added, statistics generated for {generated} schools, '
          f'theory rates adjusted in {normalized} rows, {attempts} practice attempts with '
          f'{penalties} penalties generated '
          f'in {elapsed:.1f}s.')


if __name__ == '__main__':
    main()
