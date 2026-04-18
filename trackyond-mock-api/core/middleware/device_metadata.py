from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import JSONResponse
import json
from core.responses.models import ErrorResponse, ErrorDetail

class DeviceMetadataMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Exclude documentation and health check endpoints
        path = request.url.path
        if path in ["/docs", "/openapi.json", "/redoc", "/health", "/"]:
            return await call_next(request)

        # Required headers
        # device-os, device-os-version, device-id, device-name, browser, browser-version, app-version
        required_headers = {
            "device-os": "Device OS is required",
            "device-os-version": "Device OS version is required",
            "device-id": "Device ID is required",
            "device-name": "Device name is required",
            "browser": "Browser is required",
            "browser-version": "Browser version is required",
            "app-version": "App version is required"
        }

        for header, error_msg in required_headers.items():
            value = request.headers.get(header)
            
            # Check if header exists and is not empty
            if value is None or value.strip() == "":
                return self._error_response(f"Missing or empty header: {header}", "header_missing")

            # Special validation for device-id
            if header == "device-id" and value.upper() == "N/A":
                return self._error_response("Device ID cannot be 'N/A'", "invalid_device_id")

        return await call_next(request)

    def _error_response(self, message: str, error_code: str):
        error_resp = ErrorResponse(
            success=False,
            message=message,
            data=ErrorDetail(error_code=error_code)
        )
        return JSONResponse(
            status_code=400,
            content=error_resp.model_dump()
        )
