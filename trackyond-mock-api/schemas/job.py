from core.responses.models import BaseSchema
from typing import Optional
from datetime import datetime
from pydantic import Field
from schemas.common import PHONE_REGEX

class JobBase(BaseSchema):
    title: str
    customer_name: str
    customer_phone: str = Field(..., pattern=PHONE_REGEX)
    customer_address: Optional[str] = None
    worker_profile_uid: Optional[str] = None
    require_photo_on_start: bool = False
    require_photo_on_complete: bool = False
    capture_location: bool = True

class JobCreate(JobBase):
    pass

class JobResponse(JobBase):
    job_id: str
    status: str
    created_at: datetime


