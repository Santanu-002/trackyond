from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.attendance import MarkAttendanceRequest
from core.responses.models import GenericResponse
from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso, now_utc
from datetime import datetime, timezone
from core.constants.enums import AttendanceStatus

router = APIRouter(prefix="/attendance", tags=["Employee/Attendance"])

def serialize_attendance(attendance: models.Attendance):
    if not attendance:
        return None
    status = AttendanceStatus.WORKING if attendance.end_at is None else AttendanceStatus.ENDED
    return {
        "id": attendance.id,
        "accountUid": attendance.account_uid,
        "userUid": attendance.user_uid,
        "companyUid": attendance.company_uid,
        "startAt": to_utc_iso(attendance.start_at),
        "endAt": to_utc_iso(attendance.end_at) if attendance.end_at else None,
        "startLatitude": attendance.start_latitude,
        "startLongitude": attendance.start_longitude,
        "endLatitude": attendance.end_latitude,
        "endLongitude": attendance.end_longitude,
        "workHours": attendance.work_hours,
        "startAddress": attendance.start_address,
        "endAddress": attendance.end_address,
        "status": status
    }

@router.post("/start", response_model=GenericResponse)
async def start_attendance(req: MarkAttendanceRequest, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.account_uid == req.accountUid).first()
    if not member:
        return GenericResponse(success=False, message=strings.member_not_found)
    
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    # 1. End any stale sessions from previous days
    stale_sessions = db.query(models.Attendance).filter(
        models.Attendance.account_uid == req.accountUid,
        models.Attendance.status == AttendanceStatus.WORKING,
        models.Attendance.created_at < today_start
    ).all()
    
    for session in stale_sessions:
        session.status = AttendanceStatus.ENDED
        session.end_at = session.start_at # Fallback end time
        session.end_address = "Auto-closed (stale)"
    
    if stale_sessions:
        db.commit()

    # 2. Check for active session today
    active_session = db.query(models.Attendance).filter(
        models.Attendance.account_uid == req.accountUid,
        models.Attendance.status == AttendanceStatus.WORKING,
        models.Attendance.created_at >= today_start
    ).first()
    
    if active_session:
        return GenericResponse(success=False, message="Attendance already marked for start today")

    attendance = models.Attendance(
        account_uid=req.accountUid,
        user_uid=member.user_uid,
        company_uid=member.company_uid,
        start_latitude=req.latitude,
        start_longitude=req.longitude,
        start_address=req.address,
        status=AttendanceStatus.WORKING,
        start_at=now_utc()
    )
    db.add(attendance)
    db.commit()
    db.refresh(attendance)
    
    return GenericResponse(
        success=True,
        message="Attendance started successfully",
        data=serialize_attendance(attendance)
    )

@router.post("/end", response_model=GenericResponse)
async def end_attendance(req: MarkAttendanceRequest, db: Session = Depends(get_db)):
    attendance = db.query(models.Attendance).filter(
        models.Attendance.status == AttendanceStatus.WORKING,
        models.Attendance.account_uid == req.accountUid
    ).order_by(models.Attendance.start_at.desc()).first()

    if not attendance:
        return GenericResponse(success=False, message="No active attendance session found")

    attendance.end_at = now_utc()
    attendance.end_latitude = req.latitude
    attendance.end_longitude = req.longitude
    attendance.end_address = req.address
    attendance.status = AttendanceStatus.ENDED
    
    # Ensure start_at is timezone-aware for subtraction
    start_at = attendance.start_at
    if start_at.tzinfo is None:
        start_at = start_at.replace(tzinfo=timezone.utc)
    
    duration = attendance.end_at - start_at
    attendance.work_hours = duration.total_seconds() / 3600.0
    
    db.commit()
    db.refresh(attendance)
    
    return GenericResponse(
        success=True,
        message="Attendance ended successfully",
        data=serialize_attendance(attendance)
    )

@router.get("/status", response_model=GenericResponse)
async def get_attendance_status(account_uid: str, db: Session = Depends(get_db)):
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    # 1. Get latest attendance for today
    latest_attendance = db.query(models.Attendance).filter(
        models.Attendance.account_uid == account_uid,
        models.Attendance.created_at >= today_start
    ).order_by(models.Attendance.created_at.desc()).first()
    
    if latest_attendance:
        status = AttendanceStatus.WORKING if latest_attendance.end_at is None else AttendanceStatus.ENDED
        return GenericResponse(
            success=True,
            message="Current status fetched",
            data={
                "status": status,
                "attendance": serialize_attendance(latest_attendance)
            }
        )
    
    # 2. Not started
    return GenericResponse(
        success=True,
        message="Not started",
        data={
            "status": AttendanceStatus.NOT_STARTED,
            "attendance": None
        }
    )
