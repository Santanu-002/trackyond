from db import models
from core.utils.datetime_utils import to_utc_iso
from core.constants.enums import AttendanceStatus

def serialize_attendance(attendance: models.Attendance):
    if not attendance:
        return None
    status = AttendanceStatus.working if attendance.end_at is None else AttendanceStatus.ended
    return {
        "id": attendance.id,
        "accountUid": attendance.account_uid,
        "userUid": attendance.user_uid,
        "companyUid": attendance.company_uid,
        "status": status,
        "startAt": to_utc_iso(attendance.start_at),
        "endAt": to_utc_iso(attendance.end_at) if attendance.end_at else None,
        "startLatitude": attendance.start_latitude,
        "startLongitude": attendance.start_longitude,
        "endLatitude": attendance.end_latitude,
        "endLongitude": attendance.end_longitude,
        "workHours": attendance.work_hours,
        "startAddress": attendance.start_address,
        "endAddress": attendance.end_address
    }

def serialize_job(job: models.Job, worker_name: str = None, worker_image: str = None):
    if not job:
        return None
    return {
        "jobId": job.job_id,
        "jobTitle": job.title,
        "customerName": job.customer_name,
        "customerPhone": job.customer_phone,
        "customerAddress": job.customer_address,
        "workerAccountUid": job.worker_account_uid,
        "workerName": worker_name,
        "workerImage": worker_image,
        "status": job.status,
        "requirePhotoOnStart": job.require_photo_on_start,
        "requirePhotoOnComplete": job.require_photo_on_complete,
        "captureLocation": job.capture_location,
        "createdAt": to_utc_iso(job.created_at),
        "assignedAt": to_utc_iso(job.assigned_at) if job.assigned_at else None,
        "updatedAt": to_utc_iso(job.updated_at) if job.updated_at else None,
        "completedAt": to_utc_iso(job.completed_at) if job.completed_at else None
    }

def serialize_member_profile(member: models.Member):
    if not member:
        return None
    return {
        "accountUid": member.account_uid,
        "userUid": getattr(member, 'user_uid', ""),
        "name": member.name,
        "phone": member.phone,
        "designation": member.designation if member.designation else "",
        "image": member.image,
        "gender": getattr(member, 'gender', None),
        "companyUid": member.company_uid,
    }

def serialize_company(company: models.Company):
    if not company:
        return None
    return {
        "companyId": company.company_id,
        "companyName": company.name,
        "teamSize": company.team_size,
        "ownerUid": company.owner_uid,
    }
