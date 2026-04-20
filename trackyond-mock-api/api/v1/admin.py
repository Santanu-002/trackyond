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
    device_id: str = Header(alias="device-id"),
    device_os: str = Header(alias="device-os"),
    device_os_version: str = Header(alias="device-os-version"),
    device_name: str = Header(alias="device-name"),
    browser: str = Header(alias="browser"),
    browser_version: str = Header(alias="browser-version"),
    app_version: str = Header(alias="app-version")
):
    metadata = {
        "deviceOs": device_os,
        "deviceOsVersion": device_os_version,
        "deviceName": device_name,
        "browser": browser,
        "browserVersion": browser_version,
        "appVersion": app_version
    }
    
    success, is_new_user, data = auth_service.verify_otp_logic(
        db, req.phone, req.otp_id, req.otp, device_id, metadata
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
    db: Session = Depends(get_db),
    authorization: str = Header(...),
    x_refresh_token: str = Header(alias="x-refresh-token"),
    device_id: str = Header(alias="device-id")
):
    tokens = auth_service.refresh_token_logic(db, authorization, x_refresh_token, device_id)
    return GenericResponse(
        success=True,
        message="Token refreshed successfully",
        data=tokens
    )

@router.post("/company", response_model=GenericResponse)
async def create_company(req: CompanyCreate, db: Session = Depends(get_db)):
    # 1. Check if company already exists
    existing = db.query(models.Company).filter(models.Company.user_phone_no == req.user_phone_no).first()
    if existing:
         return GenericResponse(success=False, message="Company already exists for this user")

    # 2. Update User onboarding status
    user = db.query(models.User).filter(models.User.phone == req.user_phone_no).first()
    if not user:
        # Fallback if user wasn't created during OTP (shouldn't happen with new logic)
        user = models.User(
            uid=uuid.uuid4().hex[:10],
            phone=req.user_phone_no,
            role="admin",
            is_new_user=False
        )
        db.add(user)
        db.flush()
    else:
        user.is_new_user = False

    # 3. Create Company
    new_company = models.Company(
        company_id="comp_" + str(uuid.uuid4())[:8],
        name=req.company_name,
        user_phone_no=req.user_phone_no,
        user_full_name=req.user_full_name,
        team_size=req.team_size
    )
    db.add(new_company)
    
    # 4. Create/Update the Admin's Member profile
    member = db.query(models.Member).filter(models.Member.uid == user.uid).first()
    if not member:
        member = models.Member(
            uid=user.uid,
            name=req.user_full_name,
            phone=req.user_phone_no,
            designation="Owner",
            gender=None,
            image=None
        )
        db.add(member)
    else:
        member.name = req.user_full_name
        member.designation = "Owner"
    
    db.commit()
    db.refresh(new_company)
    db.refresh(member)
    
    return GenericResponse(
        success=True,
        message=strings.company_created,
        data={
            "ownerProfile": {
                "uid": member.uid,
                "name": member.name,
                "phone": member.phone,
                "designation": member.designation,
                "image": member.image,
                "gender": member.gender
            },
            "company": {
                "companyId": new_company.company_id,
                "companyName": new_company.name,
                "userPhoneNo": new_company.user_phone_no,
                "teamSize": new_company.team_size,
                "createdAt": to_utc_iso(new_company.created_at)
            }
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
    # 1. Check if user already exists
    user = db.query(models.User).filter(models.User.phone == req.user_phone_no).first()
    if user:
        return GenericResponse(success=False, message="User with this phone already exists")

    # 2. Create User record
    new_user = models.User(
        uid=uuid.uuid4().hex[:10],
        phone=req.user_phone_no,
        role="employee",
        is_new_user=False # Employees created by admin are not "new users" in onboarding sense
    )
    db.add(new_user)
    db.flush()

    # 3. Create Member profile
    new_member = models.Member(
        uid=new_user.uid,
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
            "phone": new_member.phone,
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
