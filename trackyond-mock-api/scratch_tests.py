import requests
import json
import time

BASE_URL = "http://localhost:8000/api/v1"
PHONE_ADMIN = "+916666666666" # Owner from DB
PHONE_WORKER = "+913333333333" # Worker from DB
OTP = "000000"
DEVICE_ID = "test-device-123"

HEADERS = {
    "device-id": DEVICE_ID,
    "device-os": "android",
    "device-os-version": "13",
    "device-name": "Pixel 7",
    "browser": "Chrome",
    "browser-version": "120.0.0",
    "app-version": "1.0.0"
}

def login(phone, role="admin"):
    print(f"\n--- Logging in as {role} ({phone}) ---")
    # 1. Send OTP
    prefix = "admin" if role == "admin" else "employee"
    resp = requests.post(f"{BASE_URL}/{prefix}/auth/send-otp", json={"phone": phone}, headers=HEADERS)
    print(f"Send OTP: {resp.status_code}")
    if resp.status_code != 200:
        print(resp.text)
        return None
    
    otp_id = resp.json().get("data", {}).get("otpId")
    
    # 2. Verify OTP
    verify_data = {
        "phone": phone,
        "otpId": otp_id,
        "otp": OTP
    }
    resp = requests.post(f"{BASE_URL}/{prefix}/auth/verify-otp", json=verify_data, headers=HEADERS)
    print(f"Verify OTP: {resp.status_code}")
    if resp.status_code != 200:
        print(resp.text)
        return None
    
    return resp.json().get("data")

def test_dashboard(auth_data):
    if not auth_data: return
    token = auth_data.get("accessToken")
    headers = {**HEADERS, "Authorization": f"Bearer {token}"}
    
    print("\n--- Testing Admin Dashboard ---")
    resp = requests.get(f"{BASE_URL}/admin/dashboard", headers=headers)
    print(f"Admin Dashboard: {resp.status_code}")
    if resp.status_code == 200:
        data = resp.json().get("data", {})
        team_status = data.get("teamMembersStatus", [])
        if team_status:
            first_member = team_status[0]
            attn = first_member.get("todayAttendance")
            if attn:
                print("  Attendance fields check:")
                for field in ["accountUid", "userUid", "companyUid", "status", "startAt"]:
                    print(f"    - {field}: {'PRESENT' if field in attn else 'MISSING'}")
            else:
                print("  No attendance data found for first member.")
        else:
            print("  No team members found.")

if __name__ == "__main__":
    admin_auth = login(PHONE_ADMIN, "admin")
    test_dashboard(admin_auth)
