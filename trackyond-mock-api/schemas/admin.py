from core.responses.models import BaseSchema
from typing import List, Optional
from pydantic import Field
from .common import PHONE_REGEX

class CompanyCreate(BaseSchema):
    company_name: str
    owner_uid: str
    owner_name: str
    owner_phone: str = Field(..., pattern=PHONE_REGEX)
    team_size: int

class MemberCreate(BaseSchema):
    member_name: str
    user_phone_no: str = Field(..., pattern=PHONE_REGEX)
    designation: str
    member_image: Optional[str] = None
    gender: str
    company_uid: str # Required for adding member

class JobCreate(BaseSchema):
    job_title: str
    problem_description: str
    customer_name: str
    customer_phone_number: str = Field(..., pattern=PHONE_REGEX)
    customer_address: str
    worker_uid: str
    require_photo_when_work_start: bool = False
    require_photo_on_complete: bool = False
    capture_location: bool = False
