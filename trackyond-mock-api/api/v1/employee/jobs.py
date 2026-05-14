from fastapi import APIRouter, Depends, Query, HTTPException, Body
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from api.dependencies import get_current_user
from typing import Optional
from core.constants.enums import JobStatus
from services.jobs_service import get_employee_assigned_jobs, update_job_status_for_employee


router = APIRouter(prefix="/jobs", tags=["Employee/Jobs"])

@router.get("", response_model=GenericResponse)
async def get_assigned_jobs(
    limit: int = Query(20, ge=1),
    offset: int = Query(0, ge=0),
    order_by: str = Query("createdAt", alias="orderBy"),
    order: str = Query("desc"),
    status: Optional[list[str]] = Query(None, alias="statuses"),
    search: Optional[str] = Query(None, description="Search across multiple fields"),
    search_by: str = Query("all", alias="searchBy"),
    from_date: Optional[str] = Query(None, alias="fromDate"),
    to_date: Optional[str] = Query(None, alias="toDate"),
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    data, error = get_employee_assigned_jobs(
        db=db,
        primary_profile_uid=user.primary_profile_uid,
        limit=limit,
        offset=offset,
        order_by=order_by,
        order=order,
        status=status,
        search=search,
        search_by=search_by,
        from_date=from_date,
        to_date=to_date
    )

    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Assigned jobs fetched successfully",
        data=data
    )

@router.patch("/{job_id}/status", response_model=GenericResponse)
async def update_job_status(
    job_id: str,
    status: JobStatus = Body(..., embed=True),
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    success, error, code = update_job_status_for_employee(
        db=db,
        primary_profile_uid=user.primary_profile_uid,
        job_id=job_id,
        status=status
    )
    
    if not success:
        raise HTTPException(status_code=code, detail=error)
    
    return GenericResponse(
        success=True,
        message=f"Job status updated to {status}"
    )
