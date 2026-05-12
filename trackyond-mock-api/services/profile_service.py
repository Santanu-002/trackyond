from sqlalchemy.orm import Session

from db import models


def _company_summary(company: models.Company):
    return {
        "id": company.company_id if company else None,
        "name": company.name if company else "Unknown Company",
    }


def _profile_summary(member: models.Member, company: models.Company, is_primary: bool):
    return {
        "accountUid": member.account_uid,
        "userUid": member.user_uid,
        "name": member.name,
        "designation": member.designation,
        "image": member.image,
        "company": _company_summary(company),
        "isPrimary": is_primary,
    }


def _profile_details(member: models.Member):
    return {
        "accountUid": member.account_uid,
        "userUid": member.user_uid,
        "name": member.name,
        "phone": member.phone,
        "designation": member.designation,
        "image": member.image,
        "gender": member.gender,
        "companyUid": member.company_uid,
    }


def _company_details(company: models.Company):
    return {
        "companyId": company.company_id if company else None,
        "companyName": company.name if company else None,
        "teamSize": company.team_size if company else None,
        "ownerUid": company.owner_uid if company else None,
    }


def get_employee_profiles_data(db: Session, user: models.User):
    memberships = db.query(models.Member).filter(
        models.Member.user_uid == user.uid,
        models.Member.is_active == True,
    ).all()

    profiles = []
    for membership in memberships:
        company = db.query(models.Company).filter(
            models.Company.company_id == membership.company_uid
        ).first()
        profiles.append(
            _profile_summary(
                membership,
                company,
                user.primary_account_uid == membership.account_uid,
            )
        )

    return {"profiles": profiles}, None


def get_employee_profile_data(db: Session, user: models.User):
    memberships = db.query(models.Member).filter(
        models.Member.user_uid == user.uid,
        models.Member.is_active == True,
    ).all()

    if not memberships:
        return None, "Employee profile not found"

    active_member = None
    if user.primary_account_uid:
        active_member = next(
            (m for m in memberships if m.account_uid == user.primary_account_uid),
            None,
        )

    if not active_member:
        active_member = memberships[0]

    company = db.query(models.Company).filter(
        models.Company.company_id == active_member.company_uid
    ).first()

    return {
        "profile": _profile_details(active_member),
        "company": _company_details(company),
    }, None


def switch_employee_profile(db: Session, user: models.User, account_uid: str):
    membership = db.query(models.Member).filter(
        models.Member.account_uid == account_uid,
        models.Member.user_uid == user.uid,
        models.Member.is_active == True,
    ).first()

    if not membership:
        return None, "Invalid profile UID"

    user.primary_account_uid = account_uid
    db.commit()

    company = db.query(models.Company).filter(
        models.Company.company_id == membership.company_uid
    ).first()

    return {
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
        },
    }, None


def get_admin_profile_data(db: Session, admin_uid: str):
    admin_member = db.query(models.Member).filter(
        models.Member.user_uid == admin_uid
    ).first()
    if not admin_member:
        return None, "Admin profile not found"

    company = db.query(models.Company).filter(
        models.Company.company_id == admin_member.company_uid
    ).first()

    return {
        "profile": _profile_details(admin_member),
        "company": _company_details(company),
    }, None
