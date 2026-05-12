from sqlalchemy.orm import Session
from sqlalchemy import desc
from db import models
from core.utils.datetime_utils import now_utc
from core.constants.enums import JobStatus, AttendanceStatus
from services.serializers import serialize_attendance, serialize_job, serialize_member_profile

def get_admin_dashboard_data(db: Session, admin_uid: str):
    # Fetch admin's member profile to get company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin_uid).first()
    if not admin_member:
        return None, "Admin profile not found"

    company_uid = admin_member.company_uid

    # 1. Team Status (Today's attendance for company members)
    members = db.query(models.Member).filter(models.Member.company_uid == company_uid).all()
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    team_status = []
    for m in members:
        # Don't show the admin in the team list
        if m.user_uid == admin_uid:
            continue

        latest = db.query(models.Attendance).filter(
            models.Attendance.account_uid == m.account_uid,
            models.Attendance.created_at >= today_start
        ).order_by(models.Attendance.created_at.desc()).first()
            
        team_status.append({
            "profile": serialize_member_profile(m),
            "todayAttendance": serialize_attendance(latest)
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

    cancelled_count = db.query(models.Job).filter(
        models.Job.company_uid == company_uid, 
        models.Job.status == JobStatus.cancelled
    ).count()

    # 3. Recent Jobs (last 10)
    recent_jobs_results = db.query(
        models.Job,
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.Job.worker_account_uid == models.Member.account_uid
    ).filter(
        models.Job.company_uid == company_uid
    ).order_by(desc(models.Job.created_at)).limit(10).all()

    recent_jobs = [serialize_job(j, worker_name, worker_image) for j, worker_name, worker_image in recent_jobs_results]
    
    # 4. Chart Data (Jobs by status)
    all_jobs = db.query(models.Job).filter(models.Job.company_uid == company_uid).all()
    
    chart_data = {"pending": 0, "inProgress": 0, "completed": 0, "cancelled": 0}
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

    return {
        "teamMembersStatus": team_status,
        "jobCounts": {
            "pending": pending_count,
            "inProgress": in_progress_count,
            "completed": completed_count,
            "cancelled": cancelled_count,
        },
        "jobChart": [
            {"label": "Pending", "value": chart_data["pending"], "color": "0xFFFBBF24"},
            {"label": "In Progress", "value": chart_data["inProgress"], "color": "0xFF3B82F6"},
            {"label": "Completed", "value": chart_data["completed"], "color": "0xFF10B981"},
            {"label": "Cancelled", "value": chart_data["cancelled"], "color": "0xFFB00020"},
        ],
        "recentJobs": recent_jobs
    }, None

def get_employee_dashboard_data(db: Session, user_uid: str, primary_account_uid: str):
    if not primary_account_uid:
        return None, "No active profile found"

    active_member = db.query(models.Member).filter(
        models.Member.account_uid == primary_account_uid
    ).first()

    if not active_member:
        return None, "Active profile not found"

    # 1. Get today's attendance
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    latest_attendance = db.query(models.Attendance).filter(
        models.Attendance.account_uid == active_member.account_uid,
        models.Attendance.created_at >= today_start
    ).order_by(desc(models.Attendance.created_at)).first()

    attendance_data = serialize_attendance(latest_attendance)
    status = attendance_data["status"] if attendance_data else "notStarted"

    # 2. Get assigned jobs
    recent_jobs_results = db.query(
        models.Job,
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.Job.worker_account_uid == models.Member.account_uid
    ).filter(
        models.Job.worker_account_uid == active_member.account_uid,
        models.Job.status.in_(["assigned", "in_progress", "on_hold"])
    ).order_by(desc(models.Job.assigned_at)).limit(20).all()

    assigned_jobs = [serialize_job(j, worker_name, worker_image) for j, worker_name, worker_image in recent_jobs_results]

    return {
        "attendanceStatus": {
            "status": status,
            "attendance": attendance_data
        },
        "assignedJobs": assigned_jobs
    }, None
