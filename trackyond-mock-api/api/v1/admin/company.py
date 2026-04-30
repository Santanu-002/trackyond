from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from schemas.admin import CompanyCreate
from core.responses.models import GenericResponse
from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso, now_utc
from api.dependencies import get_admin_user
from datetime import datetime, timezone
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

@router.get("/team-status", response_model=GenericResponse)
async def get_team_status(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user),
    status_filter: str = None, # all | working | notStarted
    order: str = "desc", # asc | desc
    limit: int = None
):
    company = db.query(models.Company).filter(models.Company.owner_uid == admin.uid).first()
    if not company:
        return GenericResponse(success=False, message="Company not found")
    
    # Get all members of the company
    members = db.query(models.Member).filter(models.Member.company_uid == company.company_id).all()
    
    team_data = []
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    for member in members:
        # Get latest attendance session for today
        latest_attendance = db.query(models.Attendance).filter(
            models.Attendance.account_uid == member.account_uid,
            models.Attendance.start_at >= today_start
        ).order_by(models.Attendance.start_at.desc()).first()
        
        status = "notStarted"
        start_at = None
        current_location = None
        
        if latest_attendance and latest_attendance.status == "working":
            status = "working"
            start_at = latest_attendance.start_at
            current_location = latest_attendance.start_address
            
        team_data.append({
            "accountUid": member.account_uid,
            "name": member.name,
            "designation": member.designation,
            "image": member.image,
            "status": status,
            "phone": member.phone,
            "startAt": to_utc_iso(start_at) if start_at else None,
            "currentLocation": current_location,
            "_raw_startAt": start_at # Keep for sorting
        })
    
    # Calculate overall stats (always from full data)
    working_list = [m for m in team_data if m['status'] == 'working']
    not_started_list = [m for m in team_data if m['status'] == 'notStarted']
    
    working_count = len(working_list)
    not_started_count = len(not_started_list)

    # Sort each list independently
    is_desc = order == "desc"
    
    # Sort working by start time
    working_list.sort(
        key=lambda x: x['_raw_startAt'] or datetime.min.replace(tzinfo=timezone.utc),
        reverse=is_desc
    )
    
    # Sort not started by name (since start time is null)
    not_started_list.sort(
        key=lambda x: x['name'],
        reverse=is_desc
    )

    # Combine lists (Working always first)
    final_list = working_list + not_started_list

    # Apply status filter if not 'all'
    if status_filter and status_filter != 'all':
        final_list = [m for m in final_list if m['status'] == status_filter]

    # Apply limit
    if limit:
        final_list = final_list[:limit]
        
    # Clean up raw data before response
    for m in final_list:
        m.pop('_raw_startAt', None)
        
    return GenericResponse(
        success=True,
        message="Team status fetched successfully",
        data={
            "members": final_list,
            "stats": {
                "total": len(members),
                "working": working_count,
                "notStarted": not_started_count
            }
        }
    )
