from fastapi import APIRouter, Depends, Query, HTTPException, Body
from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from core.utils.datetime_utils import to_utc_iso
from api.dependencies import get_current_user
from typing import Optional
from core.constants.enums import JobStatus


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
    # Fetch user's primary member profile
    member = db.query(models.Member).filter(models.Member.account_uid == user.primary_account_uid).first()
    if not member:
        return GenericResponse(success=False, message="Member profile not found")

    query = db.query(models.Job).filter(models.Job.worker_account_uid == member.account_uid)

    # 1. Multi-Status Filtering
    if status:
        query = query.filter(models.Job.status.in_(status))

    # 2. Date Range Filtering
    if from_date:
        query = query.filter(models.Job.created_at >= from_date)
    if to_date:
        query = query.filter(models.Job.created_at <= to_date)
    
    # 3. Advanced Search
    if search:
        search_term = f"%{search}%"
        if search_by == "title":
            query = query.filter(models.Job.title.ilike(search_term))
        elif search_by == "customer":
            query = query.filter(
                (models.Job.customer_name.ilike(search_term)) |
                (models.Job.customer_phone.ilike(search_term))
            )
        elif search_by == "address":
            query = query.filter(models.Job.customer_address.ilike(search_term))
        else: # "all"
            query = query.filter(
                (models.Job.title.ilike(search_term)) | 
                (models.Job.customer_name.ilike(search_term)) |
                (models.Job.customer_address.ilike(search_term))
            )

    # 4. Sorting
    order_map = {
        "createdAt": models.Job.created_at,
        "jobTitle": models.Job.title,
        "status": models.Job.status,
    }
    sort_column = order_map.get(order_by, models.Job.created_at)
    
    if order.lower() == "asc":
        query = query.order_by(asc(sort_column))
    else:
        query = query.order_by(desc(sort_column))

    # 5. Pagination & Metadata
    total_count = query.count()
    jobs = query.limit(limit).offset(offset).all()
    
    total_pages = (total_count + limit - 1) // limit

    jobs_data = []
    for j in jobs:
        jobs_data.append({
            "jobId": j.job_id,
            "jobTitle": j.title,
            "customerName": j.customer_name,
            "customerPhone": j.customer_phone,
            "customerAddress": j.customer_address,
            "status": j.status,
            "requirePhotoOnStart": j.require_photo_on_start,
            "requirePhotoOnComplete": j.require_photo_on_complete,
            "captureLocation": j.capture_location,
            "createdAt": to_utc_iso(j.created_at),
            "assignedAt": to_utc_iso(j.assigned_at) if j.assigned_at else None,
            "updatedAt": to_utc_iso(j.updated_at) if j.updated_at else None,
            "completedAt": to_utc_iso(j.completed_at) if j.completed_at else None
        })

    return GenericResponse(
        success=True,
        message="Assigned jobs fetched successfully",
        data={
            "totalCount": total_count,
            "totalPages": total_pages,
            "itemCount": len(jobs_data),
            "limit": limit,
            "offset": offset,
            "jobs": jobs_data
        }
    )

@router.patch("/{job_id}/status", response_model=GenericResponse)
async def update_job_status(
    job_id: str,
    status: JobStatus = Body(..., embed=True),

    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    
    # Check if job is assigned to this user
    if job.worker_account_uid != user.primary_account_uid:
        raise HTTPException(status_code=403, detail="Not authorized to update this job")

    job.status = status
    db.commit()
    
    return GenericResponse(
        success=True,
        message=f"Job status updated to {status}"
    )
