from fastapi import APIRouter
from core.responses.models import GenericResponse

router = APIRouter(prefix="/v1/auth", tags=["Auth"])

# This router now only contains generic auth endpoints if any.
# Specific role-based auth (send-otp, verify-otp, refresh) 
# are handled in admin.py and employee.py.
