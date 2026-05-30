from contextlib import asynccontextmanager
from fastapi import FastAPI
from core.utils.datetime_utils import to_utc_iso
from db import database
from fastapi.exceptions import RequestValidationError
from api.api import api_router
from core.errors.exceptions import AppException, app_exception_handler, validation_exception_handler
from core.middleware.device_metadata import DeviceMetadataMiddleware
from core.database.redis_client import get_redis
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
import os
import sys
import subprocess
import logging
import firebase_admin
from firebase_admin import credentials


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager for startup and shutdown events."""
    # Initialize Firebase Admin
    try:
        fb_cred_path = os.getenv("FIREBASE_CREDENTIALS_JSON")
        project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
        
        if fb_cred_path and os.path.exists(fb_cred_path):
            cred = credentials.Certificate(fb_cred_path)
            firebase_admin.initialize_app(cred, options={'projectId': project_id} if project_id else None)
            print(f"[STARTUP] Firebase Admin initialized with certificate: {fb_cred_path}")
        else:
            firebase_admin.initialize_app(options={'projectId': project_id} if project_id else None)
            print(f"[STARTUP] Firebase Admin initialized with default credentials (Project ID: {project_id})")
    except Exception as e:
        print(f"[STARTUP] Firebase Admin initialization failed or already initialized: {e}")

    # Migrations should be handled externally in CI/CD or via an init container
    yield


app = FastAPI(title="Trackyond Mock API", lifespan=lifespan)

# Setup Rate Limiting
limiter = Limiter(key_func=get_remote_address, default_limits=["100/minute"])
app.state.limiter = limiter

# Register Exception Handlers
app.add_exception_handler(AppException, app_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

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
