from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.admin import CompanyCreate
from core.responses.models import GenericResponse
from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso
from api.dependencies import get_admin_user
import uuid

router = APIRouter(prefix="/company", tags=["Admin/Company"])

@router.post("", response_model=GenericResponse)
async def create_company(req: CompanyCreate, db: Session = Depends(get_db)):
    # 1. Check if company already exists for this owner
    existing = db.query(models.Company).filter(models.Company.owner_uid == req.owner_uid).first()
    if existing:
         return GenericResponse(success=False, message="Company already exists for this user")

    # 2. Update User onboarding status
    user = db.query(models.User).filter(models.User.uid == req.owner_uid).first()
    if not user:
        return GenericResponse(success=False, message="User not found")
    
    user.is_new_user = False

    # 3. Create Company
    new_company = models.Company(
        company_id="comp_" + str(uuid.uuid4())[:8],
        name=req.company_name,
        owner_uid=req.owner_uid,
        team_size=req.team_size
    )
    db.add(new_company)
    
    # 4. Create/Update the Admin's Member profile
    member = db.query(models.Member).filter(
        models.Member.user_uid == user.uid,
        models.Member.company_uid == new_company.company_id
    ).first()
    
    if not member:
        member = models.Member(
            account_uid=uuid.uuid4().hex[:10],
            user_uid=user.uid,
            name=req.owner_name,
            phone=req.owner_phone,
            designation="Owner",
            gender=None,
            image=None,
            company_uid=new_company.company_id,
            created_by=None
        )
        db.add(member)
        db.flush()
    else:
        member.name = req.owner_name
        member.phone = req.owner_phone
        member.designation = "Owner"
        member.company_uid = new_company.company_id
        member.created_by = None
    
    # Set as primary if not already set
    if user.primary_account_uid is None:
        user.primary_account_uid = member.account_uid

    db.commit()
    db.refresh(new_company)
    db.refresh(member)
    
    return GenericResponse(
        success=True,
        message=strings.company_created,
        data={
            "ownerProfile": {
                "accountUid": member.account_uid,
                "userUid": member.user_uid,
                "name": member.name,
                "phone": member.phone,
                "designation": member.designation,
                "image": member.image,
                "gender": member.gender
            },
            "company": {
                "companyId": new_company.company_id,
                "companyName": new_company.name,
                "teamSize": new_company.team_size,
                "ownerUid": new_company.owner_uid,
                "createdAt": to_utc_iso(new_company.created_at)
            }
        }
    )

@router.get("", response_model=GenericResponse)
async def get_company(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    company = db.query(models.Company).filter(models.Company.owner_uid == admin.uid).first()
    if not company:
        return GenericResponse(success=False, message="Company not found")
    
    return GenericResponse(
        success=True,
        message="Company fetched successfully",
        data={
            "companyId": company.company_id,
            "companyName": company.name,
            "teamSize": company.team_size,
            "ownerUid": company.owner_uid,
            "createdAt": to_utc_iso(company.created_at)
        }
    )
