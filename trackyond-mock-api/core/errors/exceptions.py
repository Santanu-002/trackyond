from fastapi import HTTPException, Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from core.responses.models import ErrorResponse, ErrorDetail

class AppException(Exception):
    def __init__(self, message: str, error_code: str, status_code: int = 400, details: dict = None, retry_after: str = None):
        self.message = message
        self.error_code = error_code
        self.status_code = status_code
        self.details = details
        self.retry_after = retry_after

async def app_exception_handler(request: Request, exc: AppException):
    return JSONResponse(
        status_code=exc.status_code,
        content=ErrorResponse(
            message=exc.message,
            data=ErrorDetail(
                error_code=exc.error_code, 
                details=exc.details,
                retry_after=exc.retry_after
            )
        ).model_dump(by_alias=True)
    )

async def validation_exception_handler(request: Request, exc: RequestValidationError):
    # Default message
    error_msg = "Invalid request data"
    error_code = "validation_error"
    
    errors = exc.errors()
    if errors:
        first_error = errors[0]
        field = ".".join([str(p) for p in first_error.get("loc", []) if p != "body"])
        error_type = first_error.get("type")
        
        if error_type == "string_pattern_mismatch" and "phone" in field:
            error_msg = f"Invalid phone number format. Expected +91 followed by 10 digits."
            error_code = "invalid_phone_format"
        elif error_type == "missing":
            error_msg = f"Field '{field}' is required."
            error_code = "missing_field"
        else:
             error_msg = f"Error in field '{field}': {first_error.get('msg', 'Invalid value')}"

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=ErrorResponse(
            message=error_msg,
            data=ErrorDetail(
                error_code=error_code,
                details={"errors": exc.errors()}
            )
        ).model_dump(by_alias=True)
    )
