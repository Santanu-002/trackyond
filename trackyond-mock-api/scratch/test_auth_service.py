import sys
import os
from datetime import datetime

# Add current directory to path
sys.path.append(os.getcwd())

from services.auth_service import auth_service

def test_stateless_otp():
    phone = "+919876543210"
    device_id = "test-device"
    
    print("--- Testing Token Generation ---")
    res = auth_service.send_otp_logic(phone, device_id)
    otp_id = res["otpId"]
    print(f"Generated Token: {otp_id}")
    print(f"Expires At: {res['expiresAt']}")
    
    if "." not in otp_id:
        print("ERROR: otpId is not a signed token (missing period)")
        return
        
    print("\n--- Testing Token Verification ---")
    # We mock the database session as it's not needed for the core token check
    try:
        success, is_new, data = auth_service.verify_otp_logic(None, phone, otp_id, "000000", device_id)
        print(f"Verification Success: {success}")
        print(f"Is New User: {is_new}")
    except Exception as e:
        print(f"Verification Failed with error: {e}")

if __name__ == "__main__":
     # Mock get_redis if needed, but it should hit the real redis if configured
     test_stateless_otp()
