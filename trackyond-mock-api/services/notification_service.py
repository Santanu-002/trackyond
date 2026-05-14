import uuid
from datetime import datetime, timezone
from sqlalchemy.orm import Session
from db import models
from core.constants.enums import NotificationStatus, UserRole
from typing import Optional

def upsert_admin_fcm_token(db: Session, admin_uid: str, device_id: str, fcm_token: str, platform: Optional[str] = None, app_version: Optional[str] = None):
    """
    Business logic for admin FCM token registration.
    """
    # Fetch member to get profile_uid
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
    # Fetch member to get profile_uid
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
    Overwrites the token if the device_id exists for the user_uid.
    """
    token_record = db.query(models.FCMToken).filter(
        models.FCMToken.user_uid == user_uid,
        models.FCMToken.device_id == device_id
    ).first()

    now = datetime.now(timezone.utc)
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
        token_record.updated_at = datetime.now(timezone.utc)
        db.commit()
        return True
    return False

def create_notification(db: Session, user_uid: str, message: str, title: Optional[str] = None, profile_uid: Optional[str] = None, data_payload: Optional[str] = None):
    """
    Creates a notification record in the database for a specific user.
    """
    now = datetime.now(timezone.utc)
    notification = models.Notification(
        notification_id=uuid.uuid4().hex[:12].upper(),
        user_uid=user_uid,
        profile_uid=profile_uid,
        title=title,
        message=message,
        data_payload=data_payload,
        status=NotificationStatus.sent,
        read=False,
        created_at=now,
        updated_at=now
    )
    db.add(notification)
    db.commit()
    db.refresh(notification)
    return notification

def get_user_notifications(db: Session, user_uid: str):
    """
    Retrieves all notifications for a specific user.
    """
    return db.query(models.Notification).filter(
        models.Notification.user_uid == user_uid
    ).order_by(models.Notification.created_at.desc()).all()

def update_notification_status(db: Session, notification_id: str, status: NotificationStatus):
    """
    Updates the delivery/read status of a specific notification.
    """
    notification = db.query(models.Notification).filter(
        models.Notification.notification_id == notification_id
    ).first()
    
    if notification:
        notification.status = status
        now = datetime.now(timezone.utc)
        notification.updated_at = now
        
        if status == NotificationStatus.delivered:
            if not notification.delivered_at:
                notification.delivered_at = now
        elif status == NotificationStatus.read:
            notification.read = True
            if not notification.delivered_at:
                notification.delivered_at = now
            if not notification.seen_at:
                notification.seen_at = now
                
        db.commit()
        db.refresh(notification)
        return True
    return False
