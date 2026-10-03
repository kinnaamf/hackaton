from typing import Literal

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas import Performance, ReviewList, SchoolDetail, SchoolList

router = APIRouter(prefix="/schools", tags=["schools"])

# Reviews rejected by moderation are never shown or counted
VISIBLE_REVIEW = "status <> 'respins'"

SORT_COLUMNS = {
    "rank": "st.rank_position ASC",
    "theory": "st.theory_pass_rate DESC",
    "practice": "st.practice_pass_rate DESC",
    "firstTry": "st.practice_first_attempt_rate DESC",
    "rating": "r.rating DESC",
    "price": "sc.price ASC",
    "candidates": "st.candidates_total DESC",
}

STATS_COLUMNS = """
    st.category_code AS category,
    st.period_year AS year,
    st.rank_position AS rank,
    st.candidates_total AS candidates_count,
    st.theory_pass_rate,
    st.theory_first_attempt_rate AS theory_first_try_rate,
    st.practice_pass_rate,
    st.practice_first_attempt_rate AS practice_first_try_rate,
    st.avg_attempts_to_pass AS average_attempts,
    st.avg_penalty_points AS average_penalty_points
"""


def latest_year(db: Session) -> int:
    year = db.execute(text(
        "SELECT max(period_year) FROM statistici_scoli_perioade WHERE period_month = 0"
    )).scalar()
    if year is None:
        raise HTTPException(404, "No statistics available")
    return year


@router.get("", response_model=SchoolList)
def list_schools(
    category: str = Query("B", description="Licence category code, e.g. B"),
    year: int | None = Query(None, description="Statistics year; latest available if omitted"),
    locality_id: int | None = Query(None, description="Schools with a seat or branch in this locality"),
    city: str | None = Query(None, description="Same as locality_id, but by locality name"),
    search: str | None = Query(None, description="Substring of the school name"),
    sort: Literal["rank", "theory", "practice", "firstTry", "rating", "price", "candidates"] = Query("rank"),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    """School cards for the ranking/search pages."""
    params = {
        "category": category,
        "year": year or latest_year(db),
        "limit": limit,
        "offset": offset,
    }
    where = ["s.is_active"]

    if locality_id is not None or city:
        if locality_id is not None:
            params["locality_id"] = locality_id
            locality_match = "l2.locality_id = :locality_id"
        else:
            params["city"] = city
            locality_match = "lower(l2.name_ro) = lower(:city)"
        where.append(f"""(
            EXISTS (SELECT 1 FROM localitati l2
                    WHERE l2.locality_id = s.locality_id AND {locality_match})
            OR EXISTS (SELECT 1 FROM filiale_scoli_auto f
                       JOIN localitati l2 ON l2.locality_id = f.locality_id
                       WHERE f.school_id = s.school_id AND f.is_active AND {locality_match})
        )""")

    if search:
        params["search"] = f"%{search}%"
        where.append("(s.name ILIKE :search OR s.short_name ILIKE :search)")

    rows = db.execute(
        text(f"""
            SELECT s.school_id AS id,
                   coalesce(s.short_name, s.name) AS name,
                   s.is_verified AS verified,
                   l.name_ro AS city,
                   s.address,
                   coalesce((
                       SELECT array_agg(c.category_code ORDER BY cp.sort_order NULLS LAST, c.category_code)
                       FROM categorii_scoli_auto c
                       LEFT JOIN categorii_permise cp ON cp.category_code = c.category_code
                       WHERE c.school_id = s.school_id AND c.is_active
                   ), '{{}}') AS categories,
                   EXISTS (
                       SELECT 1 FROM filiale_scoli_auto f
                       WHERE f.school_id = s.school_id AND f.is_active AND f.has_training_ground
                   ) AS has_own_training_ground,
                   st.theory_pass_rate,
                   st.practice_pass_rate,
                   st.practice_first_attempt_rate AS first_try_pass_rate,
                   st.rank_position AS rank,
                   r.rating,
                   coalesce(r.reviews_count, 0) AS reviews_count,
                   coalesce(st.candidates_total, 0) AS candidates_count,
                   sc.price AS price_from,
                   count(*) OVER () AS total
            FROM scoli_auto s
            JOIN categorii_scoli_auto sc
              ON sc.school_id = s.school_id AND sc.category_code = :category AND sc.is_active
            LEFT JOIN localitati l ON l.locality_id = s.locality_id
            LEFT JOIN statistici_scoli_perioade st
              ON st.school_id = s.school_id
             AND st.category_code = :category
             AND st.period_year = :year
             AND st.period_month = 0
            LEFT JOIN (
                SELECT school_id,
                       round(avg(rating_overall), 1) AS rating,
                       count(*) AS reviews_count
                FROM recenzii
                WHERE {VISIBLE_REVIEW}
                GROUP BY school_id
            ) r ON r.school_id = s.school_id
            WHERE {" AND ".join(where)}
            ORDER BY {SORT_COLUMNS[sort]} NULLS LAST, s.school_id
            LIMIT :limit OFFSET :offset
        """),
        params,
    ).mappings().all()

    total = rows[0]["total"] if rows else 0
    return {"total": total, "items": rows}


def _performance(db: Session, school_id: int, category: str, year: int) -> dict | None:
    rows = db.execute(
        text(f"""
            SELECT coalesce(s.short_name, s.name) AS name,
                   st.period_month AS month,
                   {STATS_COLUMNS}
            FROM statistici_scoli_perioade st
            JOIN scoli_auto s ON s.school_id = st.school_id
            WHERE st.school_id = :school_id
              AND st.category_code = :category
              AND st.period_year = :year
            ORDER BY st.period_month
        """),
        {"school_id": school_id, "category": category, "year": year},
    ).mappings().all()

    yearly = next((r for r in rows if r["month"] == 0), None)
    if yearly is None:
        return None

    return {
        "school_id": school_id,
        "name": yearly["name"],
        "category": category,
        "year": year,
        "rank": yearly["rank"],
        "stats": yearly,
        "performance": [
            {
                "month": r["month"],
                "theory": r["theory_pass_rate"],
                "practice": r["practice_pass_rate"],
                "first_try_practice": r["practice_first_try_rate"],
                "candidates_count": r["candidates_count"],
            }
            for r in rows
            if r["month"] != 0
        ],
    }


@router.get("/featured", response_model=Performance)
def get_featured(
    category: str = Query("B"),
    year: int | None = Query(None, description="Latest available if omitted"),
    db: Session = Depends(get_db),
):
    """Performance of the top-ranked school, for the home page hero card."""
    year = year or latest_year(db)
    school_id = db.execute(
        text("""
            SELECT st.school_id
            FROM statistici_scoli_perioade st
            JOIN scoli_auto s ON s.school_id = st.school_id AND s.is_active
            WHERE st.category_code = :category
              AND st.period_year = :year
              AND st.period_month = 0
              AND st.rank_position IS NOT NULL
            ORDER BY st.rank_position, st.school_id
            LIMIT 1
        """),
        {"category": category, "year": year},
    ).scalar()
    if school_id is None:
        raise HTTPException(404, "No ranked school for this category and year")
    return _performance(db, school_id, category, year)


@router.get("/{school_id}", response_model=SchoolDetail)
def get_school(school_id: int, db: Session = Depends(get_db)):
    """Full school profile: contacts, categories with prices, branches, yearly stats, ratings."""
    school = db.execute(
        text("""
            SELECT s.school_id AS id,
                   s.name,
                   s.short_name,
                   s.is_verified AS verified,
                   s.legal_form,
                   s.license_number,
                   to_char(s.license_expiry_date, 'YYYY-MM-DD') AS license_expiry_date,
                   s.founded_year,
                   s.description,
                   l.name_ro AS city,
                   r.name_ro AS district,
                   s.address,
                   s.latitude,
                   s.longitude,
                   s.phone,
                   s.email,
                   s.website,
                   (SELECT count(*) FROM instructori i
                     WHERE i.school_id = s.school_id AND i.is_active) AS instructors_count,
                   (SELECT count(*) FROM vehicule v
                     WHERE v.school_id = s.school_id AND v.is_active) AS vehicles_count
            FROM scoli_auto s
            LEFT JOIN localitati l ON l.locality_id = s.locality_id
            LEFT JOIN raioane r ON r.district_id = l.district_id
            WHERE s.school_id = :id AND s.is_active
        """),
        {"id": school_id},
    ).mappings().one_or_none()
    if school is None:
        raise HTTPException(404, "School not found")

    params = {"id": school_id}

    categories = db.execute(
        text("""
            SELECT c.category_code AS code, c.price, c.currency,
                   c.theory_hours, c.practice_hours, c.duration_weeks
            FROM categorii_scoli_auto c
            LEFT JOIN categorii_permise cp ON cp.category_code = c.category_code
            WHERE c.school_id = :id AND c.is_active
            ORDER BY cp.sort_order NULLS LAST, c.category_code
        """),
        params,
    ).mappings().all()

    branches = db.execute(
        text("""
            SELECT f.branch_id AS id, f.name, l.name_ro AS city, f.address,
                   f.latitude, f.longitude, f.phone, f.has_training_ground
            FROM filiale_scoli_auto f
            LEFT JOIN localitati l ON l.locality_id = f.locality_id
            WHERE f.school_id = :id AND f.is_active
            ORDER BY f.branch_id
        """),
        params,
    ).mappings().all()

    stats = db.execute(
        text(f"""
            SELECT {STATS_COLUMNS}
            FROM statistici_scoli_perioade st
            LEFT JOIN categorii_permise cp ON cp.category_code = st.category_code
            WHERE st.school_id = :id AND st.period_month = 0
            ORDER BY st.period_year DESC, cp.sort_order NULLS LAST, st.category_code
        """),
        params,
    ).mappings().all()

    rating = db.execute(
        text(f"""
            SELECT round(avg(rating_overall), 2) AS overall,
                   round(avg(rating_theory), 2) AS theory,
                   round(avg(rating_practice), 2) AS practice,
                   round(avg(rating_instructors), 2) AS instructors,
                   round(avg(rating_vehicles), 2) AS vehicles,
                   round(avg(rating_price), 2) AS price,
                   count(*) AS reviews_count
            FROM recenzii
            WHERE school_id = :id AND {VISIBLE_REVIEW}
        """),
        params,
    ).mappings().one()

    return {
        **school,
        "has_own_training_ground": any(b["has_training_ground"] for b in branches),
        "categories": categories,
        "branches": branches,
        "stats": stats,
        "rating": rating,
    }


@router.get("/{school_id}/performance", response_model=Performance)
def get_school_performance(
    school_id: int,
    category: str = Query("B"),
    year: int | None = Query(None, description="Latest year with data for this school if omitted"),
    db: Session = Depends(get_db),
):
    """Yearly stats plus a month-by-month series for charts."""
    if year is None:
        year = db.execute(
            text("""
                SELECT max(period_year) FROM statistici_scoli_perioade
                WHERE school_id = :id AND category_code = :category AND period_month = 0
            """),
            {"id": school_id, "category": category},
        ).scalar()

    result = _performance(db, school_id, category, year) if year else None
    if result is None:
        raise HTTPException(404, "No statistics for this school, category and year")
    return result


@router.get("/{school_id}/reviews", response_model=ReviewList)
def list_school_reviews(
    school_id: int,
    category: str | None = Query(None),
    limit: int = Query(10, ge=1, le=50),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    rows = db.execute(
        text(f"""
            SELECT r.review_id AS id,
                   u.full_name AS author,
                   r.category_code AS category,
                   r.rating_overall,
                   r.rating_theory,
                   r.rating_practice,
                   r.rating_instructors,
                   r.rating_vehicles,
                   r.rating_price,
                   r.title,
                   r.comment_text AS comment,
                   r.is_verified_graduate,
                   r.created_at,
                   count(*) OVER () AS total
            FROM recenzii r
            LEFT JOIN utilizatori u ON u.user_id = r.user_id
            WHERE r.school_id = :id
              AND r.{VISIBLE_REVIEW}
              AND (CAST(:category AS varchar) IS NULL OR r.category_code = :category)
            ORDER BY r.created_at DESC, r.review_id DESC
            LIMIT :limit OFFSET :offset
        """),
        {"id": school_id, "category": category, "limit": limit, "offset": offset},
    ).mappings().all()

    total = rows[0]["total"] if rows else 0
    return {"total": total, "items": rows}
