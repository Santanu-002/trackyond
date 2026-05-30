from pydantic import BaseModel, Field, model_validator
from typing import List, Optional
from datetime import datetime
from core.responses.models import BaseSchema

class JobChatMessageContentBase(BaseSchema):
    type: str # text, image, video, document, pdf, reply
    content: Optional[str] = None
    metadata: Optional[dict] = None

class JobChatMessageContentCreate(JobChatMessageContentBase):
    pass

class JobChatMessageContentResponse(JobChatMessageContentBase):
    @model_validator(mode="before")
    @classmethod
    def resolve_metadata_conflict(cls, data):
        if not isinstance(data, dict):
            res = {}
            for field_name in cls.model_fields.keys():
                if field_name == "metadata":
                    res["metadata"] = getattr(data, "metadata_dict", None)
                else:
                    res[field_name] = getattr(data, field_name, None)
            return res
        return data

class JobChatMessageBase(BaseSchema):
    local_id: Optional[str] = Field(None, serialization_alias="localId", validation_alias="localId")
    job_id: str = Field(..., serialization_alias="jobId", validation_alias="jobId")
    sender_uid: Optional[str] = Field(None, serialization_alias="senderUid", validation_alias="senderUid")
    type: str = "message" # 'message' or 'activity'
    metadata: Optional[dict] = None
    action_performed: Optional[str] = Field(None, serialization_alias="actionPerformed", validation_alias="actionPerformed")
    created_by_author_at: datetime = Field(..., serialization_alias="createdByAuthorAt", validation_alias="createdByAuthorAt")

class JobChatMessageCreate(JobChatMessageBase):
    content: List[JobChatMessageContentCreate]

class JobChatMessageResponse(JobChatMessageBase):
    uid: str
    created_at: datetime = Field(..., serialization_alias="createdAt", validation_alias="createdAt")
    updated_at: datetime = Field(..., serialization_alias="updatedAt", validation_alias="updatedAt")
    seen_at: Optional[datetime] = Field(None, serialization_alias="seenAt", validation_alias="seenAt")
    delivered_at: Optional[datetime] = Field(None, serialization_alias="deliveredAt", validation_alias="deliveredAt")
    active: bool
    deleted: bool
    content: List[JobChatMessageContentResponse]

    @model_validator(mode="before")
    @classmethod
    def resolve_metadata_conflict(cls, data):
        if not isinstance(data, dict):
            res = {}
            for field_name in cls.model_fields.keys():
                if field_name == "metadata":
                    res["metadata"] = getattr(data, "metadata_dict", None)
                else:
                    res[field_name] = getattr(data, field_name, None)
            return res
        return data
