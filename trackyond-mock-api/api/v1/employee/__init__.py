from fastapi import APIRouter
from . import auth, attendance, profiles

router = APIRouter(prefix="/employee")

router.include_router(auth.router)
router.include_router(attendance.router)
router.include_router(profiles.router)
