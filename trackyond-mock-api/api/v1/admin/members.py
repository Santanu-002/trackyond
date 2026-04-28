from fastapi import APIRouter, Depends, Form, File, UploadFile
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.common import PHONE_REGEX
from core.responses.models import GenericResponse
from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso
from api.dependencies import get_admin_user
import uuid
import os
import shutil

router = APIRouter(prefix="/members", tags=["Admin/Members"])

@router.get("", response_model=GenericResponse)
async def get_members(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # Fetch admin's member profile to get company_uid
    admin_member = db.query(models.Member).filter(models.Member.user_uid == admin.uid).first()
    if not admin_member:
        return GenericResponse(success=False, message="Admin profile not found")

    members = db.query(models.Member).filter(models.Member.company_uid == admin_member.company_uid).all()
    return GenericResponse(
        success=True,
        message="Members fetched successfully",
        data={
            "members": [
                {
                    "accountUid": m.account_uid,
                    "userUid": m.user_uid,
                    "name": m.name,
                    "phone": m.phone,
                    "designation": m.designation,
                    "image": m.image,
                    "gender": m.gender,
                    "companyUid": m.company_uid,
                    "createdBy": m.created_by
                } for m in members
            ]
        }
    )

@router.post("", response_model=GenericResponse)
async def add_member(
    member_name: str = Form(..., alias="memberName"),
    user_phone_no: str = Form(..., alias="userPhoneNo", pattern=PHONE_REGEX),
    designation: str = Form(...),
    gender: str = Form(None),
    company_uid: str = Form(..., alias="companyUid"),
    member_image: UploadFile = File(None, alias="memberImage"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    # 1. Check if user already exists
    user = db.query(models.User).filter(models.User.phone == user_phone_no).first()
    
    target_user_uid = None
    
    if user:
        # Check if already a member of THIS company
        existing_member = db.query(models.Member).filter(
            models.Member.user_uid == user.uid, 
            models.Member.company_uid == company_uid
        ).first()
        
        if existing_member:
            return GenericResponse(success=False, message="Member already exists in this company")
        
        target_user_uid = user.uid
    else:
        # 2. Create User record
        target_user_uid = uuid.uuid4().hex[:10]
        new_user = models.User(
            uid=target_user_uid,
            phone=user_phone_no,
            role="employee",
            is_new_user=False
        )
        db.add(new_user)
        db.flush()

    # 3. Handle image upload if provided
    image_path = None
    if member_image:
        try:
            # Create directory structure: uploads/<company_uid>/<user_uid>/
            upload_dir = os.path.join("uploads", company_uid, target_user_uid)
            os.makedirs(upload_dir, exist_ok=True)
            
            # Clean up existing avatar files
            for f in os.listdir(upload_dir):
                if f.startswith("avatar."):
                    os.remove(os.path.join(upload_dir, f))
            
            _, ext = os.path.splitext(member_image.filename)
            if not ext: ext = ".jpg"
            
            filename = f"avatar{ext}"
            file_path = os.path.join(upload_dir, filename)
            
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(member_image.file, buffer)
            
            image_path = f"uploads/{company_uid}/{target_user_uid}/avatar{ext}"
        except Exception as e:
            print(f"Error saving image: {str(e)}")

    # 4. Create Member profile
    new_member = models.Member(
        account_uid=uuid.uuid4().hex[:10],
        user_uid=target_user_uid,
        name=member_name,
        phone=user_phone_no,
        designation=designation,
        image=image_path,
        gender=gender,
        company_uid=company_uid,
        created_by=admin.uid
    )
    db.add(new_member)
    db.flush()

    # 5. Set as primary if it's the user's first profile
    target_user = db.query(models.User).filter(models.User.uid == target_user_uid).first()
    if target_user and target_user.primary_account_uid is None:
        target_user.primary_account_uid = new_member.account_uid

    db.commit()
    db.refresh(new_member)
    
    return GenericResponse(
        success=True,
        message=strings.member_added,
        data={
            "accountUid": new_member.account_uid,
            "userUid": new_member.user_uid,
            "name": new_member.name,
            "phone": new_member.phone,
            "designation": new_member.designation,
            "image": new_member.image,
            "gender": new_member.gender,
            "companyUid": new_member.company_uid,
            "createdAt": to_utc_iso(new_member.created_at)
        }
    )
