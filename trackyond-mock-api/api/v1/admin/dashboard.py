from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from core.utils.datetime_utils import now_utc, to_utc_iso
from api.dependencies import get_admin_user
from core.constants.enums import JobStatus, AttendanceStatus

router = APIRouter(prefix="/dashboard", tags=["Admin/Dashboard"])

@router.get("", response_model=GenericResponse)
async def get_dashboard(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Fetch admin's member profile to get company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin.uid).first()
    if not admin_member:
        return GenericResponse(success=False, message="Admin profile not found")

    company_uid = admin_member.company_uid

    # 1. Team Status (Today's attendance for company members)
    members = db.query(models.Member).filter(models.Member.company_uid == company_uid).all()
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    team_status = []
    for m in members:
        # Don't show the admin in the team list (optional, but usually preferred)
        if m.user_uid == admin.uid:
            continue

        latest = db.query(models.Attendance).filter(
            models.Attendance.account_uid == m.account_uid,
            models.Attendance.created_at >= today_start
        ).order_by(models.Attendance.created_at.desc()).first()
        
        attn_data = None
        if latest:
            status = AttendanceStatus.working if latest.end_at is None else AttendanceStatus.ended

            attn_data = {
                "id": latest.id,
                "accountUid": latest.account_uid,
                "userUid": latest.user_uid,
                "companyUid": latest.company_uid,
                "status": status,
                "startAt": to_utc_iso(latest.start_at),
                "endAt": to_utc_iso(latest.end_at) if latest.end_at else None,
                "workHours": latest.work_hours,
                "startAddress": latest.start_address,
                "endAddress": latest.end_address
            }
            
        team_status.append({
            "profile": {
                "accountUid": m.account_uid,
                "userUid": m.user_uid,
                "name": m.name,
                "phone": m.phone,
                "designation": m.designation,
                "image": m.image,
            },
            "todayAttendance": attn_data
        })
    
    # 2. Job Statistics
    pending_count = db.query(models.Job).filter(
        models.Job.company_uid == company_uid, 
        models.Job.status.in_([JobStatus.pending, JobStatus.assigned])
    ).count()
    
    in_progress_count = db.query(models.Job).filter(
        models.Job.company_uid == company_uid, 
        models.Job.status == JobStatus.in_progress
    ).count()
    
    completed_count = db.query(models.Job).filter(
        models.Job.company_uid == company_uid, 
        models.Job.status == JobStatus.completed
    ).count()


    # 3. Recent Jobs (last 10)
    recent_jobs_models = db.query(models.Job).filter(
        models.Job.company_uid == company_uid
    ).order_by(desc(models.Job.created_at)).limit(10).all()

    recent_jobs = []
    for j in recent_jobs_models:
        recent_jobs.append({
            "jobId": j.job_id,
            "jobTitle": j.title,
            "customerName": j.customer_name,
            "customerPhone": j.customer_phone,
            "customerAddress": j.customer_address,
            "workerAccountUid": j.worker_account_uid,
            "status": j.status,
            "requirePhotoOnStart": j.require_photo_on_start,
            "requirePhotoOnComplete": j.require_photo_on_complete,
            "captureLocation": j.capture_location,
            "createdAt": to_utc_iso(j.created_at),
            "assignedAt": to_utc_iso(j.assigned_at) if j.assigned_at else None,
            "updatedAt": to_utc_iso(j.updated_at) if j.updated_at else None,
            "completedAt": to_utc_iso(j.completed_at) if j.completed_at else None
        })
    
    # 4. Chart Data (Jobs by status)
    # Get all jobs for the company to aggregate for chart
    all_jobs = db.query(models.Job).filter(models.Job.company_uid == company_uid).all()
    
    chart_data = {"pending": 0, "inProgress": 0, "completed": 0, "cancelled": 0}
    # Map statuses to chart keys
    status_map = {
        JobStatus.pending: "pending",
        JobStatus.assigned: "pending",
        JobStatus.in_progress: "inProgress",
        JobStatus.completed: "completed",
        JobStatus.cancelled: "cancelled"
    }


    for job in all_jobs:
        mapped_status = status_map.get(job.status)
        if mapped_status and mapped_status in chart_data:
            chart_data[mapped_status] += 1

    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data={
            "teamMembersStatus": team_status,
            "jobCounts": {
                "pending": pending_count,
                "inProgress": in_progress_count,
                "completed": completed_count,
            },
            "jobChart": [
                {"label": "Pending", "value": chart_data["pending"], "color": "0xFFFBBF24"},
                {"label": "In Progress", "value": chart_data["inProgress"], "color": "0xFF3B82F6"},
                {"label": "Completed", "value": chart_data["completed"], "color": "0xFF10B981"},
                {"label": "Cancelled", "value": chart_data["cancelled"], "color": "0xFFEF4444"},
            ],
            "recentJobs": recent_jobs
        }
    )
