from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas import Category, Filters, Locality

router = APIRouter(tags=["dictionaries"])

# Localities that host at least one active school or branch
LOCALITIES_SQL = text("""
    WITH places AS (
        SELECT s.school_id, s.locality_id
        FROM scoli_auto s
        WHERE s.is_active
        UNION
        SELECT f.school_id, f.locality_id
        FROM filiale_scoli_auto f
        JOIN scoli_auto s ON s.school_id = f.school_id AND s.is_active
        WHERE f.is_active
    )
    SELECT l.locality_id AS id,
           l.name_ro AS name,
           r.name_ro AS district,
           count(DISTINCT p.school_id) AS schools_count
    FROM places p
    JOIN localitati l ON l.locality_id = p.locality_id
    JOIN raioane r ON r.district_id = l.district_id
    GROUP BY l.locality_id, l.name_ro, r.name_ro
    ORDER BY schools_count DESC, l.name_ro
""")

# Categories that at least one active school actually teaches
OFFERED_CATEGORIES_SQL = text("""
    SELECT cp.category_code
    FROM categorii_permise cp
    WHERE EXISTS (
        SELECT 1
        FROM categorii_scoli_auto c
        JOIN scoli_auto s ON s.school_id = c.school_id AND s.is_active
        WHERE c.category_code = cp.category_code AND c.is_active
    )
    ORDER BY cp.sort_order NULLS LAST, cp.category_code
""")

YEARS_SQL = text("""
    SELECT DISTINCT period_year
    FROM statistici_scoli_perioade
    ORDER BY period_year DESC
""")


@router.get("/categories", response_model=list[Category])
def list_categories(db: Session = Depends(get_db)):
    rows = db.execute(text("""
        SELECT category_code AS code,
               parent_category_code AS parent_code,
               description_ro AS description,
               min_age
        FROM categorii_permise
        WHERE is_active
        ORDER BY sort_order NULLS LAST, category_code
    """)).mappings().all()
    return rows


@router.get("/localities", response_model=list[Locality])
def list_localities(db: Session = Depends(get_db)):
    return db.execute(LOCALITIES_SQL).mappings().all()


@router.get("/filters", response_model=Filters)
def get_filters(db: Session = Depends(get_db)):
    """Everything the search box and ranking filters need, in one request."""
    return {
        "localities": db.execute(LOCALITIES_SQL).mappings().all(),
        "categories": db.execute(OFFERED_CATEGORIES_SQL).scalars().all(),
        "years": db.execute(YEARS_SQL).scalars().all(),
    }
