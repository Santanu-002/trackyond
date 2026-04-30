from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse
from core.utils.datetime_utils import now_utc, to_utc_iso

router = APIRouter(prefix="/dashboard", tags=["Admin/Dashboard"])

@router.get("", response_model=GenericResponse)
async def get_dashboard(db: Session = Depends(get_db)):
    # Get all members with their today's attendance
    members = db.query(models.Member).all()
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    team_status = []
    for m in members:
        latest = db.query(models.Attendance).filter(
            models.Attendance.account_uid == m.account_uid,
            models.Attendance.created_at >= today_start
        ).order_by(models.Attendance.created_at.desc()).first()
        
        attn_data = None
        if latest:
            status = "working" if latest.end_at is None else "ended"
            attn_data = {
                "id": latest.id,
                "status": status,
                "startAt": to_utc_iso(latest.start_at),
                "endAt": to_utc_iso(latest.end_at) if latest.end_at else None,
                "workHours": latest.work_hours,
                "startAddress": latest.start_address,
                "endAddress": latest.end_address
            }
            
        team_status.append({
            "accountUid": m.account_uid,
            "userUid": m.user_uid,
            "name": m.name,
            "phone": m.phone,
            "designation": m.designation,
            "image": m.image,
            "todayAttendance": attn_data
        })
    
    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data={
            "teamMembersStatus": team_status,
            "jobCounts": {
                "pending": db.query(models.Job).filter(models.Job.status == "pending").count(),
                "inProgress": db.query(models.Job).filter(models.Job.status == "in_progress").count(),
                "completed": db.query(models.Job).filter(models.Job.status == "completed").count(),
            },
            "recentJobs": []
        }
    )
