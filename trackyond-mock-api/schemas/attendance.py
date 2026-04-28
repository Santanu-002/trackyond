from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class MarkAttendanceRequest(BaseModel):
    accountUid: str
    latitude: float
    longitude: float
    address: Optional[str] = None

class AttendanceResponse(BaseModel):
    id: int
    accountUid: str
    userUid: str
    companyUid: str
    startAt: datetime
    endAt: Optional[datetime] = None
    startLatitude: float
    startLongitude: float
    endLatitude: Optional[float] = None
    endLongitude: Optional[float] = None
    workHours: Optional[float] = None
    status: str

    class Config:
        from_attributes = True
