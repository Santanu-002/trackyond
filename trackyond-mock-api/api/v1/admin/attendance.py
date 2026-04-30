from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, desc, asc
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from core.utils.datetime_utils import to_utc_iso
from api.dependencies import get_admin_user
from typing import Optional
from datetime import datetime

router = APIRouter(prefix="/attendance", tags=["Admin/Attendance"])

def serialize_attendance(attendance: models.Attendance):
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
        "status": attendance.status
    }

@router.get("", response_model=GenericResponse)
async def get_attendance_logs(
    account_uid: Optional[str] = Query(None, alias="accountUid"),
    status: Optional[str] = None,
    start_date: Optional[datetime] = Query(None, alias="startDate"),
    end_date: Optional[datetime] = Query(None, alias="endDate"),
    search: Optional[str] = None,
    sort_by: str = Query("start_at", alias="sortBy"),
    sort_order: str = Query("desc", alias="sortOrder"),
    limit: int = 10,
    offset: int = 0,
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    query = db.query(models.Attendance)

    # 1. Filter by company (Security)
    # Admin can only see logs for their company
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin.uid).first()
    if not admin_member:
        return GenericResponse(success=False, message="Admin profile not found")
    
    query = query.filter(models.Attendance.company_uid == admin_member.company_uid)

    # 2. Apply Filters
    if account_uid:
        query = query.filter(models.Attendance.account_uid == account_uid)
    if status:
        query = query.filter(models.Attendance.status == status)
    if start_date:
        query = query.filter(models.Attendance.start_at >= start_date)
    if end_date:
        query = query.filter(models.Attendance.start_at <= end_date)
    
    # 3. Search by location (optimized)
    if search and len(search) >= 3:
        query = query.filter(
            or_(
                models.Attendance.start_address.ilike(f"%{search}%"),
                models.Attendance.end_address.ilike(f"%{search}%")
            )
        )

    # 4. Total Count (before pagination)
    total_count = query.count()

    # 5. Sorting
    sort_attr = getattr(models.Attendance, sort_by, models.Attendance.start_at)
    if sort_order.lower() == "desc":
        query = query.order_by(desc(sort_attr))
    else:
        query = query.order_by(asc(sort_attr))

    # 6. Pagination
    logs = query.limit(limit).offset(offset).all()

    return GenericResponse(
        success=True,
        message="Attendance logs fetched successfully",
        data={
            "logs": [serialize_attendance(log) for log in logs],
            "totalCount": total_count,
            "limit": limit,
            "offset": offset
        }
    )

@router.get("/export/csv", response_model=GenericResponse)
async def export_attendance_csv(
    account_uid: str = Query(..., alias="accountUid"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Simulated export URL
    return GenericResponse(
        success=True,
        message="CSV Export ready",
        data={"downloadUrl": f"https://api.trackyond.com/exports/attendance_{account_uid}.csv"}
    )

@router.get("/export/pdf", response_model=GenericResponse)
async def export_attendance_pdf(
    account_uid: str = Query(..., alias="accountUid"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Simulated export URL
    return GenericResponse(
        success=True,
        message="PDF Export ready",
        data={"downloadUrl": f"https://api.trackyond.com/exports/attendance_{account_uid}.pdf"}
    )
