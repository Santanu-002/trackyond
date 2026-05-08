from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from core.utils.datetime_utils import to_utc_iso
from api.dependencies import get_admin_user
import uuid
from typing import Optional

router = APIRouter(prefix="/jobs", tags=["Admin/Jobs"])

@router.get("", response_model=GenericResponse)
async def get_jobs(
    limit: int = Query(20, ge=1),
    offset: int = Query(0, ge=0),
    order_by: str = Query("createdAt", alias="orderBy"),
    order: str = Query("desc"),
    status: Optional[str] = None,
    worker_id: Optional[str] = Query(None, alias="workerId"),
    search: Optional[str] = Query(None, description="Search by title or customer name"),
    title: Optional[str] = None,
    customer_name: Optional[str] = Query(None, alias="customerName"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Fetch admin's company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin.uid).first()
    if not admin_member:
        return GenericResponse(success=False, message="Admin profile not found")

    query = db.query(models.Job).filter(models.Job.company_uid == admin_member.company_uid)

    # Filtering
    if status:
        query = query.filter(models.Job.status == status)
    if worker_id:
        query = query.filter(models.Job.worker_account_uid == worker_id)
    if title:
        query = query.filter(models.Job.title.ilike(f"%{title}%"))
    if customer_name:
        query = query.filter(models.Job.customer_name.ilike(f"%{customer_name}%"))
    
    # General Search
    if search:
        query = query.filter(
            (models.Job.title.ilike(f"%{search}%")) | 
            (models.Job.customer_name.ilike(f"%{search}%"))
        )
    
    # Sorting
    order_map = {
        "createdAt": models.Job.created_at,
        "title": models.Job.title,
        "status": models.Job.status,
        "customerName": models.Job.customer_name,
    }
    
    sort_column = order_map.get(order_by, models.Job.created_at)
    
    if order.lower() == "asc":
        query = query.order_by(asc(sort_column))
    else:
        query = query.order_by(desc(sort_column))

    # Pagination
    total_count = query.count()
    jobs = query.limit(limit).offset(offset).all()

    return GenericResponse(
        success=True,
        message="Jobs fetched successfully",
        data={
            "totalCount": total_count,
            "limit": limit,
            "offset": offset,
            "jobs": [
                {
                    "jobId": j.job_id,
                    "title": j.title,
                    "customerName": j.customer_name,
                    "customerPhone": j.customer_phone,
                    "customerAddress": j.customer_address,
                    "workerAccountUid": j.worker_account_uid,
                    "status": j.status,
                    "requirePhotoOnStart": j.require_photo_on_start,
                    "requirePhotoOnComplete": j.require_photo_on_complete,
                    "captureLocation": j.capture_location,
                    "createdAt": to_utc_iso(j.created_at),
                    "assignedAt": to_utc_iso(j.assigned_at) if j.assigned_at else None
                } for j in jobs
            ]
        }
    )

@router.post("", response_model=GenericResponse)
async def create_job(
    job_data: dict, 
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Fetch admin's company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin.uid).first()
    if not admin_member:
        return GenericResponse(success=False, message="Admin profile not found")

    new_job = models.Job(
        job_id=uuid.uuid4().hex[:10].upper(),
        title=job_data.get("title"),
        customer_name=job_data.get("customerName"),
        customer_phone=job_data.get("customerPhone"),
        customer_address=job_data.get("customerAddress"),
        worker_account_uid=job_data.get("workerAccountUid"),
        company_uid=admin_member.company_uid,
        created_by=admin.uid,
        status="assigned" if job_data.get("workerAccountUid") else "pending",
        require_photo_on_start=job_data.get("requirePhotoOnStart", False),
        require_photo_on_complete=job_data.get("requirePhotoOnComplete", False),
        capture_location=job_data.get("captureLocation", True)
    )
    
    if new_job.worker_account_uid:
        from core.utils.datetime_utils import now_utc
        new_job.assigned_at = now_utc()

    db.add(new_job)
    db.commit()
    db.refresh(new_job)

    return GenericResponse(
        success=True,
        message="Job created successfully",
        data={
            "jobId": new_job.job_id,
            "status": new_job.status,
            "createdAt": to_utc_iso(new_job.created_at)
        }
    )

@router.post("/{job_id}/notify", response_model=GenericResponse)
async def notify_job(
    job_id: str,
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        return GenericResponse(success=False, message="Job not found")
    
    # Mock notification logic
    return GenericResponse(
        success=True,
        message=f"Notification sent for job {job_id}"
    )
