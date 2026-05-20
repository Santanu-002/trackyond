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

def serialize_job(job: models.Job, worker_name: str = None, worker_image: str = None, creator_name: str = None, db = None):
    if not job:
        return None

    allowed_actions = []
    if job.status == "pending" or job.status == "assigned":
        has_reached = False
        if db is not None:
            # Check if there is a reached_location activity message
            reached_msg = db.query(models.JobChatMessage).join(models.JobChatMessageContent).filter(
                models.JobChatMessage.job_id == job.job_id,
                models.JobChatMessageContent.type == "activity",
                models.JobChatMessageContent.metadata_json.like('%"activity_type": "reached_location"%')
            ).first()
            if reached_msg:
                has_reached = True
        
        if has_reached:
            allowed_actions = ["start_job_button"]
        else:
            allowed_actions = ["reached_button"]
    # TODO: Implement other buttons (start_job_button, take_break_button, etc.) as we add more job events later

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
        "status": job.status,
        "requirePhotoOnStart": job.require_photo_on_start,
        "requirePhotoOnComplete": job.require_photo_on_complete,
        "captureLocation": job.capture_location,
        "createdAt": to_utc_iso(job.created_at),
        "assignedAt": to_utc_iso(job.assigned_at) if job.assigned_at else None,
        "updatedAt": to_utc_iso(job.updated_at) if job.updated_at else None,
        "completedAt": to_utc_iso(job.completed_at) if job.completed_at else None,
        "allowedActions": allowed_actions
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
