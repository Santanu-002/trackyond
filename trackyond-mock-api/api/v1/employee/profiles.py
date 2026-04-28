from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from api.dependencies import get_current_user
from core.responses.models import GenericResponse

router = APIRouter(prefix="/profiles", tags=["Employee/Profiles"])

@router.get("", response_model=GenericResponse)
async def get_profiles(
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """
    Returns all membership profiles for the authenticated user across all companies.
    """
    memberships = db.query(models.Member).filter(
        models.Member.user_uid == user.uid,
        models.Member.is_active == True
    ).all()
    
    profiles = []
    for m in memberships:
        company = db.query(models.Company).filter(models.Company.company_id == m.company_uid).first()
        profiles.append({
            "accountUid": m.account_uid,
            "userUid": m.user_uid,
            "name": m.name,
            "designation": m.designation,
            "image": m.image,
            "company": {
                "id": company.company_id if company else None,
                "name": company.name if company else "Unknown Company"
            },
            "isPrimary": user.primary_account_uid == m.account_uid
        })
    
    return GenericResponse(
        success=True,
        message="Profiles fetched successfully",
        data={"profiles": profiles}
    )

@router.post("/switch", response_model=GenericResponse)
async def switch_profile(
    account_uid: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """
    Switches the user's primary profile to the specified account_uid.
    """
    # Verify the membership belongs to the user
    membership = db.query(models.Member).filter(
        models.Member.account_uid == account_uid,
        models.Member.user_uid == user.uid,
        models.Member.is_active == True
    ).first()
    
    if not membership:
        return GenericResponse(success=False, message="Invalid profile UID")
    
    user.primary_account_uid = account_uid
    db.commit()
    
    # Return the new "active" profile details
    company = db.query(models.Company).filter(models.Company.company_id == membership.company_uid).first()
    
    return GenericResponse(
        success=True,
        message="Profile switched successfully",
        data={
            "user": {
                "uid": user.uid,
                "phone": user.phone,
                "role": user.role,
                "isNewUser": user.is_new_user,
                "primaryAccountUid": user.primary_account_uid,
            },
            "profile": {
                "accountUid": membership.account_uid,
                "userUid": membership.user_uid,
                "name": membership.name,
                "phone": membership.phone,
                "designation": membership.designation,
                "image": membership.image,
                "gender": membership.gender,
            },
            "company": {
                "companyId": company.company_id if company else None,
                "name": company.name if company else None,
                "teamSize": company.team_size if company else None,
            }
        }
    )
