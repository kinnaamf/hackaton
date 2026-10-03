from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.config import CORS_ORIGINS
from app.database import get_db
from app.routers import dictionaries, schools, stats

app = FastAPI(
    title="Driving Schools API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(dictionaries.router, prefix="/api")
app.include_router(stats.router, prefix="/api")
app.include_router(schools.router, prefix="/api")


@app.get("/")
def root():
    return {
        "message": "Success"
    }


@app.get("/health")
def health(db: Session = Depends(get_db)):
    db.execute(text("SELECT 1"))
    return {
        "status": "ok"
    }
