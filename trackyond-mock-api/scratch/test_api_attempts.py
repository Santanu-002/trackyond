import sys
import os
from fastapi.testclient import TestClient

# Add current directory to path
sys.path.append(os.getcwd())

from main import app

client = TestClient(app)

def test_attempts_decrement():
    phone = "+919876543210"
    headers = {"device-id": "test-device"}
    
    # 1. Clear Redis state for this phone
    import redis
    r = redis.from_url(os.getenv("REDIS_URL", "redis://localhost:6379/0"), decode_responses=True)
    r.delete(f"otp_limit:{phone}")
    
    print(f"--- Testing /api/v1/employee/auth/send-otp for {phone} ---")
    
    for i in range(1, 4):
        response = client.post(
            "/api/v1/employee/auth/send-otp",
            json={"phone": phone},
            headers=headers
        )
        data = response.json()
        remaining = data["data"]["remainingAttempts"]
        print(f"Call {i} -> remainingAttempts: {remaining}")
        
    print(f"\n--- Testing /api/v1/employee/auth/resend-otp for {phone} ---")
    # Wait time might be needed if we want to check delay, but here we just check attempts
    # Since we didn't wait, resend might fail with too_early_resend if we don't handle it
    # But for now let's just see if it increments.
    response = client.post(
        "/api/v1/employee/auth/resend-otp",
        json={"phone": phone},
        headers=headers
    )
    data = response.json()
    if response.status_code == 200:
        print(f"Resend Call 1 -> remainingAttempts: {data['data']['remainingAttempts']}")
    else:
        print(f"Resend Call 1 -> Failed: {data['message']}")

if __name__ == "__main__":
    test_attempts_decrement()
