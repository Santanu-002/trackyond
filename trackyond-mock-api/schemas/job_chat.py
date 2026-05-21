from pydantic import BaseModel, Field, AliasChoices
from typing import List, Optional, Any
from datetime import datetime
from core.responses.models import BaseSchema

class JobChatMessageContentBase(BaseSchema):
    type: str # text, image, video, docs, activity
    message: Optional[str] = None
    metadata: Optional[dict] = Field(None, validation_alias=AliasChoices("metadata", "metadata_dict"))
    action_performed: Optional[str] = None

class JobChatMessageContentCreate(JobChatMessageContentBase):
    pass

class JobChatMessageContentResponse(JobChatMessageContentBase):
    id: int

class JobChatMessageBase(BaseSchema):
    uid: Optional[str] = None
    local_id: Optional[str] = None
    job_id: str
    author_type: str = "user"
    created_by_uid: Optional[str] = None
    created_by_profile_uid: Optional[str] = None
    status: str = "sent"
    created_by_author_at: datetime

class JobChatMessageCreate(JobChatMessageBase):
    contents: List[JobChatMessageContentCreate]

class JobChatMessageResponse(JobChatMessageBase):
    created_at: datetime
    updated_at: datetime
    seen_at: Optional[datetime] = None
    delivered_at: Optional[datetime] = None
    active: bool
    deleted: bool
    contents: List[JobChatMessageContentResponse]
