from datetime import datetime

from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel


class ApiModel(BaseModel):
    """Serializes fields as camelCase to match the frontend TypeScript types."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)


# --- Dictionaries ---------------------------------------------------------

class Category(ApiModel):
    code: str
    parent_code: str | None
    description: str | None
    min_age: int | None


class Locality(ApiModel):
    id: int
    name: str
    district: str
    schools_count: int


class Filters(ApiModel):
    localities: list[Locality]
    categories: list[str]
    years: list[int]


# --- Stats ----------------------------------------------------------------

class Overview(ApiModel):
    year: int | None
    schools_count: int
    localities_count: int
    candidates_count: int
    theory_pass_rate: float | None
    practice_pass_rate: float | None


# --- Schools --------------------------------------------------------------

class SchoolCard(ApiModel):
    id: int
    name: str
    verified: bool

    city: str | None
    address: str | None

    categories: list[str]
    has_own_training_ground: bool

    theory_pass_rate: float | None
    practice_pass_rate: float | None
    first_try_pass_rate: float | None

    rank: int | None
    rating: float | None
    reviews_count: int

    candidates_count: int
    price_from: float | None


class SchoolList(ApiModel):
    total: int
    items: list[SchoolCard]


class Branch(ApiModel):
    id: int
    name: str
    city: str | None
    address: str | None
    latitude: float | None
    longitude: float | None
    phone: str | None
    has_training_ground: bool


class SchoolCategory(ApiModel):
    code: str
    price: float | None
    currency: str
    theory_hours: int | None
    practice_hours: int | None
    duration_weeks: int | None


class SchoolStats(ApiModel):
    category: str
    year: int
    rank: int | None
    candidates_count: int
    theory_pass_rate: float | None
    theory_first_try_rate: float | None
    practice_pass_rate: float | None
    practice_first_try_rate: float | None
    average_attempts: float | None
    average_penalty_points: float | None


class RatingBreakdown(ApiModel):
    overall: float | None
    theory: float | None
    practice: float | None
    instructors: float | None
    vehicles: float | None
    price: float | None
    reviews_count: int


class SchoolDetail(ApiModel):
    id: int
    name: str
    short_name: str | None
    verified: bool
    legal_form: str | None
    license_number: str | None
    license_expiry_date: str | None
    founded_year: int | None
    description: str | None

    city: str | None
    district: str | None
    address: str | None
    latitude: float | None
    longitude: float | None
    phone: str | None
    email: str | None
    website: str | None

    has_own_training_ground: bool
    instructors_count: int
    vehicles_count: int

    categories: list[SchoolCategory]
    branches: list[Branch]
    stats: list[SchoolStats]
    rating: RatingBreakdown


class MonthlyPoint(ApiModel):
    month: int
    theory: float | None
    practice: float | None
    first_try_practice: float | None
    candidates_count: int


class Performance(ApiModel):
    school_id: int
    name: str
    category: str
    year: int
    rank: int | None
    stats: SchoolStats
    performance: list[MonthlyPoint]


class Review(ApiModel):
    id: int
    author: str | None
    category: str | None
    rating_overall: int
    rating_theory: int | None
    rating_practice: int | None
    rating_instructors: int | None
    rating_vehicles: int | None
    rating_price: int | None
    title: str | None
    comment: str | None
    is_verified_graduate: bool
    created_at: datetime


class ReviewList(ApiModel):
    total: int
    items: list[Review]
