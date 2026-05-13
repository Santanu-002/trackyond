from fastapi import APIRouter
from . import files, notifications

router = APIRouter(prefix="/common")

router.include_router(files.router)
router.include_router(notifications.router)
