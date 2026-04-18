import sys
import os
import json
from datetime import datetime
from fastapi.testclient import TestClient

# Mock DATABASE_URL to avoid connection errors on startup if DB is down
os.environ["DATABASE_URL"] = "postgresql://postgres:postgres@localhost:5432/trackyond_db"
os.environ["REDIS_URL"] = "redis://localhost:6379/0"

# Add current directory to path
sys.path.append(os.getcwd())

from main import app

client = TestClient(app)

def test_rate_limit_cooldown():
    phone = "+910000000001"
    headers = {
        "device-os": "Android",
        "device-os-version": "14",
        "device-id": "test-device-cooldown",
        "device-name": "Pixel 7",
        "browser": "Chrome",
        "browser-version": "120.0.0",
        "app-version": "1.0.0"
    }
    
    # 1. Clear Redis state for this phone
    import redis
    r = redis.from_url(os.environ["REDIS_URL"], decode_responses=True)
    r.delete(f"otp_limit:{phone}")
    
    print(f"--- Testing Rate Limit Cooldown for {phone} ---")
    
    # Send 5 OTPs (max attempts)
    for i in range(1, 6):
        response = client.post(
            "/api/v1/employee/auth/send-otp",
            json={"phone": phone},
            headers=headers
        )
        data = response.json()
        if response.status_code == 200:
            remaining = data["data"]["remainingAttempts"]
            print(f"Attempt {i} -> Success. remainingAttempts: {remaining}")
        else:
            print(f"Attempt {i} -> Failed: {data.get('message')} - {data.get('data')}")

    # 6th Attempt should fail with rate_limit_exceeded and retryAfter
    print("\n--- Testing 6th Attempt (Should be blocked) ---")
    response = client.post(
        "/api/v1/employee/auth/send-otp",
        json={"phone": phone},
        headers=headers
    )
    data = response.json()
    print(f"Status Code: {response.status_code}")
    print(f"Response: {json.dumps(data, indent=2)}")
    
    if response.status_code == 400 and data.get("data", {}).get("error_code") == "rate_limit_exceeded":
        retry_after = data.get("data", {}).get("retryAfter")
        if retry_after:
            print(f"SUCCESS: Found retryAfter in response: {retry_after}")
        else:
            print("FAILURE: retryAfter NOT found in response.")
    else:
        print("FAILURE: Expected rate_limit_exceeded error.")

if __name__ == "__main__":
    test_rate_limit_cooldown()
