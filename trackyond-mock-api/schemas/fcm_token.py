from pydantic import Field
from typing import Optional
from core.responses.models import BaseSchema

class FCMTokenRequest(BaseSchema):
    fcmToken: str = Field(..., alias="fcmToken", description="Firebase Cloud Messaging token")
    
    class Config:
        populate_by_name = True
