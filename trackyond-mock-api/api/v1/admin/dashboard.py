from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from api.dependencies import get_admin_user
from services.dashboard_service import get_admin_dashboard_data

router = APIRouter(prefix="/dashboard", tags=["Admin/Dashboard"])

@router.get("", response_model=GenericResponse)
async def get_dashboard(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = get_admin_dashboard_data(db, admin.uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data=data
    )
