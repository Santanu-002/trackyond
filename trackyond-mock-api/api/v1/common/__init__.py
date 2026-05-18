from fastapi import APIRouter
from . import files, notifications, job_chat

router = APIRouter(prefix="/common")

router.include_router(files.router)
router.include_router(notifications.router)
router.include_router(job_chat.router)
