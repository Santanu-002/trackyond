from pydantic import Field
from typing import Optional
from core.responses.models import BaseSchema

class FCMTokenRequest(BaseSchema):
    device_id: str = Field(..., description="Unique device identifier")
    fcm_token: str = Field(..., description="Firebase Cloud Messaging token")
    platform: Optional[str] = Field(None, description="android, ios, web, etc")
    app_version: Optional[str] = Field(None, description="App version string")
