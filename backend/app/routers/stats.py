from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas import FrequentErrors, Overview

router = APIRouter(prefix="/stats", tags=["stats"])

# Penalties from practical-exam attempts, grouped by wording: the same error is listed
# separately for each category and manoeuvre in tipuri_penalizari
FREQUENT_ERRORS_SQL = text("""
    WITH attempts AS (
        SELECT t.attempt_id
        FROM tentative_examinare t
        JOIN examene e ON e.exam_id = t.exam_id AND e.exam_type_id = t.exam_type_id
        WHERE t.exam_type_id = 2
          AND (CAST(:category AS varchar) IS NULL OR e.category_code = :category)
          AND (CAST(:year AS int) IS NULL
               OR t.exam_date >= make_date(:year, 1, 1) AND t.exam_date < make_date(:year + 1, 1, 1))
          AND (CAST(:school_id AS int) IS NULL OR e.school_id = :school_id)
    ),
    -- one small integer per (wording, practice type), so the aggregate sorts ints, not text
    kinds AS (
        SELECT category_code, penalty_id, points, is_eliminatory, description_ro, practice_type_id,
               dense_rank() OVER (ORDER BY description_ro, practice_type_id) AS kind
        FROM tipuri_penalizari
    ),
    counted AS (
        SELECT k.kind,
               sum(pt.quantity) AS count,
               count(DISTINCT pt.attempt_id) AS attempts_with_error
        FROM penalizari_tentative pt
        JOIN attempts a ON a.attempt_id = pt.attempt_id
        JOIN kinds k ON k.category_code = pt.category_code AND k.penalty_id = pt.penalty_id
        GROUP BY k.kind
    ),
    errors AS (
        SELECT min(k.description_ro) AS description,
               min(pr.name_ro) AS practice_type,
               max(k.points) AS points,
               bool_or(k.is_eliminatory) AS is_eliminatory,
               min(c.count) AS count,
               min(c.attempts_with_error) AS attempts_with_error
        FROM counted c
        JOIN kinds k ON k.kind = c.kind
        LEFT JOIN tipuri_probe_practice pr ON pr.practice_type_id = k.practice_type_id
        GROUP BY c.kind
    )
    SELECT description, practice_type, points, is_eliminatory, count,
           round(100.0 * count / sum(count) OVER (), 1) AS percent,
           round(100.0 * attempts_with_error / (SELECT count(*) FROM attempts), 1) AS attempts_percent,
           (SELECT count(*) FROM attempts) AS attempts_count,
           sum(count) OVER () AS penalties_count
    FROM errors
    ORDER BY count DESC, description
    LIMIT :limit
""")


def frequent_errors(
    db: Session, category: str | None, year: int | None, school_id: int | None, limit: int
) -> dict:
    rows = db.execute(
        FREQUENT_ERRORS_SQL,
        {"category": category, "year": year, "school_id": school_id, "limit": limit},
    ).mappings().all()
    return {
        "year": year,
        "category": category,
        "school_id": school_id,
        "attempts_count": rows[0]["attempts_count"] if rows else 0,
        "penalties_count": rows[0]["penalties_count"] if rows else 0,
        "items": rows,
    }


@router.get("/frequent-errors", response_model=FrequentErrors)
def get_frequent_errors(
    category: str | None = Query(None, description="Licence category code; all categories if omitted"),
    year: int | None = Query(None, description="Exam year; all years if omitted"),
    limit: int = Query(4, ge=1, le=50),
    db: Session = Depends(get_db),
):
    """Most frequent penalties in practical exams, for the "Greșeli frecvente" block.

    `percent` is the error's share of all penalties; `attemptsPercent` is the share of
    practical-exam attempts where it was recorded at least once.
    """
    return frequent_errors(db, category, year, None, limit)


@router.get("/overview", response_model=Overview)
def get_overview(
    year: int | None = Query(None, description="Limit exam figures to one year; all years if omitted"),
    db: Session = Depends(get_db),
):
    """Headline numbers for the home page stats block."""
    row = db.execute(
        text("""
            WITH places AS (
                SELECT s.locality_id FROM scoli_auto s WHERE s.is_active
                UNION
                SELECT f.locality_id
                FROM filiale_scoli_auto f
                JOIN scoli_auto s ON s.school_id = f.school_id AND s.is_active
                WHERE f.is_active
            ),
            yearly AS (
                SELECT *
                FROM statistici_scoli_perioade
                WHERE period_month = 0
                  AND (CAST(:year AS int) IS NULL OR period_year = :year)
            )
            SELECT
                (SELECT count(*) FROM scoli_auto WHERE is_active) AS schools_count,
                (SELECT count(DISTINCT locality_id) FROM places) AS localities_count,
                (SELECT count(DISTINCT candidate_id)
                   FROM examene
                  WHERE CAST(:year AS int) IS NULL
                     OR extract(year FROM first_attempt_date) = :year) AS candidates_count,
                (SELECT round(100.0 * sum(theory_passed) / nullif(sum(theory_attempts), 0), 1)
                   FROM yearly) AS theory_pass_rate,
                (SELECT round(100.0 * sum(practice_passed) / nullif(sum(practice_attempts), 0), 1)
                   FROM yearly) AS practice_pass_rate
        """),
        {"year": year},
    ).mappings().one()
    return {"year": year, **row}
