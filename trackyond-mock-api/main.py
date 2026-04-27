from fastapi import FastAPI
from datetime import datetime
from core.utils.datetime_utils import to_utc_iso
from db import models, database
from fastapi.exceptions import RequestValidationError
from fastapi.staticfiles import StaticFiles
from api.api import api_router
from core.errors.exceptions import AppException, app_exception_handler, validation_exception_handler
from core.middleware.device_metadata import DeviceMetadataMiddleware
from core.database.redis_client import get_redis
import os

# Create tables / Apply migrations
import subprocess
import logging

def run_migrations():
    try:
        logging.info("Running database migrations...")
        # Run alembic upgrade head
        result = subprocess.run(["alembic", "upgrade", "head"], capture_output=True, text=True)
        if result.returncode != 0:
            logging.error(f"Migration failed: {result.stderr}")
        else:
            logging.info("Migrations applied successfully.")
    except Exception as e:
        logging.error(f"Error running migrations: {str(e)}")

# Apply migrations on startup
run_migrations()
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="Trackyond Mock API")

# Register Exception Handlers
app.add_exception_handler(AppException, app_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)

# Register Middleware
app.add_middleware(DeviceMetadataMiddleware)

# Include Routers with /api prefix
app.include_router(api_router, prefix="/api")

# Redis client
r = get_redis()

@app.get("/")
async def root():
    return {
        "message": "Welcome to Trackyond Mock API (Modularized)",
        "docs": "/docs",
        "infrastructure": {
            "postgres": "ready",
            "redis": "ready",
            "pgadmin": "available on :5050"
        }
    }

@app.get("/health")
async def health():
    health_status = {
        "status": "healthy",
        "timestamp": to_utc_iso(),
        "services": {
            "api": "online",
            "database": "unknown",
            "redis": "unknown"
        }
    }
    
    # Check Postgres
    try:
        db = database.SessionLocal()
        from sqlalchemy import text
        db.execute(text("SELECT 1"))
        health_status["services"]["database"] = "reachable"
        db.close()
    except Exception as e:
        health_status["services"]["database"] = f"unreachable: {str(e)}"
        health_status["status"] = "degraded"

    # Check Redis
    try:
        r.ping()
        health_status["services"]["redis"] = "reachable"
    except Exception as e:
        health_status["services"]["redis"] = f"unreachable: {str(e)}"
        health_status["status"] = "degraded"

    return health_status

if __name__ == "__main__":
    import uvicorn
    is_dev = os.getenv("APP_ENV") == "development"
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=is_dev)
