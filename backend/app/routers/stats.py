from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas import Overview

router = APIRouter(prefix="/stats", tags=["stats"])


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
