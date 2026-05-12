from fastapi import APIRouter
from . import auth, attendance, profiles, jobs, dashboard

router = APIRouter(prefix="/employee")

router.include_router(auth.router)
router.include_router(attendance.router)
router.include_router(profiles.router)
router.include_router(jobs.router)
router.include_router(dashboard.router)
