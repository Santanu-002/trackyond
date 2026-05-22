from db import models
from core.utils.datetime_utils import to_utc_iso
from core.constants.enums import AttendanceStatus

def serialize_attendance(attendance: models.Attendance):
    if not attendance:
        return None
    status = AttendanceStatus.working if attendance.end_at is None else AttendanceStatus.ended
    return {
        "id": attendance.id,
        "profileUid": attendance.profile_uid,
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

def serialize_job(job: models.Job, worker_name: str = None, worker_image: str = None, creator_name: str = None, allowed_actions: list = None):
    if not job:
        return None

    assigned_at = getattr(job, "assigned_at", None)
    started_at = getattr(job, "started_at", None)
    completed_at = getattr(job, "completed_at", None)
    updated_at = getattr(job, "updated_at", None)

    return {
        "jobId": job.job_id,
        "jobTitle": job.title,
        "customerName": job.customer_name,
        "customerPhone": job.customer_phone,
        "customerAddress": job.customer_address,
        "workerProfileUid": job.worker_profile_uid,
        "workerName": worker_name,
        "workerImage": worker_image,
        "createdByProfileUid": job.created_by_profile_uid,
        "createdByName": creator_name,
        "status": job.status.value if hasattr(job.status, 'value') else job.status,
        "requirePhotoOnStart": job.require_photo_on_start,
        "requirePhotoOnComplete": job.require_photo_on_complete,
        "captureLocation": job.capture_location,
        "createdAt": to_utc_iso(job.created_at),
        "assignedAt": to_utc_iso(assigned_at) if assigned_at else None,
        "startedAt": to_utc_iso(started_at) if started_at else None,
        "updatedAt": to_utc_iso(updated_at) if updated_at else None,
        "completedAt": to_utc_iso(completed_at) if completed_at else None,
        "lastMessage": getattr(job, "last_message", None),
        "lastMessageAt": to_utc_iso(job.last_message_at) if getattr(job, "last_message_at", None) else None,
        "lastActivityType": getattr(job, "last_activity_type", None),
        "lastActivityMessage": getattr(job, "last_activity_message", None),
        "lastActivityAt": to_utc_iso(job.last_activity_at) if getattr(job, "last_activity_at", None) else None,
        "allowedActions": allowed_actions or []
    }


def serialize_member_profile(member: models.Member):
    if not member:
        return None
    return {
        "uid": member.uid,
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

def serialize_notification(notification: models.Notification):
    if not notification:
        return None
    return {
        "id": notification.notification_id,
        "userUid": notification.user_uid,
        "profileUid": notification.profile_uid,
        "title": notification.title or "Notification",
        "body": notification.body,
        "dataPayload": notification.data_payload,
        "status": notification.status.value,
        "read": notification.read,
        "seen": notification.seen,
        "createdAt": to_utc_iso(notification.created_at),
        "updatedAt": to_utc_iso(notification.updated_at),
        "deliveredAt": to_utc_iso(notification.delivered_at) if notification.delivered_at else None,
        "seenAt": to_utc_iso(notification.seen_at) if notification.seen_at else None
    }
