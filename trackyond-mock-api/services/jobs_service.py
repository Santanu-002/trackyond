from sqlalchemy.orm import Session
from sqlalchemy import desc, asc, or_, and_
import uuid
from typing import Optional
from db import models
from core.constants.enums import JobStatus
from core.utils.datetime_utils import now_utc
from services.serializers import serialize_job
from services.notification_service import create_notification

def get_admin_jobs(
    db: Session,
    admin_uid: str,
    limit: int,
    offset: int,
    order_by: str,
    order: str,
    status: Optional[list[str]],
    worker_ids: Optional[list[str]],
    search: Optional[str],
    search_by: str,
    from_date: Optional[str],
    to_date: Optional[str],
    logical_operator: str
):
    if from_date and to_date and from_date > to_date:
        return None, "Start date cannot be after end date"

    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin_uid).first()
    if not admin_member:
        return None, "Admin profile not found"

    company_uid = admin_member.company_uid

    query = db.query(
        models.Job, 
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.Job.worker_account_uid == models.Member.account_uid
    ).filter(models.Job.company_uid == company_uid)

    filter_clauses = []

    if status:
        valid_statuses = []
        for s in status:
            try:
                valid_statuses.append(JobStatus(s))
            except (ValueError, KeyError):
                continue
        if valid_statuses:
            filter_clauses.append(models.Job.status.in_(valid_statuses))

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

    total_count = query.count()
    results = query.limit(limit).offset(offset).all()
    
    total_pages = (total_count + limit - 1) // limit

    jobs_data = [serialize_job(job, worker_name, worker_image) for job, worker_name, worker_image in results]

    return {
        "totalCount": total_count,
        "totalPages": total_pages,
        "itemCount": len(jobs_data),
        "limit": limit,
        "offset": offset,
        "jobs": jobs_data
    }, None


def create_admin_job(db: Session, admin_uid: str, job_data: dict):
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin_uid).first()
    if not admin_member:
        return None, "Admin profile not found"

    new_job = models.Job(
        job_id=uuid.uuid4().hex[:10].upper(),
        title=job_data.get("title"),
        customer_name=job_data.get("customerName"),
        customer_phone=job_data.get("customerPhone"),
        customer_address=job_data.get("customerAddress"),
        worker_account_uid=job_data.get("workerAccountUid"),
        company_uid=admin_member.company_uid,
        created_by=admin_uid,
        status=JobStatus.assigned if job_data.get("workerAccountUid") else JobStatus.pending,
        require_photo_on_start=job_data.get("requirePhotoOnStart", False),
        require_photo_on_complete=job_data.get("requirePhotoOnComplete", False),
        capture_location=job_data.get("captureLocation", True)
    )
    
    if new_job.worker_account_uid:
        new_job.assigned_at = now_utc()

    db.add(new_job)
    db.commit()
    db.refresh(new_job)

    worker_name = None
    worker_image = None
    if new_job.worker_account_uid:
        worker_member = db.query(models.Member).filter(models.Member.account_uid == new_job.worker_account_uid).first()
        if worker_member:
            worker_name = worker_member.name
            worker_image = worker_member.image
            # Create notification for worker
            create_notification(
                db, 
                user_uid=worker_member.user_uid,
                message=f"New job assigned: {new_job.title}"
            )

    return serialize_job(new_job, worker_name, worker_image), None


def notify_job_worker(db: Session, job_id: str):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        return False, "Job not found"
    
    if not job.worker_account_uid:
        return False, "Job not assigned to any worker"
    
    worker_member = db.query(models.Member).filter(models.Member.account_uid == job.worker_account_uid).first()
    if not worker_member:
        return False, "Worker profile not found"
    
    create_notification(
        db,
        user_uid=worker_member.user_uid,
        message=f"Reminder: You have an assigned job: {job.title}"
    )

    return True, None


def get_employee_assigned_jobs(
    db: Session,
    primary_account_uid: str,
    limit: int,
    offset: int,
    order_by: str,
    order: str,
    status: Optional[list[str]],
    search: Optional[str],
    search_by: str,
    from_date: Optional[str],
    to_date: Optional[str]
):
    member = db.query(models.Member).filter(models.Member.account_uid == primary_account_uid).first()
    if not member:
        return None, "Member profile not found"

    query = db.query(
        models.Job,
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.Job.worker_account_uid == models.Member.account_uid
    ).filter(models.Job.worker_account_uid == member.account_uid)

    if status:
        query = query.filter(models.Job.status.in_(status))

    if from_date:
        query = query.filter(models.Job.created_at >= from_date)
    if to_date:
        query = query.filter(models.Job.created_at <= to_date)
    
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

    total_count = query.count()
    results = query.limit(limit).offset(offset).all()
    
    total_pages = (total_count + limit - 1) // limit

    jobs_data = [serialize_job(j, worker_name, worker_image) for j, worker_name, worker_image in results]

    return {
        "totalCount": total_count,
        "totalPages": total_pages,
        "itemCount": len(jobs_data),
        "limit": limit,
        "offset": offset,
        "jobs": jobs_data
    }, None


def update_job_status_for_employee(db: Session, primary_account_uid: str, job_id: str, status: JobStatus):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        return False, "Job not found", 404
    
    if job.worker_account_uid != primary_account_uid:
        return False, "Not authorized to update this job", 403

    job.status = status
    db.commit()
    
    return True, None, 200
