from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from api.dependencies import get_admin_user
from typing import Optional
from services.jobs_service import get_admin_jobs, create_admin_job, notify_job_worker

router = APIRouter(prefix="/jobs", tags=["Admin/Jobs"])

@router.get("", response_model=GenericResponse)
async def get_jobs(
    limit: int = Query(20, ge=1),
    offset: int = Query(0, ge=0),
    order_by: str = Query("assignedAt", alias="orderBy"),
    order: str = Query("desc"),
    status: Optional[list[str]] = Query(None, alias="statuses[]"),
    worker_ids: Optional[list[str]] = Query(None, alias="workerIds[]"),
    search: Optional[str] = Query(None, description="Search across multiple fields"),
    search_by: str = Query("all", alias="searchBy"),
    from_date: Optional[str] = Query(None, alias="fromDate"),
    to_date: Optional[str] = Query(None, alias="toDate"),
    logical_operator: str = Query("and", alias="logicalOperator"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = get_admin_jobs(
        db=db,
        admin_uid=admin.uid,
        limit=limit,
        offset=offset,
        order_by=order_by,
        order=order,
        status=status,
        worker_ids=worker_ids,
        search=search,
        search_by=search_by,
        from_date=from_date,
        to_date=to_date,
        logical_operator=logical_operator
    )

    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Jobs fetched successfully",
        data=data
    )

@router.post("", response_model=GenericResponse)
async def create_job(
    job_data: dict, 
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = create_admin_job(db, admin.uid, job_data)
    
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Job created successfully",
        data=data
    )

@router.post("/{job_id}/notify", response_model=GenericResponse)
async def notify_job(
    job_id: str,
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user) # Keep dependency for auth
):
    success, error = notify_job_worker(db, job_id)
    
    if error:
         return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message=f"Notification sent for job {job_id}"
    )
