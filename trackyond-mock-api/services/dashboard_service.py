from sqlalchemy.orm import Session
from sqlalchemy import desc
from db import models
from core.utils.datetime_utils import now_utc
from core.constants.enums import JobStatus, AttendanceStatus
from services.serializers import serialize_attendance, serialize_job, serialize_member_profile
from services.jobs_service import calculate_allowed_actions
from services.notification_service import get_unread_notification_count

def get_admin_dashboard_data(db: Session, admin_uid: str):
    # Fetch admin's member profile to get company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin_uid).first()
    if not admin_member:
        return None, "Admin profile not found"

    company_uid = admin_member.company_uid

    # 1. Team Status (Today's attendance for company members)
    members = db.query(models.Member).filter(models.Member.company_uid == company_uid).all()
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    # Bulk fetch attendance for today for all members in this company
    attendances = db.query(models.Attendance).filter(
        models.Attendance.company_uid == company_uid,
        models.Attendance.created_at >= today_start
    ).all()
    
    attendance_map = {}
    for att in attendances:
        # Keep only the latest attendance per profile
        if att.profile_uid not in attendance_map or att.created_at > attendance_map[att.profile_uid].created_at:
            attendance_map[att.profile_uid] = att

    team_status = []
    for m in members:
        # Don't show the admin in the team list
        if m.user_uid == admin_uid:
            continue

        latest = attendance_map.get(m.uid)
            
        team_status.append({
            "profile": serialize_member_profile(m),
            "todayAttendance": serialize_attendance(latest)
        })
    
    # 2. Job Statistics
    def get_admin_counts(start_date=None):
        from sqlalchemy import func, case
        
        base_filters = [models.JobView.company_uid == company_uid]
        if start_date:
            base_filters.append(
                (models.JobView.created_at >= start_date) | 
                (models.JobView.completed_at >= start_date) | 
                (models.JobView.updated_at >= start_date)
            )
            
        stats = db.query(
            func.sum(case((models.JobView.status.in_([JobStatus.pending, JobStatus.assigned]), 1), else_=0)).label("pending"),
            func.sum(case((models.JobView.status == JobStatus.in_progress, 1), else_=0)).label("inProgress"),
            func.sum(case((models.JobView.status == JobStatus.completed, 1), else_=0)).label("completed"),
            func.sum(case((models.JobView.status == JobStatus.cancelled, 1), else_=0)).label("cancelled")
        ).filter(*base_filters).first()
        
        return {
            "pending": stats.pending or 0,
            "inProgress": stats.inProgress or 0,
            "completed": stats.completed or 0,
            "cancelled": stats.cancelled or 0,
        }

    # 3. Recent Jobs (last 10)
    recent_jobs_results = db.query(
        models.JobView,
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.JobView.worker_profile_uid == models.Member.uid
    ).filter(
        models.JobView.company_uid == company_uid
    ).order_by(desc(models.JobView.created_at)).limit(10).all()

    recent_jobs = [serialize_job(j, worker_name, worker_image) for j, worker_name, worker_image in recent_jobs_results]
    
    # 4. Chart Data (Jobs by status)
    from sqlalchemy import func
    status_counts = db.query(
        models.JobView.status, 
        func.count(models.JobView.id)
    ).filter(
        models.JobView.company_uid == company_uid
    ).group_by(models.JobView.status).all()
    
    chart_data = {"pending": 0, "inProgress": 0, "completed": 0, "cancelled": 0}
    status_map = {
        JobStatus.pending: "pending",
        JobStatus.assigned: "pending",
        JobStatus.in_progress: "inProgress",
        JobStatus.completed: "completed",
        JobStatus.cancelled: "cancelled"
    }

    for status, count in status_counts:
        mapped_status = status_map.get(status)
        if mapped_status and mapped_status in chart_data:
            chart_data[mapped_status] += count

    return {
        "teamMembersStatus": team_status,
        "unreadNotificationCount": get_unread_notification_count(db, admin_uid),
        "jobCounts": {
            "todayStats": get_admin_counts(today_start),
            "overallStats": get_admin_counts(),
        },
        "jobChart": [
            {"label": "Pending", "value": chart_data["pending"], "color": "0xFFFBBF24"},
            {"label": "In Progress", "value": chart_data["inProgress"], "color": "0xFF3B82F6"},
            {"label": "Completed", "value": chart_data["completed"], "color": "0xFF10B981"},
            {"label": "Cancelled", "value": chart_data["cancelled"], "color": "0xFFB00020"},
        ],
        "recentJobs": recent_jobs
    }, None

def get_employee_dashboard_data(db: Session, user_uid: str, profile_uid: str):
    if not profile_uid:
        return None, "No active profile found"

    active_member = db.query(models.Member).filter(
        models.Member.uid == profile_uid
    ).first()

    if not active_member:
        return None, "Active profile not found"

    # 1. Get today's attendance
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    latest_attendance = db.query(models.Attendance).filter(
        models.Attendance.profile_uid == active_member.uid,
        models.Attendance.created_at >= today_start
    ).order_by(desc(models.Attendance.created_at)).first()

    attendance_data = serialize_attendance(latest_attendance)
    status = attendance_data["status"] if attendance_data else AttendanceStatus.not_started

    # 2. Get assigned and in-progress jobs
    active_jobs_results = db.query(
        models.JobView,
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.JobView.worker_profile_uid == models.Member.uid
    ).filter(
        models.JobView.worker_profile_uid == active_member.uid,
        models.JobView.status.in_([JobStatus.assigned, JobStatus.in_progress])
    ).order_by(desc(models.JobView.assigned_at)).all()

    assigned_jobs = []
    for j, worker_name, worker_image in active_jobs_results:
        allowed_actions = calculate_allowed_actions(db, j)
        assigned_jobs.append(serialize_job(j, worker_name, worker_image, allowed_actions=allowed_actions))

    # 3. Get recent jobs (last 10, sorted by assigned_at)
    recent_jobs_results = db.query(
        models.JobView,
        models.Member.name.label("worker_name"),
        models.Member.image.label("worker_image")
    ).outerjoin(
        models.Member, models.JobView.worker_profile_uid == models.Member.uid
    ).filter(
        models.JobView.worker_profile_uid == active_member.uid
    ).order_by(desc(models.JobView.assigned_at)).limit(10).all()

    recent_jobs = []
    for j, worker_name, worker_image in recent_jobs_results:
        allowed_actions = calculate_allowed_actions(db, j)
        recent_jobs.append(serialize_job(j, worker_name, worker_image, allowed_actions=allowed_actions))

    # 4. Summary Stats
    def get_counts(start_date=None):
        from sqlalchemy import func, case
        base_filters = [models.JobView.worker_profile_uid == active_member.uid]
        if start_date:
            base_filters.append(
                (models.JobView.assigned_at >= start_date) | 
                (models.JobView.completed_at >= start_date) | 
                (models.JobView.updated_at >= start_date)
            )
            
        stats = db.query(
            func.sum(case((models.JobView.status == JobStatus.assigned, 1), else_=0)).label("pending"),
            func.sum(case((models.JobView.status == JobStatus.in_progress, 1), else_=0)).label("inProgress"),
            func.sum(case((models.JobView.status == JobStatus.completed, 1), else_=0)).label("completed"),
            func.sum(case((models.JobView.status == JobStatus.cancelled, 1), else_=0)).label("cancelled"),
            func.sum(case(((models.JobView.status == JobStatus.completed) & (models.JobView.completed_at >= today_start), 1), else_=0)).label("completedToday"),
            func.sum(case((models.JobView.status.in_([JobStatus.assigned, JobStatus.in_progress]), 1), else_=0)).label("totalAssigned")
        ).filter(*base_filters).first()
        
        return {
            "pending": stats.pending or 0,
            "inProgress": stats.inProgress or 0,
            "completed": stats.completed or 0,
            "cancelled": stats.cancelled or 0,
            "completedToday": stats.completedToday or 0,
            "totalAssigned": stats.totalAssigned or 0,
        }

    return {
        "attendanceStatus": {
            "status": status,
            "attendance": attendance_data
        },
        "unreadNotificationCount": get_unread_notification_count(db, user_uid),
        "recentJobs": recent_jobs,
        "jobCounts": {
            "todayStats": get_counts(today_start),
            "overallStats": get_counts()
        }
    }, None
