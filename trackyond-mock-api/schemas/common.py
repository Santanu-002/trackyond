from core.responses.models import BaseSchema
from pydantic import Field
import re

PHONE_REGEX = r"^\+91\d{10}$"

class OTPRequest(BaseSchema):
    phone: str = Field(..., pattern=PHONE_REGEX)

class VerifyOTPRequest(BaseSchema):
    phone: str = Field(..., pattern=PHONE_REGEX)
    otp_id: str
    otp: str

class RefreshTokenRequest(BaseSchema):
    refresh_token: str
