from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class JobBase(BaseModel):
    title: str
    customerName: str
    customerPhone: str
    customerAddress: Optional[str] = None
    workerProfileUid: Optional[str] = None
    requirePhotoOnStart: bool = False
    requirePhotoOnComplete: bool = False
    captureLocation: bool = True

class JobCreate(JobBase):
    pass

class JobResponse(JobBase):
    jobId: str
    status: str
    createdAt: str
    assignedAt: Optional[str] = None

    class Config:
        from_attributes = True
