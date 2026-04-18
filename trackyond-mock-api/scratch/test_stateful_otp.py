import sys
import os
from datetime import datetime
import json

# Add project root to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from services.auth_service import auth_service
from core.database.redis_client import get_redis
from db.database import SessionLocal
import os

# Override REDIS_URL and DATABASE_URL for host access if needed
if os.getenv("APP_ENV") != "production":
    os.environ.setdefault("REDIS_URL", "redis://localhost:6379/0")
    os.environ.setdefault("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/trackyond_db")

def test_flow():
    phone = "+919999999999"
    device_id = "test_device_123"
    db = SessionLocal()
    
    try:
        print(f"--- 1. Sending OTP for {phone} ---")
        # Clear any existing state for clean test
        r = get_redis()
        r.delete(f"otp_limit:{phone}")
        
        resp = auth_service.send_otp_logic(phone, device_id)
        otp_id = resp["otpId"]
        print(f"Received otpId: {otp_id}")
        
        # 2. Extract OTP from Redis (simulating log check)
        otp_store_key = f"otp_code:{otp_id}"
        stored_otp = r.get(otp_store_key)
        if not stored_otp:
            print("FAILED: OTP not found in Redis!")
            return
        
        otp_code = stored_otp  # Already decoded via decode_responses=True
        print(f"Found OTP in Redis: {otp_code}")
        
        # 3. Verify with WRONG OTP
        print("\n--- 2. Verifying with WRONG OTP ---")
        try:
            success, is_new, data = auth_service.verify_otp_logic(db, phone, otp_id, "111111", device_id)
            print(f"Verification Success (expect False): {success}")
        except Exception as e:
            print(f"Verification failed as expected: {str(e)}")
        
        # 4. Verify with CORRECT OTP
        print("\n--- 3. Verifying with CORRECT OTP ---")
        success, is_new, data = auth_service.verify_otp_logic(db, phone, otp_id, otp_code, device_id)
        print(f"Verification Success (expect True): {success}")
        if success:
            print(f"Received access token: {data.get('accessToken')[:20]}...")

        # 5. Verify REPLAY (should fail)
        print("\n--- 4. Verifying REPLAY (same OTP ID) ---")
        try:
            success, is_new, data = auth_service.verify_otp_logic(db, phone, otp_id, otp_code, device_id)
            print(f"Replay Success (expect failure): {success}")
        except Exception as e:
            print(f"Replay failed as expected: {str(e)}")

    finally:
        db.close()

if __name__ == "__main__":
    test_flow()
