from fastapi import APIRouter
from . import files

router = APIRouter(prefix="/common")

router.include_router(files.router)
