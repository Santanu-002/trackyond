from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.attendance import MarkAttendanceRequest
from core.responses.models import GenericResponse
from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso
from datetime import datetime, timezone
from core.constants.enums import AttendanceStatus

router = APIRouter(prefix="/attendance", tags=["Employee/Attendance"])

@router.post("/start", response_model=GenericResponse)
async def start_attendance(req: MarkAttendanceRequest, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.account_uid == req.accountUid).first()
    if not member:
        return GenericResponse(success=False, message=strings.member_not_found)
    active_session = db.query(models.Attendance).filter(
        models.Attendance.account_uid == req.accountUid,
        models.Attendance.status == AttendanceStatus.WORKING
    ).first()
    
    if active_session:
        return GenericResponse(success=False, message="Attendance already marked for start")

    # Check if already ended today
    today_start = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)
    already_ended = db.query(models.Attendance).filter(
        models.Attendance.account_uid == req.accountUid,
        models.Attendance.status == AttendanceStatus.ENDED,
        models.Attendance.start_at >= today_start
    ).first()

    if already_ended:
        return GenericResponse(success=False, message="Attendance already ended for today")

    attendance = models.Attendance(
        account_uid=req.accountUid,
        user_uid=member.user_uid,
        company_uid=member.company_uid,
        start_latitude=req.latitude,
        start_longitude=req.longitude,
        start_address=req.address,
        status=AttendanceStatus.WORKING,
        start_at=datetime.now(timezone.utc)
    )
    db.add(attendance)
    db.commit()
    db.refresh(attendance)
    
    return GenericResponse(
        success=True,
        message="Attendance started successfully",
        data={
            "id": attendance.id,
            "status": attendance.status,
            "startAt": to_utc_iso(attendance.start_at)
        }
    )

@router.post("/end", response_model=GenericResponse)
async def end_attendance(req: MarkAttendanceRequest, db: Session = Depends(get_db)):
    attendance = db.query(models.Attendance).filter(
        models.Attendance.status == AttendanceStatus.WORKING,
        models.Attendance.account_uid == req.accountUid
    ).order_by(models.Attendance.start_at.desc()).first()

    if not attendance:
        return GenericResponse(success=False, message="No active attendance session found")

    attendance.end_at = datetime.now(timezone.utc)
    attendance.end_latitude = req.latitude
    attendance.end_longitude = req.longitude
    attendance.end_address = req.address
    attendance.status = AttendanceStatus.ENDED
    
    duration = attendance.end_at - attendance.start_at
    attendance.work_hours = duration.total_seconds() / 3600.0
    
    db.commit()
    db.refresh(attendance)
    
    return GenericResponse(
        success=True,
        message="Attendance ended successfully",
        data={
            "id": attendance.id,
            "status": attendance.status,
            "startAt": to_utc_iso(attendance.start_at),
            "endAt": to_utc_iso(attendance.end_at),
            "workHours": attendance.work_hours
        }
    )

@router.get("/status", response_model=GenericResponse)
async def get_attendance_status(account_uid: str, db: Session = Depends(get_db)):
    # 1. Check for active session
    active_attendance = db.query(models.Attendance).filter(
        models.Attendance.account_uid == account_uid,
        models.Attendance.status == AttendanceStatus.WORKING
    ).first()
    
    if active_attendance:
        return GenericResponse(
            success=True,
            message="Active session found",
            data={
                "status": AttendanceStatus.WORKING,
                "attendance": {
                    "id": active_attendance.id,
                    "status": AttendanceStatus.WORKING,
                    "startAt": to_utc_iso(active_attendance.start_at),
                }
            }
        )
    
    # 2. Check if already ended today
    today_start = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)
    completed_today = db.query(models.Attendance).filter(
        models.Attendance.account_uid == account_uid,
        models.Attendance.status == AttendanceStatus.ENDED,
        models.Attendance.start_at >= today_start
    ).first()

    if completed_today:
        return GenericResponse(
            success=True,
            message="Attendance ended for today",
            data={
                "status": AttendanceStatus.ENDED,
                "attendance": {
                    "id": completed_today.id,
                    "status": AttendanceStatus.ENDED,
                    "startAt": to_utc_iso(completed_today.start_at),
                    "endAt": to_utc_iso(completed_today.end_at),
                }
            }
        )
    
    # 3. Not started
    return GenericResponse(
        success=True,
        message="Not started today",
        data={
            "status": AttendanceStatus.NOT_STARTED,
            "attendance": None
        }
    )
