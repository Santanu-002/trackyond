from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from api.dependencies import get_current_user
from services.dashboard_service import get_employee_dashboard_data

router = APIRouter(prefix="/dashboard", tags=["Employee/Dashboard"])

@router.get("", response_model=GenericResponse)
async def get_employee_dashboard(
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    data, error = get_employee_dashboard_data(db, user.uid, user.primary_account_uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Employee dashboard fetched successfully",
        data=data
    )
