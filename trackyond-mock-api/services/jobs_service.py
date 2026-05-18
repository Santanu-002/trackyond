from sqlalchemy.orm import Session, aliased
from sqlalchemy import desc, asc, or_, and_
import uuid
import json
from typing import Optional
from db import models
from core.constants.enums import JobStatus, NotificationType, ChatMessageType
from core.utils.datetime_utils import now_utc
from services.serializers import serialize_job
from services.notification_service import create_notification
from services.job_chat_service import create_system_activity_message

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

    # Aliases for Member table to join twice
    worker_member = aliased(models.Member)
    creator_member = aliased(models.Member)

    query = db.query(
        models.Job, 
        worker_member.name.label("worker_name"),
        worker_member.image.label("worker_image"),
        creator_member.name.label("creator_name")
    ).outerjoin(
        worker_member, models.Job.worker_profile_uid == worker_member.uid
    ).outerjoin(
        creator_member, models.Job.created_by_profile_uid == creator_member.uid
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
        filter_clauses.append(models.Job.worker_profile_uid.in_(worker_ids))
    
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

    jobs_data = [serialize_job(job, worker_name, worker_image, creator_name) for job, worker_name, worker_image, creator_name in results]

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
        worker_profile_uid=job_data.get("workerProfileUid"),
        company_uid=admin_member.company_uid,
        created_by=admin_uid,
        created_by_profile_uid=admin_member.uid,
        status=JobStatus.assigned if job_data.get("workerProfileUid") else JobStatus.pending,
        require_photo_on_start=job_data.get("requirePhotoOnStart", False),
        require_photo_on_complete=job_data.get("requirePhotoOnComplete", False),
        capture_location=job_data.get("captureLocation", True)
    )
    
    if new_job.worker_profile_uid:
        new_job.assigned_at = now_utc()

    db.add(new_job)
    db.commit()
    db.refresh(new_job)

    worker_name = None
    worker_image = None
    if new_job.worker_profile_uid:
        worker_member = db.query(models.Member).filter(models.Member.uid == new_job.worker_profile_uid).first()
        if worker_member:
            worker_name = worker_member.name
            worker_image = worker_member.image
            
            serialized_job = serialize_job(new_job, worker_name, worker_image, admin_member.name)
            
            # Log job assignment to chat timeline
            create_system_activity_message(
                db=db,
                job_id=new_job.job_id,
                text=f"@[profileUid#{admin_member.uid}] created this job and assigned to @[profileUid#{new_job.worker_profile_uid}]",
                message_type=ChatMessageType.header
            )
            
            # Create notification for worker
            create_notification(
                db=db,
                user_uid=worker_member.user_uid,
                profile_uid=worker_member.uid,
                title="New Job Assigned",
                body=f"<b>Job#{new_job.job_id}</b> : {new_job.title}<br>You have been assigned a new job.",
                notification_type=NotificationType.job_assigned,
                extra_data={
                    "job": json.dumps(serialized_job)
                }
            )

    return serialized_job, None


def create_mock_job_for_employee(db: Session, user_uid: str):
    # Find the member profile for this user
    member = db.query(models.Member).filter(models.Member.user_uid == user_uid).first()
    if not member:
        return None, "Member profile not found"

    new_job = models.Job(
        job_id=uuid.uuid4().hex[:10].upper(),
        title=f"Mock Demo Job {now_utc().second}",
        customer_name="Demo Customer",
        customer_phone="0000000000",
        customer_address="123 Test Street, Mock City",
        worker_profile_uid=member.uid,
        company_uid=member.company_uid,
        created_by=user_uid,
        status=JobStatus.assigned,
        assigned_at=now_utc(),
        require_photo_on_start=False,
        require_photo_on_complete=False,
        capture_location=False
    )

    db.add(new_job)
    db.commit()
    db.refresh(new_job)
    
    serialized_job = serialize_job(new_job, member.name, member.image, member.name)
    
    # Create notification for worker
    create_notification(
        db=db,
        user_uid=member.user_uid,
        profile_uid=member.uid,
        title="Job Cancelled",
        body=f"<b>Job#{new_job.job_id}</b> : {new_job.title}<br>This job has been cancelled.",
        notification_type=NotificationType.system,
        extra_data={
            "job": json.dumps(serialized_job)
        }
    )

    return serialized_job, None


def notify_job_worker(db: Session, job_id: str):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        return False, "Job not found"
    
    if not job.worker_profile_uid:
        return False, "Job not assigned to any worker"
    
    worker_member = db.query(models.Member).filter(models.Member.uid == job.worker_profile_uid).first()
    if not worker_member:
        return False, "Worker profile not found"
    
    # We might need creator_name here too, but let's assume we can fetch it if needed.
    creator_member = db.query(models.Member).filter(models.Member.uid == job.created_by_profile_uid).first()
    creator_name = creator_member.name if creator_member else None

    serialized_job = serialize_job(job, worker_member.name, worker_member.image, creator_name)
    
    create_notification(
        db=db,
        user_uid=worker_member.user_uid,
        profile_uid=worker_member.uid,
        title="Job Updated",
        body=f"<b>Job#{job.job_id}</b> : {job.title}<br>The details for this job have been updated.",
        notification_type=NotificationType.system,
        extra_data={
            "job": json.dumps(serialized_job)
        }
    )

    return True, None


def get_employee_assigned_jobs(
    db: Session,
    primary_profile_uid: str,
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
    member = db.query(models.Member).filter(models.Member.uid == primary_profile_uid).first()
    if not member:
        return None, "Member profile not found"

    # Aliases for Member table to join twice
    worker_member = aliased(models.Member)
    creator_member = aliased(models.Member)

    query = db.query(
        models.Job,
        worker_member.name.label("worker_name"),
        worker_member.image.label("worker_image"),
        creator_member.name.label("creator_name")
    ).outerjoin(
        worker_member, models.Job.worker_profile_uid == worker_member.uid
    ).outerjoin(
        creator_member, models.Job.created_by_profile_uid == creator_member.uid
    ).filter(models.Job.worker_profile_uid == member.uid)

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

    jobs_data = [serialize_job(j, worker_name, worker_image, creator_name) for j, worker_name, worker_image, creator_name in results]

    return {
        "totalCount": total_count,
        "totalPages": total_pages,
        "itemCount": len(jobs_data),
        "limit": limit,
        "offset": offset,
        "jobs": jobs_data
    }, None


def update_job_status_for_employee(db: Session, primary_profile_uid: str, job_id: str, status: JobStatus):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        return False, "Job not found", 404
    
    if job.worker_profile_uid != primary_profile_uid:
        return False, "Not authorized to update this job", 403

    job.status = status
    db.commit()
    
    return True, None, 200
