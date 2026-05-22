from sqlalchemy.orm import Session
from sqlalchemy import or_, desc, asc
from datetime import datetime, timezone
from typing import Optional
from db import models
from core.constants.enums import AttendanceStatus
from core.utils.datetime_utils import now_utc
from core.constants.app_strings import strings
from services.serializers import serialize_attendance
from schemas.attendance import MarkAttendanceRequest

def get_admin_attendance_logs(
    db: Session,
    admin_uid: str,
    profile_uid: Optional[str],
    status: Optional[str],
    start_date: Optional[datetime],
    end_date: Optional[datetime],
    search: Optional[str],
    sort_by: str,
    sort_order: str,
    limit: int,
    offset: int
):
    query = db.query(models.Attendance)

    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin_uid).first()
    if not admin_member:
        return None, "Admin profile not found"
    
    query = query.filter(models.Attendance.company_uid == admin_member.company_uid)

    if profile_uid:
        query = query.filter(models.Attendance.profile_uid == profile_uid)
    if status:
        query = query.filter(models.Attendance.status == status)
    if start_date:
        query = query.filter(models.Attendance.start_at >= start_date)
    if end_date:
        query = query.filter(models.Attendance.start_at <= end_date)
    
    if search and len(search) >= 3:
        query = query.filter(
            or_(
                models.Attendance.start_address.ilike(f"%{search}%"),
                models.Attendance.end_address.ilike(f"%{search}%")
            )
        )

    total_count = query.count()

    sort_attr = getattr(models.Attendance, sort_by, models.Attendance.start_at)
    if sort_order.lower() == "desc":
        query = query.order_by(desc(sort_attr))
    else:
        query = query.order_by(asc(sort_attr))

    logs = query.limit(limit).offset(offset).all()

    return {
        "logs": [serialize_attendance(log) for log in logs],
        "totalCount": total_count,
        "limit": limit,
        "offset": offset
    }, None

def start_employee_attendance(db: Session, req: MarkAttendanceRequest):
    member = db.query(models.Member).filter(models.Member.uid == req.profile_uid).first()
    if not member:
        return None, strings.member_not_found
    
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    stale_sessions = db.query(models.Attendance).filter(
        models.Attendance.profile_uid == req.profile_uid,
        models.Attendance.status == AttendanceStatus.working,
        models.Attendance.created_at < today_start
    ).all()
    
    for session in stale_sessions:
        session.status = AttendanceStatus.ended
        session.end_at = session.start_at
        session.end_address = "Auto-closed (stale)"
    
    if stale_sessions:
        db.commit()

    active_session = db.query(models.Attendance).filter(
        models.Attendance.profile_uid == req.profile_uid,
        models.Attendance.status == AttendanceStatus.working,
        models.Attendance.created_at >= today_start
    ).first()
    
    if active_session:
        return None, "Attendance already marked for start today"

    attendance = models.Attendance(
        profile_uid=req.profile_uid,
        user_uid=member.user_uid,
        company_uid=member.company_uid,
        start_latitude=req.latitude,
        start_longitude=req.longitude,
        start_address=req.address,
        status=AttendanceStatus.working,
        start_at=now_utc()
    )
    db.add(attendance)
    db.commit()
    db.refresh(attendance)
    
    return serialize_attendance(attendance), None


def end_employee_attendance(db: Session, req: MarkAttendanceRequest):
    attendance = db.query(models.Attendance).filter(
        models.Attendance.status == AttendanceStatus.working,
        models.Attendance.profile_uid == req.profile_uid
    ).order_by(models.Attendance.start_at.desc()).first()

    if not attendance:
        return None, "No active attendance session found"

    attendance.end_at = now_utc()
    attendance.end_latitude = req.latitude
    attendance.end_longitude = req.longitude
    attendance.end_address = req.address
    attendance.status = AttendanceStatus.ended
    
    start_at = attendance.start_at
    if start_at.tzinfo is None:
        start_at = start_at.replace(tzinfo=timezone.utc)
    
    duration = attendance.end_at - start_at
    attendance.work_hours = duration.total_seconds() / 3600.0
    
    db.commit()
    db.refresh(attendance)
    
    return serialize_attendance(attendance), None


def get_employee_attendance_status(db: Session, profile_uid: str):
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    latest_attendance = db.query(models.Attendance).filter(
        models.Attendance.profile_uid == profile_uid,
        models.Attendance.created_at >= today_start
    ).order_by(models.Attendance.created_at.desc()).first()
    
    if latest_attendance:
        status = AttendanceStatus.working if latest_attendance.end_at is None else AttendanceStatus.ended
        return {
            "status": status,
            "attendance": serialize_attendance(latest_attendance)
        }, None
    
    return {
        "status": AttendanceStatus.not_started,
        "attendance": None
    }, None
