from fastapi import APIRouter, Depends, HTTPException, Body, Header
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.common import OTPRequest, VerifyOTPRequest
from services.auth_service import auth_service
from services.token_service import token_service
from core.responses.models import GenericResponse
from core.errors.exceptions import AppException
from core.constants.app_strings import strings
import uuid
from datetime import datetime
from core.utils.datetime_utils import to_utc_iso
from typing import Optional

router = APIRouter(prefix="/v1/employee", tags=["Employee"])

@router.post("/auth/send-otp", response_model=GenericResponse)
async def send_otp(req: OTPRequest, device_id: str = Header(alias="device-id")):
    data = auth_service.send_otp_logic(req.phone, device_id)
    return GenericResponse(
        success=True,
        message=strings.otp_sent,
        data=data
    )

@router.post("/auth/resend-otp", response_model=GenericResponse)
async def resend_otp(req: OTPRequest, device_id: str = Header(alias="device-id")):
    data = auth_service.send_otp_logic(req.phone, device_id, is_resend=True)
    return GenericResponse(
        success=True,
        message=strings.otp_resent,
        data=data
    )

@router.post("/auth/verify-otp", response_model=GenericResponse)
async def verify_otp(
    req: VerifyOTPRequest, 
    db: Session = Depends(get_db),
    device_id: str = Header(alias="device-id")
):
    success, is_new_user, data = auth_service.verify_otp_logic(
        db, req.phone, req.otp_id, req.otp, device_id
    )
    
    if not success:
        return GenericResponse(success=False, message=strings.invalid_otp)
    
    # Check if user exists in company
    member = db.query(models.Member).filter(models.Member.phone == req.phone).first()
    if not member:
         return GenericResponse(
             success=False, 
             message="User is not a member of any company",
             data={"error": "login_failed", "reasons": ["Contact administrator"]}
         )

    return GenericResponse(
        success=True,
        message=strings.login_success,
        data=data
    )

@router.post("/auth/refresh", response_model=GenericResponse)
async def refresh_token(
    authorization: str = Header(...),
    x_refresh_token: str = Header(alias="x-refresh-token")
):
    tokens = auth_service.refresh_token_logic(authorization, x_refresh_token)
    return GenericResponse(
        success=True,
        message="Token refreshed successfully",
        data=tokens
    )

@router.get("/profile", response_model=GenericResponse)
async def get_profile(member_uid: str, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.uid == member_uid).first()
    if not member:
        return GenericResponse(success=False, message=strings.member_not_found)
    
    return GenericResponse(
        success=True,
        message="Profile fetched successfully",
        data={
            "memberUid": member.uid,
            "memberName": member.name,
            "phoneNo": member.phone,
            "designation": member.designation,
            "gender": member.gender,
            "image": member.image
        }
    )

@router.get("/jobs", response_model=GenericResponse)
async def get_jobs(worker_uid: str, status: Optional[str] = None, db: Session = Depends(get_db)):
    query = db.query(models.Job).filter(models.Job.worker_uid == worker_uid)
    if status:
        query = query.filter(models.Job.status == status)
    jobs = query.all()
    
    return GenericResponse(
        success=True,
        message="Jobs fetched successfully",
        data={
            "jobs": [
                {
                    "jobId": j.job_id,
                    "jobTitle": j.title,
                    "status": j.status,
                    "customerName": j.customer_name,
                    "customerPhone": j.customer_phone,
                    "customerAddress": j.customer_address,
                    "requirePhotoOnStart": j.require_photo_on_start,
                    "requirePhotoOnComplete": j.require_photo_on_complete,
                    "captureLocation": j.capture_location,
                    "assignedAt": to_utc_iso(j.assigned_at) if j.assigned_at else None
                } for j in jobs
            ],
            "pagination": {"total": len(jobs), "page": 1, "limit": 10}
        }
    )
