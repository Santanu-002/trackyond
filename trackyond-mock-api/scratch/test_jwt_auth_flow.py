import requests
import json
import uuid

BASE_URL = "http://localhost:8000/api/v1"
ADMIN_AUTH_BASE = f"{BASE_URL}/admin/auth"
AUTH_BASE = f"{BASE_URL}/auth"

def test_full_jwt_flow():
    phone = "+919999999999"
    device_id = str(uuid.uuid4())
    headers = {
        "device-id": device_id, 
        "device-os": "android",
        "device-os-version": "14",
        "app-version": "1.0",
        "device-name": "Test Device",
        "browser": "N/A",
        "browser-version": "N/A"
    }
    
    print("\n--- 1. Testing Send OTP ---")
    resp = requests.post(f"{ADMIN_AUTH_BASE}/send-otp", json={"phone": phone, "role": "owner"}, headers=headers)
    print(f"Status: {resp.status_code}")
    print(f"Response: {resp.json()}")
    
    if resp.status_code != 200:
        print("FAILED to send OTP")
        return
        
    data = resp.json()["data"]
    otp_id = data["otpId"]
    
    import redis
    r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
    stored_otp = r.get(f"otp_code:{otp_id}")
    
    print("\n--- 2. Testing Verify OTP ---")
    resp = requests.post(
        f"{ADMIN_AUTH_BASE}/verify-otp", 
        json={"phone": phone, "otp": stored_otp, "otpId": otp_id}, 
        headers=headers
    )
    print(f"Status: {resp.status_code}")
    print(f"Response: {resp.json()}")
    
    if resp.status_code != 200 or not resp.json().get("success"):
        print("FAILED to verify OTP")
        return
        
    tokens = resp.json()["data"]
    access_token = tokens["accessToken"]
    refresh_token = tokens["refreshToken"]
    
    print("\n--- 3. Testing Refresh Token ---")
    refresh_headers = headers.copy()
    refresh_headers.update({
        "Authorization": f"Bearer {access_token}",
        "x-refresh-token": refresh_token
    })
    
    resp = requests.post(f"{ADMIN_AUTH_BASE}/refresh", json=None, headers=refresh_headers)
    print(f"Status: {resp.status_code}")
    print(f"Response: {resp.json()}")
    
    if resp.status_code == 200:
        print("\nSUCCESS: Entire HS256 JWT Send -> Verify -> Refresh flow completed perfectly.")
    else:
        print("\nERROR: Endpoint returned a non-200 status code during refresh token request.")


if __name__ == "__main__":
    test_full_jwt_flow()
