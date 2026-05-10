from fastapi import Depends, Header, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from services.token_service import token_service
from core.errors.exceptions import AppException
from core.constants.enums import UserRole

async def get_current_user(
    authorization: str = Header(...),
    db: Session = Depends(get_db)
) -> models.User:
    """
    extracts the user from the JWT token in the Authorization header.
    """
    if not authorization.startswith("Bearer "):
        raise AppException(
            message="Invalid authorization header format. Expected 'Bearer <token>'",
            error_code="invalid_auth_header",
            status_code=status.HTTP_401_UNAUTHORIZED
        )
    
    token = authorization.split(" ")[1]
    
    # Decode and validate access token
    payload = token_service.decode_token(token, expected_type="access")
    user_uid = payload.get("sub")
    
    if not user_uid:
        raise AppException(
            message="Token payload missing user identity.",
            error_code="invalid_token",
            status_code=status.HTTP_401_UNAUTHORIZED
        )
    
    user = db.query(models.User).filter(models.User.uid == user_uid).first()
    if not user:
        raise AppException(
            message="User not found.",
            error_code="user_not_found",
            status_code=status.HTTP_401_UNAUTHORIZED
        )
    
    return user

async def get_admin_user(current_user: models.User = Depends(get_current_user)) -> models.User:
    """
    Ensures the current user is an admin (OWNER).
    """
    if current_user.role != UserRole.owner:
        raise AppException(
            message="Access denied. Admin role required.",
            error_code="forbidden",
            status_code=status.HTTP_403_FORBIDDEN
        )
    return current_user
