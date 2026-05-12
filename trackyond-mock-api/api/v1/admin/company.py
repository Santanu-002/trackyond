from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.admin import CompanyCreate
from core.responses.models import GenericResponse
from api.dependencies import get_admin_user
from services.company_service import (
    company_created_message,
    create_company_data,
    get_admin_company_data,
    get_admin_team_status_data,
)

router = APIRouter(prefix="/company", tags=["Admin/Company"])

@router.post("", response_model=GenericResponse)
async def create_company(req: CompanyCreate, db: Session = Depends(get_db)):
    data, error = create_company_data(db, req)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message=company_created_message(),
        data=data
    )

@router.get("", response_model=GenericResponse)
async def get_company(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = get_admin_company_data(db, admin.uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Company fetched successfully",
        data=data
    )

@router.get("/team-status", response_model=GenericResponse)
async def get_team_status(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user),
    status_filter: str = None, # all | working | notStarted
    order: str = "desc", # asc | desc
    limit: str = None
):
    data, error = get_admin_team_status_data(
        db=db,
        admin_uid=admin.uid,
        status_filter=status_filter,
        order=order,
        limit=limit,
    )
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Team status fetched successfully",
        data=data
    )
