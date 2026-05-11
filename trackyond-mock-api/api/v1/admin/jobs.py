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
from core.constants.enums import JobStatus


router = APIRouter(prefix="/jobs", tags=["Admin/Jobs"])

@router.get("", response_model=GenericResponse)
async def get_jobs(
    limit: int = Query(20, ge=1),
    offset: int = Query(0, ge=0),
    order_by: str = Query("assignedAt", alias="orderBy"),
    order: str = Query("desc"),
    status: Optional[list[str]] = Query(None, alias="statuses"),
    worker_ids: Optional[list[str]] = Query(None, alias="workerIds"),
    search: Optional[str] = Query(None, description="Search across multiple fields"),
    search_by: str = Query("all", alias="searchBy"),
    from_date: Optional[str] = Query(None, alias="fromDate"),
    to_date: Optional[str] = Query(None, alias="toDate"),
    logical_operator: str = Query("and", alias="logicalOperator"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # 1. Validation for Date Range
    if from_date and to_date and from_date > to_date:
        return GenericResponse(success=False, message="Start date cannot be after end date")

    # Fetch admin's company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin.uid).first()
    if not admin_member:
        return GenericResponse(success=False, message="Admin profile not found")

    company_uid = admin_member.company_uid

    # Base query
    query = db.query(
        models.Job, 
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.Job.worker_account_uid == models.Member.account_uid
    ).filter(models.Job.company_uid == company_uid)

    # 2. Advanced Filtering Logic (Handling AND/OR)
    from sqlalchemy import or_, and_
    
    filter_clauses = []

    if status:
        filter_clauses.append(models.Job.status.in_(status))

    if worker_ids:
        filter_clauses.append(models.Job.worker_account_uid.in_(worker_ids))
    
    if from_date:
        filter_clauses.append(models.Job.created_at >= from_date)
    if to_date:
        filter_clauses.append(models.Job.created_at <= to_date)
    
    if search:
        search_term = f"%{search}%"
        search_clauses = []
        if search_by == "title":
            search_clauses.append(models.Job.title.ilike(search_term))
        elif search_by == "customer":
            search_clauses.append(models.Job.customer_name.ilike(search_term))
            search_clauses.append(models.Job.customer_phone.ilike(search_term))
        elif search_by == "address":
            search_clauses.append(models.Job.customer_address.ilike(search_term))
        elif search_by == "worker":
            search_clauses.append(models.Member.name.ilike(search_term))
        else: # "all"
            search_clauses.append(models.Job.title.ilike(search_term))
            search_clauses.append(models.Job.customer_name.ilike(search_term))
            search_clauses.append(models.Job.customer_address.ilike(search_term))
            search_clauses.append(models.Member.name.ilike(search_term))
        
        filter_clauses.append(or_(*search_clauses))

    if filter_clauses:
        if logical_operator.lower() == "or":
            query = query.filter(or_(*filter_clauses))
        else:
            query = query.filter(and_(*filter_clauses))
    
    # 3. Sorting
    order_map = {
        "createdAt": models.Job.created_at,
        "assignedAt": models.Job.assigned_at,
        "jobTitle": models.Job.title,
        "status": models.Job.status,
        "customerName": models.Job.customer_name,
        "workerName": models.Member.name,
    }
    
    sort_column = order_map.get(order_by, models.Job.assigned_at)
    
    if order.lower() == "asc":
        query = query.order_by(asc(sort_column))
    else:
        query = query.order_by(desc(sort_column))

    # 6. Pagination & Metadata
    total_count = query.count()
    results = query.limit(limit).offset(offset).all()
    
    total_pages = (total_count + limit - 1) // limit

    jobs_data = []
    for job, worker_name, worker_image in results:
        jobs_data.append({
            "jobId": job.job_id,
            "jobTitle": job.title,
            "customerName": job.customer_name,
            "customerPhone": job.customer_phone,
            "customerAddress": job.customer_address,
            "workerAccountUid": job.worker_account_uid,
            "workerName": worker_name,
            "workerImage": worker_image,
            "status": job.status,
            "requirePhotoOnStart": job.require_photo_on_start,
            "requirePhotoOnComplete": job.require_photo_on_complete,
            "captureLocation": job.capture_location,
            "createdAt": to_utc_iso(job.created_at),
            "assignedAt": to_utc_iso(job.assigned_at) if job.assigned_at else None,
            "updatedAt": to_utc_iso(job.updated_at) if job.updated_at else None,
            "completedAt": to_utc_iso(job.completed_at) if job.completed_at else None
        })

    return GenericResponse(
        success=True,
        message="Jobs fetched successfully",
        data={
            "totalCount": total_count,
            "totalPages": total_pages,
            "itemCount": len(jobs_data),
            "limit": limit,
            "offset": offset,
            "jobs": jobs_data
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
        status=JobStatus.assigned if job_data.get("workerAccountUid") else JobStatus.pending,

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

    # Fetch worker details for the response if assigned
    worker_name = None
    worker_image = None
    if new_job.worker_account_uid:
        worker_member = db.query(models.Member).filter(models.Member.account_uid == new_job.worker_account_uid).first()
        if worker_member:
            worker_name = worker_member.name
            worker_image = worker_member.image

    return GenericResponse(
        success=True,
        message="Job created successfully",
        data={
            "jobId": new_job.job_id,
            "jobTitle": new_job.title,
            "customerName": new_job.customer_name,
            "customerPhone": new_job.customer_phone,
            "customerAddress": new_job.customer_address,
            "workerAccountUid": new_job.worker_account_uid,
            "workerName": worker_name,
            "workerImage": worker_image,
            "status": new_job.status,
            "requirePhotoOnStart": new_job.require_photo_on_start,
            "requirePhotoOnComplete": new_job.require_photo_on_complete,
            "captureLocation": new_job.capture_location,
            "createdAt": to_utc_iso(new_job.created_at),
            "assignedAt": to_utc_iso(new_job.assigned_at) if new_job.assigned_at else None,
            "updatedAt": to_utc_iso(new_job.updated_at) if new_job.updated_at else None,
            "completedAt": to_utc_iso(new_job.completed_at) if new_job.completed_at else None
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
