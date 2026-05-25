import uuid
import json
from datetime import datetime
from sqlalchemy.orm import Session
from db import models
from core.constants.enums import NotificationStatus, UserRole, NotificationType
from typing import Optional, List, Dict, Any
from firebase_admin import messaging
from services.serializers import serialize_notification
from core.utils.datetime_utils import to_utc_iso, now_utc

def upsert_admin_fcm_token(db: Session, admin_uid: str, device_id: str, fcm_token: str, platform: Optional[str] = None, app_version: Optional[str] = None):
    """
    Business logic for admin FCM token registration.
    """
    member = db.query(models.Member).filter(models.Member.user_uid == admin_uid).first()
    profile_uid = member.uid if member else None

    return upsert_fcm_token(
        db=db,
        user_uid=admin_uid,
        user_role=UserRole.owner,
        device_id=device_id,
        fcm_token=fcm_token,
        platform=platform,
        app_version=app_version,
        profile_uid=profile_uid
    )

def upsert_employee_fcm_token(db: Session, employee_uid: str, device_id: str, fcm_token: str, platform: Optional[str] = None, app_version: Optional[str] = None):
    """
    Business logic for employee FCM token registration.
    """
    member = db.query(models.Member).filter(models.Member.user_uid == employee_uid).first()
    profile_uid = member.uid if member else None

    return upsert_fcm_token(
        db=db,
        user_uid=employee_uid,
        user_role=UserRole.worker,
        device_id=device_id,
        fcm_token=fcm_token,
        platform=platform,
        app_version=app_version,
        profile_uid=profile_uid
    )

def upsert_fcm_token(
    db: Session, 
    user_uid: str, 
    user_role: UserRole, 
    device_id: str, 
    fcm_token: str, 
    platform: Optional[str] = None, 
    app_version: Optional[str] = None,
    profile_uid: Optional[str] = None
):
    """
    Upserts an FCM token for a given user and device.
    """
    token_record = db.query(models.FCMToken).filter(
        models.FCMToken.user_uid == user_uid,
        models.FCMToken.device_id == device_id
    ).first()

    now = now_utc()
    if token_record:
        token_record.fcm_token = fcm_token
        token_record.user_role = user_role
        token_record.platform = platform
        token_record.app_version = app_version
        token_record.profile_uid = profile_uid
        token_record.is_active = True
        token_record.updated_at = now
    else:
        token_record = models.FCMToken(
            user_uid=user_uid,
            profile_uid=profile_uid,
            device_id=device_id,
            fcm_token=fcm_token,
            user_role=user_role,
            platform=platform,
            app_version=app_version,
            is_active=True,
            created_at=now,
            updated_at=now
        )
        db.add(token_record)
    
    db.commit()
    db.refresh(token_record)
    return token_record

def deactivate_fcm_token(db: Session, user_uid: str, device_id: str):
    """
    Deactivates an FCM token (usually on logout).
    """
    token_record = db.query(models.FCMToken).filter(
        models.FCMToken.user_uid == user_uid,
        models.FCMToken.device_id == device_id
    ).first()

    if token_record:
        token_record.is_active = False
        token_record.updated_at = now_utc()
        db.commit()
        return True
    return False

def build_notification_payload(
    notification_id: str,
    notification_type: NotificationType,
    title: str,
    body: str,
    extra_data: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """
    Constructs a standard notification payload.
    """
    payload = {
        "id": notification_id,
        "type": notification_type.value if isinstance(notification_type, NotificationType) else notification_type,
        "title": title,
        "body": body,
        "createdAt": to_utc_iso(),
    }
    if extra_data:
        payload.update(extra_data)
    return payload

def create_notification(
    db: Session, 
    user_uid: str, 
    body: str, 
    title: str = "Notification", 
    profile_uid: Optional[str] = None, 
    notification_type: NotificationType = NotificationType.system,
    extra_data: Optional[dict] = None
):
    """
    Creates a notification record and sends FCM push.
    """
    now = now_utc()
    title = title or "Notification"
    
    # Generate unique ID for this notification
    notification_id = uuid.uuid4().hex.upper()

    # Construct structured payload
    payload_dict = build_notification_payload(
        notification_id=notification_id,
        notification_type=notification_type,
        title=title,
        body=body,
        extra_data=extra_data
    )
    data_payload = json.dumps(payload_dict)

    new_notification = models.Notification(
        notification_id=notification_id,
        user_uid=user_uid,
        profile_uid=profile_uid,
        title=title,
        body=body,
        data_payload=data_payload,
        status=NotificationStatus.sent,
        read=False,
        seen=False,
        deleted=False,
        created_at=now,
        updated_at=now
    )
    db.add(new_notification)
    db.commit()
    db.refresh(new_notification)

    # FCM PUSH
    tokens = db.query(models.FCMToken).filter(
        models.FCMToken.user_uid == user_uid,
        models.FCMToken.is_active == True
    ).all()
    
    fcm_tokens = [t.fcm_token for t in tokens]
    
    if fcm_tokens:
        # FCM data must be flat strings
        fcm_data = {k: str(v) for k, v in payload_dict.items()}
        fcm_data.update({
            "notificationId": notification_id,
            "clickAction": "FLUTTER_NOTIFICATION_CLICK",
        })
        
        message_payload = messaging.MulticastMessage(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=fcm_data,
            tokens=fcm_tokens,
        )
        
        try:
            messaging.send_each_for_multicast(message_payload)
        except Exception as e:
            print(f"Error sending FCM: {e}")

    return new_notification

def get_user_notifications(db: Session, user_uid: str, limit: int = 50, offset: int = 0, is_read: Optional[bool] = None, is_newest_first: bool = True):
    """
    Retrieves notifications for a specific user, excluding deleted ones, with optional read filter and sort order.
    """
    query = db.query(models.Notification).filter(
        models.Notification.user_uid == user_uid,
        models.Notification.deleted == False
    )

    if is_read is not None:
        query = query.filter(models.Notification.read == is_read)

    if is_newest_first:
        query = query.order_by(models.Notification.created_at.desc())
    else:
        query = query.order_by(models.Notification.created_at.asc())
    
    total_count = query.count()
    results = query.limit(limit).offset(offset).all()
    
    return {
        "totalCount": total_count,
        "notifications": [serialize_notification(n) for n in results],
        "limit": limit,
        "offset": offset
    }

def mark_all_notifications_as_seen(db: Session, user_uid: str):
    """
    Marks all unseen notifications as seen.
    """
    now = now_utc()
    db.query(models.Notification).filter(
        models.Notification.user_uid == user_uid,
        models.Notification.seen == False,
        models.Notification.deleted == False
    ).update({
        "seen": True,
        "seen_at": now,
        "status": NotificationStatus.seen,
        "updated_at": now
    }, synchronize_session=False)
    
    db.commit()
    return True

def bulk_update_notifications_status(db: Session, user_uid: str, notification_ids: List[str], status: NotificationStatus):
    """
    Updates the status (read, seen) for a list of notifications.
    """
    now = now_utc()
    update_data = {"status": status, "updated_at": now}
    
    if status == NotificationStatus.read:
        update_data.update({"read": True, "seen": True, "seen_at": now})
    elif status == NotificationStatus.seen:
        update_data.update({"seen": True, "seen_at": now})
    
    db.query(models.Notification).filter(
        models.Notification.user_uid == user_uid,
        models.Notification.notification_id.in_(notification_ids)
    ).update(update_data, synchronize_session=False)
    
    db.commit()
    return True

def bulk_delete_notifications(db: Session, user_uid: str, notification_ids: List[str]):
    """
    Soft deletes a list of notifications.
    """
    now = now_utc()
    member = db.query(models.Member).filter(models.Member.user_uid == user_uid).first()
    deleted_by_uid = member.uid if member else None

    db.query(models.Notification).filter(
        models.Notification.user_uid == user_uid,
        models.Notification.notification_id.in_(notification_ids)
    ).update({
        "deleted": True,
        "deleted_at": now,
        "deleted_by": deleted_by_uid,
        "updated_at": now
    }, synchronize_session=False)
    
    db.commit()
    return True

def get_unread_notification_count(db: Session, user_uid: str):
    """
    Returns the count of unseen notifications.
    """
    return db.query(models.Notification).filter(
        models.Notification.user_uid == user_uid,
        models.Notification.seen == False,
        models.Notification.deleted == False
    ).count()

def update_notification_status(db: Session, notification_id: str, status: NotificationStatus):
    """
    Updates status for a single notification (legacy/fallback).
    """
    notification = db.query(models.Notification).filter(models.Notification.notification_id == notification_id).first()
    if notification:
        now = now_utc()
        notification.status = status
        notification.updated_at = now
        if status == NotificationStatus.delivered:
            notification.delivered_at = now
        elif status == NotificationStatus.seen:
            notification.seen = True
            notification.seen_at = now
        elif status == NotificationStatus.read:
            notification.read = True
            notification.seen = True
            notification.seen_at = now
        db.commit()
        return True
    return False

def send_job_chat_notification(
    db: Session,
    job: models.Job,
    sender_user: models.User,
    message: models.JobChatMessage,
    message_serialized: dict
):
    """
    Sends an FCM push notification to the recipient of a job chat message.
    """
    # 1. Determine sender name
    sender_member = db.query(models.Member).filter(
        models.Member.user_uid == sender_user.uid
    ).first()
    sender_name = sender_member.name if sender_member else "Someone"

    # 2. Determine recipient user_uid
    recipient_user_uid = None
    if sender_user.uid == job.created_by:
        # Sender is the owner/creator, recipient is the worker
        worker_member = db.query(models.Member).filter(
            models.Member.uid == job.worker_profile_uid
        ).first()
        if worker_member:
            recipient_user_uid = worker_member.user_uid
    else:
        # Sender is the worker, recipient is the creator/admin
        recipient_user_uid = job.created_by

    if not recipient_user_uid:
        print(f"DEBUG: No recipient found for job chat message {message.uid}")
        return

    # 3. Fetch active FCM tokens for the recipient
    tokens = db.query(models.FCMToken).filter(
        models.FCMToken.user_uid == recipient_user_uid,
        models.FCMToken.is_active == True
    ).all()
    
    fcm_tokens = [t.fcm_token for t in tokens]
    if not fcm_tokens:
        print(f"DEBUG: No active FCM tokens for recipient {recipient_user_uid}")
        return

    # 4. Construct title and body
    title = f"New message from {sender_name}"
    
    # Get message body text
    body = "Sent an attachment"
    if message.content:
        # Find first text content
        text_content = next((c.content for c in message.content if c.type == "text"), None)
        if text_content:
            body = text_content
        else:
            # If no text, check if there is other content types
            first_content = message.content[0]
            if first_content.type == "image":
                body = "Sent a photo"
            elif first_content.type == "activity":
                body = first_content.content or "Performed an action"
            elif first_content.type == "video":
                body = "Sent a video"
            elif first_content.type == "docs":
                body = "Sent a document"

    # 5. Get full job details serialized for the notification payload
    from services.jobs_service import get_job_with_details
    serialized_job = get_job_with_details(db, job)

    # Construct the custom data payload
    fcm_data = {
        "type": "jobChatMessage",
        "jobId": str(job.job_id),
        "message": json.dumps(message_serialized),
        "job": json.dumps(serialized_job),
        "clickAction": "FLUTTER_NOTIFICATION_CLICK",
    }

    # FCM payload
    message_payload = messaging.MulticastMessage(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        data=fcm_data,
        tokens=fcm_tokens,
    )

    try:
        response = messaging.send_each_for_multicast(message_payload)
        print(f"DEBUG: Sent job chat message FCM notification. Success count: {response.success_count}, Failure count: {response.failure_count}")
    except Exception as e:
        print(f"Error sending FCM: {e}")

