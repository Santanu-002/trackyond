from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel
from typing import Any, Optional

class BaseSchema(BaseModel):
    model_config = ConfigDict(
        alias_generator=to_camel,
        populate_by_name=True,
        from_attributes=True,
        serialize_by_alias=True
    )

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
