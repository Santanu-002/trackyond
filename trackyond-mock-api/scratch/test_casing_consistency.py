import requests
import json
import re

BASE_URL = "http://localhost:8000/api"
PHONE = "+91" + "".join([str((i+9)%10) for i in range(10)]) # New phone to avoid rate limit

HEADERS = {
    "device-id": "test-device-unique-999",
    "device-os": "android",
    "device-os-version": "14",
    "device-name": "Pixel 7",
    "browser": "Chrome",
    "browser-version": "120.0.0",
    "app-version": "1.0.0"
}

def is_camel_case(s):
    if s == "inProgress": return True # exception for double caps if needed, but regex should handle it
    return bool(re.match(r'^[a-z]+([A-Z][a-z0-9]*)*$', s))

def check_keys(data, path="root"):
    if isinstance(data, dict):
        for k, v in data.items():
            if not is_camel_case(k):
                print(f"FAILED: Key '{k}' at {path} is not camelCase")
            check_keys(v, f"{path}.{k}")
    elif isinstance(data, list):
        for i, item in enumerate(data):
            check_keys(item, f"{path}[{i}]")

def test_admin_flow():
    print("\n--- Testing Admin Flow ---")
    # 1. Send OTP
    resp = requests.post(f"{BASE_URL}/v1/admin/auth/send-otp", json={"phone": PHONE}, headers=HEADERS)
    print(f"Send OTP Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)
    otp_id = data.get("data", {}).get("otpId")

    # 2. Verify OTP
    resp = requests.post(f"{BASE_URL}/v1/admin/auth/verify-otp", 
                         json={"phone": PHONE, "otpId": otp_id, "otp": "000000"}, 
                         headers=HEADERS)
    print(f"Verify OTP Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)

    # 3. Create Company
    resp = requests.post(f"{BASE_URL}/v1/admin/company", 
                         json={
                             "companyName": "Test Corp",
                             "userPhoneNo": PHONE,
                             "userFullName": "Test User",
                             "teamSize": 10
                         }, 
                         headers=HEADERS)
    print(f"Create Company Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)

    # 4. Get Dashboard
    resp = requests.get(f"{BASE_URL}/v1/admin/dashboard", headers=HEADERS)
    print(f"Get Dashboard Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)

def test_employee_flow():
    print("\n--- Testing Employee Flow ---")
    # 1. Get Profile
    resp = requests.get(f"{BASE_URL}/v1/employee/profile", params={"member_uid": "user_12345"}, headers=HEADERS)
    print(f"Get Profile Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)

    # 2. Get Jobs
    resp = requests.get(f"{BASE_URL}/v1/employee/jobs", params={"worker_uid": "user_12345"}, headers=HEADERS)
    print(f"Get Jobs Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)

def test_missing_headers():
    print("\n--- Testing Middleware Error Response ---")
    resp = requests.post(f"{BASE_URL}/v1/admin/auth/send-otp", json={"phone": PHONE})
    print(f"Status: {resp.status_code}")
    data = resp.json()
    check_keys(data)

if __name__ == "__main__":
    try:
        test_admin_flow()
        test_employee_flow()
        test_missing_headers()
        print("\nCasing verification complete.")
    except Exception as e:
        print(f"Error during testing: {e}")
