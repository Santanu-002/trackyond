from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from api.dependencies import get_current_user
from core.responses.models import GenericResponse
from services.profile_service import (
    get_employee_profile_data,
    get_employee_profiles_data,
    switch_employee_profile,
)

router = APIRouter(prefix="/profiles", tags=["Employee/Profiles"])

@router.get("", response_model=GenericResponse)
async def get_profiles(
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """
    Returns all membership profiles for the authenticated user across all companies.
    """
    data, error = get_employee_profiles_data(db, user)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Profiles fetched successfully",
        data=data
    )

@router.get("/me", response_model=GenericResponse)
async def get_employee_profile(
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """
    Returns the employee's primary member profile and company details.
    """
    data, error = get_employee_profile_data(db, user)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Profile fetched successfully",
        data=data
    )

@router.post("/switch", response_model=GenericResponse)
async def switch_profile(
    profile_uid: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """
    Switches the user's primary profile to the specified profile_uid.
    """
    data, error = switch_employee_profile(db, user, profile_uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Profile switched successfully",
        data=data
    )
