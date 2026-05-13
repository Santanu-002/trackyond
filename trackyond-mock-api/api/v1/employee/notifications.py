from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from api.dependencies import get_current_user
from services.notification_service import upsert_employee_fcm_token
from schemas.fcm_token import FCMTokenRequest
from core.responses.models import GenericResponse

router = APIRouter(tags=["Employee Notifications"])

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
        device_id=request.device_id,
        fcm_token=request.fcm_token,
        platform=request.platform,
        app_version=request.app_version
    )
    return GenericResponse(success=True, message="FCM token registered successfully")
