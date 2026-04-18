import httpx
import json

def test_validation_error():
    url = "http://127.0.0.1:8000/api/v1/admin/auth/send-otp"
    headers = {
        "device-os": "android",
        "device-os-version": "14",
        "device-id": "test-device-id",
        "device-name": "Pixel 7",
        "browser": "chrome",
        "browser-version": "120",
        "app-version": "1.0.0"
    }
    payload = {
        "phone": "1111111111"  # Invalid format (should be +91...)
    }
    
    response = httpx.post(url, json=payload, headers=headers)
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")

if __name__ == "__main__":
    test_validation_error()
