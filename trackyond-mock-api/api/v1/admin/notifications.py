from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from api.dependencies import get_admin_user
from services.notification_service import upsert_admin_fcm_token
from schemas.fcm_token import FCMTokenRequest
from core.responses.models import GenericResponse

router = APIRouter(tags=["Admin Notifications"])

@router.post("/fcm-token", response_model=GenericResponse)
async def register_fcm_token(
    request: FCMTokenRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    """
    Register or update an FCM token for an admin user.
    """
    upsert_admin_fcm_token(
        db=db,
        admin_uid=current_user.uid,
        device_id=request.device_id,
        fcm_token=request.fcm_token,
        platform=request.platform,
        app_version=request.app_version
    )
    return GenericResponse(success=True, message="FCM token registered successfully")
