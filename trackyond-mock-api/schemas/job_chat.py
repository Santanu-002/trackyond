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
    deleted_by_uid: Optional[str] = Field(None, serialization_alias="deletedByUid", validation_alias="deletedByUid")
    deleted_by_user_type: Optional[str] = Field(None, serialization_alias="deletedByUserType", validation_alias="deletedByUserType")
    deleted_for: List[str] = Field(default_factory=list, serialization_alias="deletedFor", validation_alias="deletedFor")
    deleted_at: Optional[datetime] = Field(None, serialization_alias="deletedAt", validation_alias="deletedAt")
    deleted_by_user_at: Optional[datetime] = Field(None, serialization_alias="deletedByUserAt", validation_alias="deletedByUserAt")

    @model_validator(mode="before")
    @classmethod
    def resolve_metadata_conflict(cls, data):
        if not isinstance(data, dict):
            res = {}
            for field_name in cls.model_fields.keys():
                if field_name == "metadata":
                    res["metadata"] = getattr(data, "metadata_dict", None)
                elif field_name == "deleted":
                    res["deleted"] = getattr(data, "deleted", False)
                elif field_name == "deleted_for" or field_name == "deletedFor":
                    res["deletedFor"] = getattr(data, "deleted_for_list", [])
                elif field_name == "deleted_by_uid" or field_name == "deletedByUid":
                    res["deletedByUid"] = getattr(data, "deleted_by_uid", None)
                elif field_name == "deleted_by_user_type" or field_name == "deletedByUserType":
                    res["deletedByUserType"] = getattr(data, "deleted_by_user_type", None)
                elif field_name == "deleted_at" or field_name == "deletedAt":
                    res["deletedAt"] = getattr(data, "deleted_at", None)
                elif field_name == "deleted_by_user_at" or field_name == "deletedByUserAt":
                    res["deletedByUserAt"] = getattr(data, "deleted_by_user_at", None)
                else:
                    res[field_name] = getattr(data, field_name, None)
            return res
        return data

class JobChatMessageDeleteRequest(BaseSchema):
    delete_type: str = Field(..., serialization_alias="deleteType", validation_alias="deleteType")
    message_uids: List[str] = Field(..., serialization_alias="messageUids", validation_alias="messageUids")
    deleted_by_user_at: datetime = Field(..., serialization_alias="deletedByUserAt", validation_alias="deletedByUserAt")
