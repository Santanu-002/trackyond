from fastapi import APIRouter, Depends, HTTPException, Body, Header
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.common import OTPRequest, VerifyOTPRequest
from schemas.admin import CompanyCreate, MemberCreate, JobCreate
from services.auth_service import auth_service
from services.token_service import token_service
from core.responses.models import GenericResponse, ErrorResponse
from core.errors.exceptions import AppException
from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso
import uuid
from datetime import datetime

router = APIRouter(prefix="/v1/admin", tags=["Admin"])

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

@router.post("/company", response_model=GenericResponse)
async def create_company(req: CompanyCreate, db: Session = Depends(get_db)):
    # Check if company already exists
    existing = db.query(models.Company).filter(models.Company.user_phone_no == req.user_phone_no).first()
    if existing:
         return GenericResponse(success=False, message="Company already exists for this user")

    new_company = models.Company(
        company_id="comp_" + str(uuid.uuid4())[:8],
        name=req.company_name,
        user_phone_no=req.user_phone_no,
        user_full_name=req.user_full_name,
        team_size=req.team_size
    )
    db.add(new_company)
    
    # Also add as a member if not exists
    member = db.query(models.Member).filter(models.Member.phone == req.user_phone_no).first()
    if not member:
        new_member = models.Member(
            uid=uuid.uuid4().hex[:10],
            name=req.user_full_name,
            phone=req.user_phone_no,
            designation="Admin",
            gender=None, # Explicitly null
            image=None   # Explicitly null
        )
        db.add(new_member)
    
    db.commit()
    db.refresh(new_company)
    
    return GenericResponse(
        success=True,
        message=strings.company_created,
        data={
            "companyId": new_company.company_id,
            "companyName": new_company.name,
            "createdAt": to_utc_iso(new_company.created_at)
        }
    )

@router.get("/members", response_model=GenericResponse)
async def get_members(db: Session = Depends(get_db)):
    members = db.query(models.Member).all()
    return GenericResponse(
        success=True,
        message="Members fetched successfully",
        data={
            "members": [
                {
                    "uid": m.uid,
                    "name": m.name,
                    "phone": m.phone,
                    "designation": m.designation,
                    "image": m.image,
                    "gender": m.gender
                } for m in members
            ]
        }
    )

@router.post("/members", response_model=GenericResponse)
async def add_member(req: MemberCreate, db: Session = Depends(get_db)):
    existing = db.query(models.Member).filter(models.Member.phone == req.user_phone_no).first()
    if existing:
        return GenericResponse(success=False, message="Member already exists")

    new_member = models.Member(
        uid=uuid.uuid4().hex[:10],
        name=req.member_name,
        phone=req.user_phone_no,
        designation=req.designation,
        image=req.member_image,
        gender=req.gender
    )
    db.add(new_member)
    db.commit()
    db.refresh(new_member)
    
    return GenericResponse(
        success=True,
        message=strings.member_added,
        data={
            "uid": new_member.uid,
            "memberName": new_member.name,
            "designation": new_member.designation,
            "createdAt": to_utc_iso(new_member.created_at)
        }
    )

@router.get("/dashboard", response_model=GenericResponse)
async def get_dashboard(db: Session = Depends(get_db)):
    # Mock aggregation
    total_jobs = db.query(models.Job).count()
    members = db.query(models.Member).all()
    
    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data={
            "teamMembersStatus": [
                {"uid": m.uid, "name": m.name, "status": "online"} for m in members
            ],
            "jobCounts": {
                "pending": db.query(models.Job).filter(models.Job.status == "pending").count(),
                "inProgress": db.query(models.Job).filter(models.Job.status == "in_progress").count(),
                "completed": db.query(models.Job).filter(models.Job.status == "completed").count(),
            },
            "recentJobs": []
        }
    )
