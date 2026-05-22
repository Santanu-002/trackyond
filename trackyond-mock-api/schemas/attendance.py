from core.responses.models import BaseSchema
from typing import Optional
from datetime import datetime

class MarkAttendanceRequest(BaseSchema):
    profile_uid: str
    latitude: float
    longitude: float
    address: Optional[str] = None

class AttendanceResponse(BaseSchema):
    id: int
    profile_uid: str
    user_uid: str
    company_uid: str
    start_at: datetime
    end_at: Optional[datetime] = None
    start_latitude: float
    start_longitude: float
    end_latitude: Optional[float] = None
    end_longitude: Optional[float] = None
    work_hours: Optional[float] = None
    start_address: Optional[str] = None
    end_address: Optional[str] = None
    status: str

