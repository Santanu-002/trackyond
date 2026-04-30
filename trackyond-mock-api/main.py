from contextlib import asynccontextmanager
from fastapi import FastAPI
from core.utils.datetime_utils import to_utc_iso
from db import database
from fastapi.exceptions import RequestValidationError
from api.api import api_router
from core.errors.exceptions import AppException, app_exception_handler, validation_exception_handler
from core.middleware.device_metadata import DeviceMetadataMiddleware
from core.database.redis_client import get_redis
import os
import sys
import subprocess
import logging


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager for startup and shutdown events."""
    try:
        print("[STARTUP] Applying database migrations...")
        # Use sys.executable so we always invoke the same Python env as the running process.
        result = subprocess.run(
            [sys.executable, "-m", "alembic", "upgrade", "head"],
            check=True,
            capture_output=True,
            text=True,
        )
        print(f"[STARTUP] Migrations applied successfully:\n{result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"[STARTUP] Migration failed:\n{e.stderr}")
    except Exception as e:
        print(f"[STARTUP] Unexpected error during migration: {e}")
    yield


app = FastAPI(title="Trackyond Mock API", lifespan=lifespan)

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
