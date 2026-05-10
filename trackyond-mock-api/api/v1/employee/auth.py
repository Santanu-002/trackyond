from fastapi import APIRouter, Depends, Header
from sqlalchemy.orm import Session
from db.database import get_db
from schemas.common import OTPRequest, VerifyOTPRequest
from services.auth_service import auth_service
from core.responses.models import GenericResponse
from core.constants.app_strings import strings

router = APIRouter(prefix="/auth", tags=["Employee/Auth"])

@router.post("/send-otp", response_model=GenericResponse)
async def send_otp(req: OTPRequest, db: Session = Depends(get_db), device_id: str = Header(alias="device-id")):
    data = auth_service.send_otp_logic(db, req.phone, device_id, role="worker")
    return GenericResponse(
        success=True,
        message=strings.otp_sent,
        data=data
    )

@router.post("/resend-otp", response_model=GenericResponse)
async def resend_otp(req: OTPRequest, db: Session = Depends(get_db), device_id: str = Header(alias="device-id")):
    data = auth_service.send_otp_logic(db, req.phone, device_id, is_resend=True, role="worker")
    return GenericResponse(
        success=True,
        message=strings.otp_resent,
        data=data
    )

@router.post("/verify-otp", response_model=GenericResponse)
async def verify_otp(
    req: VerifyOTPRequest, 
    db: Session = Depends(get_db),
    device_id: str = Header(alias="device-id"),
    device_os: str = Header(alias="device-os"),
    device_os_version: str = Header(alias="device-os-version"),
    device_name: str = Header(alias="device-name"),
    browser: str = Header(alias="browser"),
    browser_version: str = Header(alias="browser-version"),
    app_version: str = Header(alias="app-version")
):
    metadata = {
        "deviceOs": device_os,
        "deviceOsVersion": device_os_version,
        "deviceName": device_name,
        "browser": browser,
        "browserVersion": browser_version,
        "appVersion": app_version
    }
    
    success, is_new_user, response_data = auth_service.verify_otp_logic(
        db, req.phone, req.otp_id, req.otp, device_id, metadata, role="worker"
    )

    
    if not success:
        return GenericResponse(success=False, message=strings.invalid_otp)
    
    return GenericResponse(
        success=True,
        message=strings.login_success,
        data=response_data
    )

@router.post("/refresh", response_model=GenericResponse)
async def refresh_token(
    db: Session = Depends(get_db),
    authorization: str = Header(...),
    x_refresh_token: str = Header(alias="x-refresh-token"),
    device_id: str = Header(alias="device-id")
):
    tokens = auth_service.refresh_token_logic(db, authorization, x_refresh_token, device_id)
    return GenericResponse(
        success=True,
        message="Token refreshed successfully",
        data=tokens
    )

@router.post("/logout", response_model=GenericResponse)
async def logout():
    return GenericResponse(
        success=True,
        message="Logged out successfully"
    )
