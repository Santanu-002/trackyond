import sys
import os
import json
from datetime import datetime

# Add current directory to path
sys.path.append(os.getcwd())

from services.auth_service import auth_service

def reproduce_bug():
    phone = "+919876543210"
    device_id = "test-device"
    
    print(f"--- Reproducing Attempts Bug for {phone} ---")
    
    # 1. Clear existing limit to start fresh
    auth_service.r.delete(f"otp_limit:{phone}")
    
    for i in range(1, 7):
        print(f"\nCall {i}: send_otp_logic(is_resend=False)")
        try:
            res = auth_service.send_otp_logic(phone, device_id, is_resend=False)
            print(f"Response: remainingAttempts={res['remainingAttempts']}, otpId={res['otpId'][:20]}...")
            
            # Check Redis state
            state_raw = auth_service.r.get(f"otp_limit:{phone}")
            print(f"Redis State: {state_raw.decode() if state_raw else 'None'}")
            
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    reproduce_bug()
