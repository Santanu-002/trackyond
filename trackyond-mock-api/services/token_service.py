from datetime import datetime, timedelta, timezone
from core.utils.datetime_utils import to_utc_iso, now_utc
from typing import Literal

import jwt

from core.config import (
    JWT_ACCESS_EXPIRE_MINUTES,
    JWT_ALGORITHM,
    JWT_REFRESH_EXPIRE_DAYS,
    JWT_SECRET_KEY,
)
from core.errors.exceptions import AppException

# Token type literals
TokenType = Literal["access", "refresh"]


class TokenService:
    """
    Issues and validates signed JWT tokens.

    Access token  — expires in JWT_ACCESS_EXPIRE_MINUTES (default 10 min).
    Refresh token — expires in JWT_REFRESH_EXPIRE_DAYS   (default 7 days).
    """

    def generate_tokens(self, user_uid: str, phone: str) -> dict:
        """Generate a fresh access + refresh token pair."""
        now = now_utc()

        access_exp = now + timedelta(minutes=JWT_ACCESS_EXPIRE_MINUTES)
        refresh_exp = now + timedelta(days=JWT_REFRESH_EXPIRE_DAYS)

        access_token = self._sign(
            payload={
                "sub": user_uid,
                "phone": phone,
                "type": "access",
                "iat": int(now.timestamp()),
                "exp": int(access_exp.timestamp()),
            }
        )

        refresh_token = self._sign(
            payload={
                "sub": user_uid,
                "phone": phone,
                "type": "refresh",
                "iat": int(now.timestamp()),
                "exp": int(refresh_exp.timestamp()),
            }
        )

        return {
            "accessToken": access_token,
            "refreshToken": refresh_token,
            "accessExpireAt": to_utc_iso(access_exp),
            "refreshExpireAt": to_utc_iso(refresh_exp),
            "tokenIssuedAt": to_utc_iso(now),
        }

    def decode_token(self, token: str, expected_type: TokenType, verify_exp: bool = True) -> dict:
        """
        Decode and validate a JWT token.
        Raises AppException on any validation failure.
        """
        try:
            payload = jwt.decode(
                token,
                JWT_SECRET_KEY,
                algorithms=[JWT_ALGORITHM],
                options={"verify_exp": verify_exp}
            )
        except jwt.ExpiredSignatureError:
            raise AppException(
                message="Token has expired.",
                error_code="token_expired",
            )
        except jwt.InvalidTokenError as e:
            raise AppException(
                message=f"Invalid token: {e}",
                error_code="invalid_token",
            )

        # Validate token type claim
        if payload.get("type") != expected_type:
            raise AppException(
                message=f"Expected a {expected_type} token.",
                error_code="invalid_token_type",
            )

        return payload

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _sign(payload: dict) -> str:
        return jwt.encode(payload, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)


token_service = TokenService()
