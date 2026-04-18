from datetime import datetime, timedelta
import uuid
import random
from typing import Tuple, Optional
from sqlalchemy.orm import Session
from db import models
from core.database.redis_client import get_redis
from core.errors.exceptions import AppException
from core.config import SECRET_KEY, OTP_EXPIRY_SECONDS
import json
import hmac
import hashlib
import base64

class AuthService:
    def __init__(self):
        self.r = get_redis()
        self.EXPIRY_SECONDS = OTP_EXPIRY_SECONDS
        self.MAX_ATTEMPTS = 5
        self.DELAYS = [30, 60, 90, 120] 
        self.COOLDOWN_SECONDS = 7200 # 2 hours cooldown after max attempts

    def _generate_otp_token(self, phone: str, device_id: str) -> str:
        now = datetime.utcnow()
        exp = now + timedelta(seconds=self.EXPIRY_SECONDS)
        
        payload = {
            "phone": phone,
            "device_id": device_id,
            "iat": now.isoformat(),
            "exp": exp.isoformat()
        }
        
        payload_str = json.dumps(payload, separators=(',', ':'))
        payload_b64 = base64.urlsafe_b64encode(payload_str.encode()).decode().rstrip('=')
        
        signature = hmac.new(
            SECRET_KEY.encode(),
            payload_b64.encode(),
            hashlib.sha256
        ).hexdigest()
        
        return f"{payload_b64}.{signature}"

    def _verify_otp_token(self, token: str, expected_phone: str, expected_device_id: str) -> dict:
        try:
            if "." not in token:
                raise AppException(message="Invalid OTP ID format.", error_code="invalid_otp_id")
            
            payload_b64, signature = token.split(".")
            
            # 1. Verify Signature
            expected_signature = hmac.new(
                SECRET_KEY.encode(),
                payload_b64.encode(),
                hashlib.sha256
            ).hexdigest()
            
            if not hmac.compare_digest(signature, expected_signature):
                raise AppException(message="OTP ID signature mismatch.", error_code="invalid_otp_id")
            
            # 2. Decode Payload
            padding = '=' * (4 - len(payload_b64) % 4)
            payload_str = base64.urlsafe_b64decode(payload_b64 + padding).decode()
            payload = json.loads(payload_str)
            
            # 3. Check Expiry
            exp = datetime.fromisoformat(payload["exp"])
            if datetime.utcnow() > exp:
                raise AppException(message="OTP has expired.", error_code="otp_expired")
            
            # 4. Bind check
            if payload["phone"] != expected_phone:
                raise AppException(message="OTP ID does not match this phone number.", error_code="invalid_otp_id")
            if payload["device_id"] != expected_device_id:
                raise AppException(message="OTP generated for a different device.", error_code="device_mismatch")
                
            return payload
            
        except (ValueError, KeyError, json.JSONDecodeError):
            raise AppException(message="Malformed OTP ID.", error_code="invalid_otp_id")

    def send_otp_logic(self, phone: str, device_id: str, is_resend: bool = False) -> dict:
        now = datetime.utcnow()
        # Normalize phone number
        phone = phone.strip()
        limit_key = f"otp_limit:{phone}"
        
        # 1. Fetch current limit state
        state_raw = self.r.get(limit_key)
        
        if state_raw:
            try:
                state = json.loads(state_raw)
                attempts = int(state.get("attempts", 0))
                last_sent_at_str = state.get("last_sent_at")
                last_sent_at = datetime.fromisoformat(last_sent_at_str) if last_sent_at_str else None
                blocked_until_str = state.get("blocked_until")
                blocked_until = datetime.fromisoformat(blocked_until_str) if blocked_until_str else None
            except (json.JSONDecodeError, ValueError, TypeError):
                attempts = 0
                last_sent_at = None
                blocked_until = None
                state = None
        else:
            state = None
            attempts = 0
            last_sent_at = None
            blocked_until = None
        
        # 2. Check if currently blocked
        if blocked_until and now < blocked_until:
             raise AppException(
                message="Maximum OTP attempts reached. Please try again later.", 
                error_code="rate_limit_exceeded",
                retry_after=blocked_until.isoformat()
            )
        
        # 3. If attempts exceeded but block expired, reset
        if attempts >= self.MAX_ATTEMPTS:
            if not blocked_until:
                # This handles the transition to blocked state
                blocked_until = (last_sent_at or now) + timedelta(seconds=self.COOLDOWN_SECONDS)
                # Save the blocked state immediately
                new_state = {
                    "attempts": attempts,
                    "last_sent_at": (last_sent_at or now).isoformat(),
                    "blocked_until": blocked_until.isoformat()
                }
                self.r.setex(limit_key, self.COOLDOWN_SECONDS + 3600, json.dumps(new_state))
                
                raise AppException(
                    message="Maximum OTP attempts reached. Please try again later.", 
                    error_code="rate_limit_exceeded",
                    retry_after=blocked_until.isoformat()
                )
            
            # If we reached here, blocked_until passed, so reset attempts for a fresh cycle
            attempts = 0
            last_sent_at = None
            blocked_until = None

        # 4. Check Delay if it's a resend
        if is_resend and last_sent_at:
            # Delay increments: 30s, 60s, 90s, 120s
            delay_idx = attempts - 1
            current_delay_sec = self.DELAYS[delay_idx] if 0 <= delay_idx < len(self.DELAYS) else 120
            next_allowed_at = last_sent_at + timedelta(seconds=current_delay_sec)
            
            if now < next_allowed_at:
                wait_time = int((next_allowed_at - now).total_seconds())
                raise AppException(
                    message=f"Please wait {wait_time}s before resending OTP.", 
                    error_code="too_early_resend"
                )

        # 4. Generate OTP and Stateless ID
        otp_id = self._generate_otp_token(phone, device_id)
        otp_code = f"{random.randint(100000, 999999):06d}"
        
        # 5. Print OTP to console for developer access
        print(f"\n{'='*50}")
        print(f"[MOCK OTP] Phone: {phone}")
        print(f"[MOCK OTP] Code:  {otp_code}")
        print(f"{'='*50}\n")

        # 6. Store OTP in Redis (Stateful)
        otp_store_key = f"otp_code:{otp_id}"
        self.r.setex(otp_store_key, self.EXPIRY_SECONDS, otp_code)
        
        # 7. Update Limit State
        new_attempts = attempts + 1
        new_state = {
            "attempts": new_attempts,
            "last_sent_at": now.isoformat(),
            "blocked_until": None
        }
        
        # If this was the last allowed attempt, calculate and set blocked_until for the next call
        if new_attempts >= self.MAX_ATTEMPTS:
            blocked_until = now + timedelta(seconds=self.COOLDOWN_SECONDS)
            new_state["blocked_until"] = blocked_until.isoformat()
        
        # Keep limit state for cooldown period + 1 hour buffer
        ttl = self.COOLDOWN_SECONDS + 3600
        self.r.setex(limit_key, ttl, json.dumps(new_state))

        # 8. Prepare Response Data
        # Calculate next resendableAt
        delay_sec = 0
        if new_attempts < self.MAX_ATTEMPTS:
            delay_idx = new_attempts - 1
            delay_sec = self.DELAYS[delay_idx] if 0 <= delay_idx < len(self.DELAYS) else 120
            
        resendable_at = (now + timedelta(seconds=delay_sec)).isoformat() if delay_sec > 0 else None
        expires_at = (now + timedelta(seconds=self.EXPIRY_SECONDS)).isoformat()
        
        return {
            "phone": phone,
            "otpId": otp_id,
            "expiresAt": expires_at,
            "resendableAt": resendable_at,
            "remainingAttempts": self.MAX_ATTEMPTS - new_attempts
        }

    def verify_otp_logic(self, db: Session, phone: str, otp_id: str, otp: str, current_device_id: str) -> Tuple[bool, bool, dict]:
        # 1. Verify Stateless Token
        payload = self._verify_otp_token(otp_id, phone, current_device_id)
        
        # 2. Check "Spent" list in Redis to prevent Replay
        spent_key = f"otp_spent:{otp_id}"
        if self.r.get(spent_key):
            raise AppException(message="OTP already used.", error_code="otp_already_used")
        
        # 3. Verify Stored OTP Code
        otp_store_key = f"otp_code:{otp_id}"
        stored_otp = self.r.get(otp_store_key)
        
        if not stored_otp:
            # If OTP is not in Redis, it might have expired or never existed
            raise AppException(message="OTP has expired or is invalid.", error_code="otp_expired")
            
        if otp != stored_otp:
            return False, False, {}

        # 4. On success: Mark as spent and cleanup OTP code
        self.r.delete(otp_store_key)
        
        # We use the 'exp' from payload to determine TTL for spent status
        exp_dt = datetime.fromisoformat(payload["exp"])
        ttl = int((exp_dt - datetime.utcnow()).total_seconds())
        if ttl > 0:
            self.r.setex(spent_key, ttl, "1")

        # 5. Validation Success - Clean up
        self.r.delete(f"otp_limit:{phone}") # Reset limit on successful login

        # 4. Standard User/Company Checks
        company = db.query(models.Company).filter(models.Company.user_phone_no == phone).first()
        is_new_user = company is None

        member = db.query(models.Member).filter(models.Member.phone == phone).first()
        user_uid = member.uid if member else uuid.uuid4().hex[:10]
        
        response_data = {
            "userUid": user_uid,
            "phoneNo": phone,
            "isNewUser": is_new_user,
            **self.generate_tokens(user_uid, phone)
        }
        
        return True, is_new_user, response_data

    def generate_tokens(self, user_uid: str, phone: str) -> dict:
        from services.token_service import token_service
        return token_service.generate_tokens(user_uid, phone)

    def refresh_token_logic(self, authorization: str, x_refresh_token: str) -> dict:
        from services.token_service import token_service
        
        # 1. Extract access token from Authorization header
        try:
            if not authorization.startswith("Bearer "):
                 raise AppException(message="Invalid authorization header.", error_code="invalid_auth_header")
            prev_access_token = authorization.split(" ")[1]
        except Exception:
            raise AppException(message="Invalid authorization header.", error_code="invalid_auth_header")

        # 2. Decode access token (skip expiry check to allow refresh)
        access_payload = token_service.decode_token(prev_access_token, expected_type="access", verify_exp=False)
        
        # 3. Decode and validate the refresh token (must be valid and not expired)
        refresh_payload = token_service.decode_token(x_refresh_token, expected_type="refresh")
        
        # 4. Verify identity continuity
        if access_payload.get("sub") != refresh_payload.get("sub"):
             raise AppException(message="Token mismatch.", error_code="token_mismatch")

        user_uid = refresh_payload.get("sub")
        phone = refresh_payload.get("phone")
        
        # 5. Issue fresh tokens
        return self.generate_tokens(user_uid, phone)

auth_service = AuthService()
