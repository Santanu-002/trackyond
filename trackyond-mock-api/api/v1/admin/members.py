from fastapi import APIRouter, Depends, Form, File, UploadFile
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.common import PHONE_REGEX
from core.responses.models import GenericResponse
from api.dependencies import get_admin_user
from services.members_service import (
    add_admin_member_data,
    get_admin_members_data,
    member_added_message,
)

router = APIRouter(prefix="/members", tags=["Admin/Members"])

@router.get("", response_model=GenericResponse)
async def get_members(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = get_admin_members_data(db, admin.uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Members fetched successfully",
        data=data
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
    data, error = add_admin_member_data(
        db=db,
        admin_uid=admin.uid,
        member_name=member_name,
        user_phone_no=user_phone_no,
        designation=designation,
        gender=gender,
        company_uid=company_uid,
        member_image=member_image,
    )
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message=member_added_message(),
        data=data
    )
