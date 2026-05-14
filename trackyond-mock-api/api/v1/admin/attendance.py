from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from api.dependencies import get_admin_user
from typing import Optional
from datetime import datetime
from services.attendance_service import get_admin_attendance_logs

router = APIRouter(prefix="/attendance", tags=["Admin/Attendance"])

@router.get("", response_model=GenericResponse)
async def get_attendance_logs(
    profile_uid: Optional[str] = Query(None, alias="profileUid"),
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
    data, error = get_admin_attendance_logs(
        db=db,
        admin_uid=admin.uid,
        profile_uid=profile_uid,
        status=status,
        start_date=start_date,
        end_date=end_date,
        search=search,
        sort_by=sort_by,
        sort_order=sort_order,
        limit=limit,
        offset=offset
    )

    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Attendance logs fetched successfully",
        data=data
    )

@router.get("/export/csv", response_model=GenericResponse)
async def export_attendance_csv(
    profile_uid: str = Query(..., alias="profileUid"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Simulated export URL
    return GenericResponse(
        success=True,
        message="CSV Export ready",
        data={"downloadUrl": f"https://api.trackyond.com/exports/attendance_{profile_uid}.csv"}
    )

@router.get("/export/pdf", response_model=GenericResponse)
async def export_attendance_pdf(
    profile_uid: str = Query(..., alias="profileUid"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Simulated export URL
    return GenericResponse(
        success=True,
        message="PDF Export ready",
        data={"downloadUrl": f"https://api.trackyond.com/exports/attendance_{profile_uid}.pdf"}
    )
