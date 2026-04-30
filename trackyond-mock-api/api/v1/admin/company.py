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
    limit: str = None
):
    parsed_limit = 50
    if limit and limit.isdigit():
        parsed_limit = int(limit)
        
    company = db.query(models.Company).filter(models.Company.owner_uid == admin.uid).first()
    if not company:
        return GenericResponse(success=False, message="Company not found")
    
    # Get all members of the company
    members = db.query(models.Member).filter(models.Member.company_uid == company.company_id).all()
    
    team_data = []
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    
    for member in members:
        # Get latest attendance session for today (ordered by created_at desc)
        latest_attendance = db.query(models.Attendance).filter(
            models.Attendance.account_uid == member.account_uid,
            models.Attendance.created_at >= today_start
        ).order_by(models.Attendance.created_at.desc()).first()
        
        attendance_data = None
        if latest_attendance:
            status = "working" if latest_attendance.end_at is None else "ended"
            attendance_data = {
                "id": latest_attendance.id,
                "accountUid": latest_attendance.account_uid,
                "userUid": latest_attendance.user_uid,
                "companyUid": latest_attendance.company_uid,
                "status": status,
                "startAt": to_utc_iso(latest_attendance.start_at),
                "endAt": to_utc_iso(latest_attendance.end_at) if latest_attendance.end_at else None,
                "startLatitude": latest_attendance.start_latitude,
                "startLongitude": latest_attendance.start_longitude,
                "endLatitude": latest_attendance.end_latitude,
                "endLongitude": latest_attendance.end_longitude,
                "workHours": latest_attendance.work_hours,
                "startAddress": latest_attendance.start_address,
                "endAddress": latest_attendance.end_address
            }
            
        team_data.append({
            "profile": {
                "accountUid": member.account_uid,
                "userUid": getattr(member, 'user_uid', ""),
                "name": member.name,
                "designation": member.designation if member.designation else "",
                "image": member.image,
                "phone": member.phone,
                "gender": getattr(member, 'gender', None),
                "companyUid": member.company_uid,
            },
            "todayAttendance": attendance_data,
            "_raw_attendance": latest_attendance # Keep for sorting/filtering
        })
    
    # Calculate overall stats
    working_count = sum(1 for m in team_data if m['_raw_attendance'] and m['_raw_attendance'].end_at is None)
    not_started_count = sum(1 for m in team_data if not m['_raw_attendance'])
    ended_count = sum(1 for m in team_data if m['_raw_attendance'] and m['_raw_attendance'].end_at is not None)

    def sort_key(item):
        attn = item['_raw_attendance']
        profile = item['profile']
        if not attn:
            # Not started
            return (2, 0, profile['name'].lower())
        elif attn.end_at is None:
            # Working
            return (0, -attn.start_at.timestamp(), profile['name'].lower())
        else:
            # Ended
            return (1, -attn.end_at.timestamp(), profile['name'].lower())

    team_data.sort(key=sort_key)

    # Apply status filter if not 'all'
    if status_filter and status_filter != 'all':
        if status_filter == 'working':
            team_data = [m for m in team_data if m['_raw_attendance'] and m['_raw_attendance'].end_at is None]
        elif status_filter == 'notStarted':
            team_data = [m for m in team_data if not m['_raw_attendance']]
        elif status_filter == 'ended':
            team_data = [m for m in team_data if m['_raw_attendance'] and m['_raw_attendance'].end_at is not None]

    total_filtered_items = len(team_data)
    
    # Apply limit
    if parsed_limit:
        team_data = team_data[:parsed_limit]
        
    # Clean up raw data before response
    for m in team_data:
        m.pop('_raw_attendance', None)
        
    return GenericResponse(
        success=True,
        message="Team status fetched successfully",
        data={
            "members": team_data,
            "stats": {
                "total": len(members),
                "working": working_count,
                "notStarted": not_started_count,
                "ended": ended_count
            },
            "options": {
                "statusFilter": status_filter,
                "order": order,
            },
            "pagination": {
                "limit": parsed_limit,
                "totalItems": total_filtered_items
            }
        }
    )
