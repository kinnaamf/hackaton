"""Run a SQL file against the database configured in backend/.env (no psql needed).

    python -m scripts.run_sql ../database/seed/monthly_statistics.sql
    python -m scripts.run_sql ../database/seed/monthly_statistics.sql --db other_name
"""
from __future__ import annotations

import argparse
import os
from pathlib import Path

import psycopg2

from scripts.seed_public import CONNECTION


def run_sql(path: Path, db_name: str) -> None:
    db = psycopg2.connect(dbname=db_name, **CONNECTION)
    db.autocommit = True  # the file manages its own transaction
    try:
        with db.cursor() as cur:
            cur.execute(path.read_text(encoding='utf-8'))
    finally:
        db.close()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('file', type=Path)
    parser.add_argument('--db', default=os.getenv('DB_NAME', 'postgresql'))
    args = parser.parse_args()
    run_sql(args.file, args.db)
    print(f'{args.file.name} applied to {args.db}.')


if __name__ == '__main__':
    main()
