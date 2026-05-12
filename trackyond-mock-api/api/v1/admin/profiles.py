from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from api.dependencies import get_admin_user
from services.profile_service import get_admin_profile_data

router = APIRouter(prefix="/profiles", tags=["Admin/Profiles"])

@router.get("/me", response_model=GenericResponse)
async def get_admin_profile(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    """
    Returns the admin's own member profile and company details.
    """
    data, error = get_admin_profile_data(db, admin.uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Profile fetched successfully",
        data=data
    )
