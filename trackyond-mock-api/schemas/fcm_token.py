from pydantic import Field
from typing import Optional
from core.responses.models import BaseSchema

class FCMTokenRequest(BaseSchema):
    deviceId: str = Field(..., alias="deviceId", description="Unique device identifier")
    fcmToken: str = Field(..., alias="fcmToken", description="Firebase Cloud Messaging token")
    platform: Optional[str] = Field(None, description="android, ios, web, etc")
    appVersion: Optional[str] = Field(None, alias="appVersion", description="App version string")
    
    class Config:
        populate_by_name = True
