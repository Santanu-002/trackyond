import uuid

from sqlalchemy.orm import Session

from core.constants.app_strings import strings
from core.utils.datetime_utils import now_utc, to_utc_iso
from db import models
from services.serializers import serialize_attendance, serialize_member_profile


def _serialize_company_for_response(company: models.Company):
    return {
        "companyId": company.company_id,
        "companyName": company.name,
        "teamSize": company.team_size,
        "ownerUid": company.owner_uid,
        "createdAt": to_utc_iso(company.created_at),
    }


def create_company_data(db: Session, req):
    existing = db.query(models.Company).filter(
        models.Company.owner_uid == req.owner_uid
    ).first()
    if existing:
        return None, "Company already exists for this user"

    user = db.query(models.User).filter(models.User.uid == req.owner_uid).first()
    if not user:
        return None, "User not found"

    user.is_new_user = False

    new_company = models.Company(
        company_id="comp_" + str(uuid.uuid4())[:8],
        name=req.company_name,
        owner_uid=req.owner_uid,
        team_size=req.team_size,
    )
    db.add(new_company)

    member = db.query(models.Member).filter(
        models.Member.user_uid == user.uid,
        models.Member.company_uid == new_company.company_id,
    ).first()

    if not member:
        member = models.Member(
            uid=uuid.uuid4().hex[:10],
            user_uid=user.uid,
            name=req.owner_name,
            phone=req.owner_phone,
            designation="Owner",
            gender=None,
            image=None,
            company_uid=new_company.company_id,
            created_by=None,
        )
        db.add(member)
        db.flush()
    else:
        member.name = req.owner_name
        member.phone = req.owner_phone
        member.designation = "Owner"
        member.company_uid = new_company.company_id
        member.created_by = None

    if user.primary_profile_uid is None:
        user.primary_profile_uid = member.uid

    db.commit()
    db.refresh(new_company)
    db.refresh(member)

    return {
        "ownerProfile": {
            "uid": member.uid,
            "userUid": member.user_uid,
            "name": member.name,
            "phone": member.phone,
            "designation": member.designation,
            "image": member.image,
            "gender": member.gender,
        },
        "company": _serialize_company_for_response(new_company),
    }, None


def get_admin_company_data(db: Session, admin_uid: str):
    company = db.query(models.Company).filter(
        models.Company.owner_uid == admin_uid
    ).first()
    if not company:
        return None, "Company not found"

    return _serialize_company_for_response(company), None


def get_admin_team_status_data(
    db: Session,
    admin_uid: str,
    status_filter: str = None,
    order: str = "desc",
    limit: str = None,
):
    parsed_limit = 50
    if limit and limit.isdigit():
        parsed_limit = int(limit)

    company = db.query(models.Company).filter(
        models.Company.owner_uid == admin_uid
    ).first()
    if not company:
        return None, "Company not found"

    members = db.query(models.Member).filter(
        models.Member.company_uid == company.company_id
    ).all()

    team_data = []
    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)

    for member in members:
        latest_attendance = db.query(models.Attendance).filter(
            models.Attendance.profile_uid == member.uid,
            models.Attendance.created_at >= today_start,
        ).order_by(models.Attendance.created_at.desc()).first()

        team_data.append({
            "profile": serialize_member_profile(member),
            "todayAttendance": serialize_attendance(latest_attendance),
            "_raw_attendance": latest_attendance,
        })

    working_count = sum(
        1 for m in team_data
        if m["_raw_attendance"] and m["_raw_attendance"].end_at is None
    )
    not_started_count = sum(1 for m in team_data if not m["_raw_attendance"])
    ended_count = sum(
        1 for m in team_data
        if m["_raw_attendance"] and m["_raw_attendance"].end_at is not None
    )

    def sort_key(item):
        attendance = item["_raw_attendance"]
        profile = item["profile"]
        if not attendance:
            return (2, 0, profile["name"].lower())
        if attendance.end_at is None:
            return (0, -attendance.start_at.timestamp(), profile["name"].lower())
        return (1, -attendance.end_at.timestamp(), profile["name"].lower())

    team_data.sort(key=sort_key)

    if status_filter and status_filter != "all":
        if status_filter == "working":
            team_data = [
                m for m in team_data
                if m["_raw_attendance"] and m["_raw_attendance"].end_at is None
            ]
        elif status_filter == "notStarted":
            team_data = [m for m in team_data if not m["_raw_attendance"]]
        elif status_filter == "ended":
            team_data = [
                m for m in team_data
                if m["_raw_attendance"] and m["_raw_attendance"].end_at is not None
            ]

    total_filtered_items = len(team_data)

    if parsed_limit:
        team_data = team_data[:parsed_limit]

    for member_data in team_data:
        member_data.pop("_raw_attendance", None)

    return {
        "members": team_data,
        "stats": {
            "total": len(members),
            "working": working_count,
            "notStarted": not_started_count,
            "ended": ended_count,
        },
        "options": {
            "statusFilter": status_filter,
            "order": order,
        },
        "pagination": {
            "limit": parsed_limit,
            "totalItems": total_filtered_items,
        },
    }, None


def company_created_message():
    return strings.company_created
