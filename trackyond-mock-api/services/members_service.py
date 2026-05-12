import os
import shutil
import uuid

from sqlalchemy.orm import Session

from core.constants.app_strings import strings
from core.utils.datetime_utils import to_utc_iso
from db import models


def _serialize_member(member: models.Member):
    return {
        "accountUid": member.account_uid,
        "userUid": member.user_uid,
        "name": member.name,
        "phone": member.phone,
        "designation": member.designation,
        "image": member.image,
        "gender": member.gender,
        "companyUid": member.company_uid,
        "createdBy": member.created_by,
    }


def get_admin_members_data(db: Session, admin_uid: str):
    admin_member = db.query(models.Member).filter(
        models.Member.user_uid == admin_uid
    ).first()
    if not admin_member:
        return None, "Admin profile not found"

    members = db.query(models.Member).filter(
        models.Member.company_uid == admin_member.company_uid
    ).all()

    return {"members": [_serialize_member(member) for member in members]}, None


def _save_member_image(member_image, company_uid: str, target_user_uid: str):
    if not member_image:
        return None

    try:
        upload_dir = os.path.join("uploads", company_uid, target_user_uid)
        os.makedirs(upload_dir, exist_ok=True)

        for filename in os.listdir(upload_dir):
            if filename.startswith("avatar."):
                os.remove(os.path.join(upload_dir, filename))

        _, ext = os.path.splitext(member_image.filename)
        if not ext:
            ext = ".jpg"

        filename = f"avatar{ext}"
        file_path = os.path.join(upload_dir, filename)

        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(member_image.file, buffer)

        return f"uploads/{company_uid}/{target_user_uid}/avatar{ext}"
    except Exception as exc:
        print(f"Error saving image: {str(exc)}")
        return None


def add_admin_member_data(
    db: Session,
    admin_uid: str,
    member_name: str,
    user_phone_no: str,
    designation: str,
    gender: str,
    company_uid: str,
    member_image=None,
):
    user = db.query(models.User).filter(models.User.phone == user_phone_no).first()

    if user:
        existing_member = db.query(models.Member).filter(
            models.Member.user_uid == user.uid,
            models.Member.company_uid == company_uid,
        ).first()

        if existing_member:
            return None, "Member already exists in this company"

        target_user_uid = user.uid
    else:
        target_user_uid = uuid.uuid4().hex[:10]
        new_user = models.User(
            uid=target_user_uid,
            phone=user_phone_no,
            role="worker",
            is_new_user=False,
        )
        db.add(new_user)
        db.flush()

    image_path = _save_member_image(member_image, company_uid, target_user_uid)

    new_member = models.Member(
        account_uid=uuid.uuid4().hex[:10],
        user_uid=target_user_uid,
        name=member_name,
        phone=user_phone_no,
        designation=designation,
        image=image_path,
        gender=gender,
        company_uid=company_uid,
        created_by=admin_uid,
    )
    db.add(new_member)
    db.flush()

    target_user = db.query(models.User).filter(
        models.User.uid == target_user_uid
    ).first()
    if target_user and target_user.primary_account_uid is None:
        target_user.primary_account_uid = new_member.account_uid

    db.commit()
    db.refresh(new_member)

    return {
        "accountUid": new_member.account_uid,
        "userUid": new_member.user_uid,
        "name": new_member.name,
        "phone": new_member.phone,
        "designation": new_member.designation,
        "image": new_member.image,
        "gender": new_member.gender,
        "companyUid": new_member.company_uid,
        "createdAt": to_utc_iso(new_member.created_at),
    }, None


def member_added_message():
    return strings.member_added
