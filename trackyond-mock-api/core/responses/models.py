from datetime import datetime
from pydantic import BaseModel, ConfigDict, field_serializer
from pydantic.alias_generators import to_camel
from typing import Any, Optional
from core.utils.datetime_utils import to_utc_iso

class BaseSchema(BaseModel):
    model_config = ConfigDict(
        alias_generator=to_camel,
        populate_by_name=True,
        from_attributes=True,
        serialize_by_alias=True
    )

    @field_serializer('*', check_fields=False)
    def serialize_datetime(self, val: Any) -> Any:
        if isinstance(val, datetime):
            return to_utc_iso(val)
        return val

class GenericResponse(BaseSchema):
    success: bool
    message: str
    data: Optional[Any] = None

class ErrorDetail(BaseSchema):
    error_code: str
    details: Optional[dict] = None
    retry_after: Optional[str] = None # Using snake_case here, will be serialized to retryAfter

class ErrorResponse(BaseSchema):
    success: bool = False
    message: str
    data: Optional[ErrorDetail] = None
