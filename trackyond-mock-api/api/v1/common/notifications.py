from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from api.dependencies import get_current_user
from core.constants.enums import NotificationStatus
from services.notification_service import get_user_notifications, update_notification_status
from schemas.notification import NotificationListResponse
from core.responses.models import GenericResponse

router = APIRouter(prefix="/notifications", tags=["Notifications"])

@router.get("", response_model=NotificationListResponse)
async def list_notifications(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all notifications for the current user.
    """
    notifications = get_user_notifications(db, current_user.uid)
    return NotificationListResponse(notifications=notifications)

@router.post("/{notification_id}/read", response_model=GenericResponse)
async def mark_read(
    notification_id: str,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Mark a notification as read.
    """
    success = update_notification_status(db, notification_id, NotificationStatus.read)
    if not success:
        return GenericResponse(success=False, message="Notification not found")
    
    return GenericResponse(success=True, message="Notification marked as read")

