from fastapi import APIRouter
from . import auth, company, members, dashboard

router = APIRouter(prefix="/admin")

router.include_router(auth.router)
router.include_router(company.router)
router.include_router(members.router)
router.include_router(dashboard.router)
