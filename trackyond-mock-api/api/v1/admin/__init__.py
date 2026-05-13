from fastapi import APIRouter
from . import auth, company, members, dashboard, attendance, jobs, profiles, notifications

router = APIRouter(prefix="/admin")

router.include_router(auth.router)
router.include_router(company.router)
router.include_router(members.router)
router.include_router(dashboard.router)
router.include_router(attendance.router)
router.include_router(jobs.router)
router.include_router(profiles.router)
router.include_router(notifications.router)
