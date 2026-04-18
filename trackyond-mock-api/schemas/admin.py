from core.responses.models import BaseSchema
from typing import List, Optional

class CompanyCreate(BaseSchema):
    company_name: str
    user_phone_no: str
    user_full_name: str
    team_size: int

class MemberCreate(BaseSchema):
    member_name: str
    user_phone_no: str
    designation: str
    member_image: Optional[str] = None
    gender: str

class JobCreate(BaseSchema):
    job_title: str
    problem_description: str
    customer_name: str
    customer_phone_number: str
    customer_address: str
    worker_uid: str
    require_photo_when_work_start: bool = False
    require_photo_on_complete: bool = False
    capture_location: bool = False
