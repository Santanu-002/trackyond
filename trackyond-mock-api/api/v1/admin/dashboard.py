from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from core.responses.models import GenericResponse

router = APIRouter(prefix="/dashboard", tags=["Admin/Dashboard"])

@router.get("", response_model=GenericResponse)
async def get_dashboard(db: Session = Depends(get_db)):
    # Mock aggregation
    total_jobs = db.query(models.Job).count()
    members = db.query(models.Member).all()
    
    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data={
            "teamMembersStatus": [
                {"accountUid": m.account_uid, "userUid": m.user_uid, "name": m.name, "status": "online"} for m in members
            ],
            "jobCounts": {
                "pending": db.query(models.Job).filter(models.Job.status == "pending").count(),
                "inProgress": db.query(models.Job).filter(models.Job.status == "in_progress").count(),
                "completed": db.query(models.Job).filter(models.Job.status == "completed").count(),
            },
            "recentJobs": []
        }
    )
