from fastapi import FastAPI

app = FastAPI(
    title="Driving Schools API",
    version="1.0.0",
)


@app.get("/")
def root():
    return {
        "message": "Success"
    }


@app.get("/health")
def health():
    return {
        "status": "ok"
    }