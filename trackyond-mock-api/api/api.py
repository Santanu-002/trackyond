from fastapi import APIRouter
from .v1 import admin, employee, auth, common

api_router = APIRouter()
api_router.include_router(auth.router)
api_router.include_router(admin.router)
api_router.include_router(employee.router)
api_router.include_router(common.router)
