from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from api.dependencies import get_current_user
from services.notification_service import (
    upsert_employee_fcm_token, 
    update_notification_status,
    get_user_notifications,
    mark_all_notifications_as_seen,
    bulk_update_notifications_status,
    bulk_delete_notifications
)
from schemas.fcm_token import FCMTokenRequest
from core.responses.models import GenericResponse
from pydantic import BaseModel
from core.constants.enums import NotificationStatus
from typing import List, Optional

class NotificationStatusBulkRequest(BaseModel):
    notificationIds: List[str]
    status: NotificationStatus

class NotificationDeleteBulkRequest(BaseModel):
    notificationIds: List[str]

router = APIRouter(prefix="/notifications", tags=["Employee Notifications"])

@router.get("", response_model=GenericResponse)
async def get_notifications(
    limit: int = Query(50, ge=1),
    offset: int = Query(0, ge=0),
    is_read: Optional[bool] = Query(None),
    is_newest_first: bool = Query(True),
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all notifications for the current employee with pagination.
    """
    data = get_user_notifications(db, current_user.uid, limit, offset, is_read, is_newest_first)
    return GenericResponse(
        success=True,
        message="Notifications fetched successfully",
        data=data
    )
@router.post("/status", response_model=GenericResponse)
async def update_notifications_status(
    request: NotificationStatusBulkRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Update the status (read, seen) for multiple notifications.
    """
    bulk_update_notifications_status(db, current_user.uid, request.notificationIds, request.status)
    return GenericResponse(success=True, message=f"Notifications marked as {request.status.value}")

@router.delete("", response_model=GenericResponse)
async def delete_notifications(
    request: NotificationDeleteBulkRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Delete multiple notifications.
    """
    bulk_delete_notifications(db, current_user.uid, request.notificationIds)
    return GenericResponse(success=True, message="Notifications deleted successfully")

@router.post("/fcm-token", response_model=GenericResponse)
async def register_fcm_token(
    request: FCMTokenRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Register or update an FCM token for an employee user.
    """
    upsert_employee_fcm_token(
        db=db,
        employee_uid=current_user.uid,
        device_id=request.deviceId,
        fcm_token=request.fcmToken,
        platform=request.platform,
        app_version=request.appVersion
    )
    return GenericResponse(success=True, message="FCM token registered successfully")
