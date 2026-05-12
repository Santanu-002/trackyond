from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from schemas.attendance import MarkAttendanceRequest
from core.responses.models import GenericResponse
from services.attendance_service import start_employee_attendance, end_employee_attendance, get_employee_attendance_status

router = APIRouter(prefix="/attendance", tags=["Employee/Attendance"])

@router.post("/start", response_model=GenericResponse)
async def start_attendance(req: MarkAttendanceRequest, db: Session = Depends(get_db)):
    data, error = start_employee_attendance(db, req)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Attendance started successfully",
        data=data
    )

@router.post("/end", response_model=GenericResponse)
async def end_attendance(req: MarkAttendanceRequest, db: Session = Depends(get_db)):
    data, error = end_employee_attendance(db, req)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Attendance ended successfully",
        data=data
    )

@router.get("/status", response_model=GenericResponse)
async def get_attendance_status(account_uid: str, db: Session = Depends(get_db)):
    data, error = get_employee_attendance_status(db, account_uid)
    if error:
        return GenericResponse(success=False, message=error)

    # Use a dynamic message based on status, similar to old logic
    message = "Current status fetched" if data.get("attendance") else "Not started"
    
    return GenericResponse(
        success=True,
        message=message,
        data=data
    )
