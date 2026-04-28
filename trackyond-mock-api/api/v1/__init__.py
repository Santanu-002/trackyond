from fastapi import APIRouter
from . import admin, employee, common

router = APIRouter()

router.include_router(admin.router)
router.include_router(employee.router)
router.include_router(common.router)
