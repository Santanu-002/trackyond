# Employee API — `v1/`

**Base URL:** `https://api.yourapp.com/v1/employee`

All protected endpoints require:
```
Authorization: Bearer <access_token>
```

---

## Auth

---

### POST `/auth/send-otp`

**Request**
```json
{ "phone": "+919876543210" }
```

**Response — 200**
```json
{ 
  "success": true, 
  "message": "Otp sent successfully", 
  "data": {
    "phone": "+919876543210",
    "otpId": "xjhs34cv",
    "otp_expires_in": 120,
    "remaining_attempts": 3,
  } 
}
```

**Response — 429 (Too many requests)**
```json
{
  "success": false,
  "message": "Too many requests. Please try again after 24 hours or contact administrative.",
  "data": {
    "error_code": "rate_limit_exceeded",
    "retry_after": 86400 // 24 hours
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | OTP sent successfully |
| 400 | Invalid phone format |
| 429 | Too many requests (rate limit) |

---

### POST `/auth/resend-otp`

**Request**
```json
{
  "phone": "+919876543210",
  "otpId": "xjhs34cv"
}
```

**Response — 200**
```json
{ 
  "success": true, 
  "message": "Otp resent successfully", 
  "data": {
    "phone": "+919876543210",
    "otpId": "xjhs34cv",
    "otp_expires_in": 120,
    "remaining_attempts": 2
  } 
}
```

**Response — 429 (Too many requests)**
```json
{
  "success": false,
  "message": "Too many requests. Please try again after 24 hours or contact administrative.",
  "data": {
    "error_code": "rate_limit_exceeded",
    "retry_after": 86400 // 24 hours
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | OTP resent successfully |
| 400 | Invalid phone or OTP ID |
| 429 | Too many requests |

---

### POST `/auth/verify-otp`

**Request**
```json
{
  "phone": "+919876543210",
  "otpId": "xjhs34cv",
  "otp": "12345"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "member_uid": "user4567",
    "member_name": "Suraj Kumar",
    "phone_no": "+919787878878",
    "designation": "worker",
    "gender": "male",
    "image": "image.jpg",
    "access_token": "xyz123",
    "refresh_token": "refresh123",
    "access_token_expire_at": "2026-04-13T06:27:08.925Z",
    "refresh_token_expire_at": "2026-04-13T06:28:08.925Z",
    "token_issued_at": "2026-04-13T06:27:08.925Z"
  }
}
```

**Response — 403 (not a company member)**
```json
{
  "success": false,
  "message": "User is not a member of any company",
  "data": {
    "error": "login_failed",
    "reasons": [
      "Contact administrator to be added as a member"
    ]
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Verified, tokens returned |
| 401 | Invalid OTP |
| 403 | Not a member of any company |
| 404 | Phone not registered |

---

## Profile

---

### GET `/profile`

**Response — 200**
```json
{
  "success": true,
  "message": "Profile fetched successfully",
  "data": {
    "member_uid": "user4567",
    "member_name": "Suraj Kumar",
    "phone_no": "+919787878878",
    "designation": "worker",
    "gender": "male",
    "image": "image.jpg"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Profile returned |
| 401 | Unauthorized |
| 404 | Member not found |

---

## Jobs

---

### GET `/jobs`

Fetch jobs assigned to the member with optional filtering and pagination.

**Query Params**
| Param | Type | Description |
|-------|------|-------------|
| status | string | Filter by status: `pending`, `assigned`, `completed`, `in_progress` |
| limit | integer | Number of records per page (default: 10) |
| page | integer | Page number for pagination |
| sort_by | string | Field to sort by: `assigned_at`, `job_id`, `job_title` (default: `assigned_at`) |
| order | string | Sort order: `asc`, `desc` (default: `desc`) |
| assigned_after | string | Fetch jobs assigned after this ISO 8601 date |
| assigned_before | string | Fetch jobs assigned before this ISO 8601 date |

**Response — 200**
```json
{
  "success": true,
  "message": "Jobs fetched successfully",
  "data": {
    "jobs": [
      {
        "job_id": "job001",
        "job_title": "AC not cooling",
        "status": "assigned",
        "customer_name": "Robert William",
        "customer_phone": "+917878787878",
        "customer_address": "Room no 204, 2nd Floor, Swasti Apartment, 23/7, Near HSBC Bank, Kolkata, 700001",
        "require_photo_on_start": true,
        "require_photo_on_complete": true,
        "capture_location": true,
        "assigned_at": "2026-04-10T08:00:00.000Z"
      }
    ],
    "pagination": {
      "total": 50,
      "page": 1,
      "limit": 10
    }
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Jobs returned |
| 401 | Unauthorized |

---

### PATCH `/jobs/:job_id/status`

Update job status.

**Request**
```json
{
  "status": "reached",
  "latitude": 22.5726,
  "longitude": 88.3639,
  "photo": "<base64_or_url>"
}
```

**Allowed status values:** `reached` · `start_work` · `complete`

**Response — 200**
```json
{
  "success": true,
  "message": "Status updated successfully",
  "data": {
    "job_id": "job001",
    "status": "reached",
    "updated_at": "2026-04-13T09:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Status updated |
| 400 | Invalid status or missing photo |
| 401 | Unauthorized |
| 404 | Job not found |

---

### POST `/jobs/:job_id/progress`

Send custom message and photos as progress update.

**Request**
```json
{
  "message": "Work is 50% done",
  "photo": "<base64_or_url>",
  "latitude": 22.5726,
  "longitude": 88.3639
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Progress saved successfully",
  "data": {
    "saved_at": "2026-04-13T10:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Progress saved |
| 400 | Missing required fields |
| 401 | Unauthorized |

---

## Attendance

---

### POST `/attendance/start`

Mark start of day with location.

**Request**
```json
{
  "latitude": 22.5726,
  "longitude": 88.3639
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Attendance marked successfully",
  "data": {
    "marked_at": "2026-04-13T08:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Attendance marked |
| 400 | Missing location |
| 401 | Unauthorized |

---

### POST `/attendance/end`

Punch out with location.

**Request**
```json
{
  "latitude": 22.5726,
  "longitude": 88.3639
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Punched out successfully",
  "data": {
    "punched_out_at": "2026-04-13T17:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Punched out |
| 400 | Missing location |
| 401 | Unauthorized |

---

## Notifications

---

### GET `/notifications`

**Response — 200**
```json
{
  "success": true,
  "message": "Notifications fetched successfully",
  "data": {
    "notifications": [
      {
        "notification_id": "notif001",
        "message": "New job assigned to you",
        "created_at": "2026-04-13T07:00:00.000Z",
        "read": false
      }
    ]
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Notifications returned |
| 401 | Unauthorized |

---

## Schemas

### Member
```json
{
  "member_uid": "string",
  "member_name": "string",
  "phone_no": "string (E.164)",
  "designation": "string",
  "gender": "string (male | female | other)",
  "image": "string (filename or URL)"
}
```

### Job
```json
{
  "job_id": "string",
  "job_title": "string",
  "status": "string (pending | assigned | in_progress | completed)",
  "customer_name": "string",
  "customer_phone": "string (E.164)",
  "customer_address": "string",
  "require_photo_on_start": "boolean",
  "require_photo_on_complete": "boolean",
  "capture_location": "boolean",
  "assigned_at": "string (ISO 8601)"
}
```

### Auth Token
```json
{
  "access_token": "string",
  "refresh_token": "string",
  "access_token_expire_at": "string (ISO 8601)",
  "refresh_token_expire_at": "string (ISO 8601)",
  "token_issued_at": "string (ISO 8601)"
}
```

### Progress Update
```json
{
  "job_id": "string",
  "message": "string",
  "photo": "string (base64 or URL)",
  "latitude": "number",
  "longitude": "number",
  "saved_at": "string (ISO 8601)"
}
```

### Generic Response
```json
{
  "success": "boolean",
  "message": "string",
  "data": "any | null"
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message description",
  "data": {
    "error_code": "string",
    "details": {},
    "retry_after": 86400 // Optional: only for 429 errors (e.g., 24 hours)
  }
}
```

---

## Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/send-otp` | Send OTP |
| POST | `/auth/resend-otp` | Resend OTP |
| POST | `/auth/verify-otp` | Verify OTP, get tokens |
| GET | `/profile` | Get profile |
| GET | `/jobs` | Get jobs with filters and pagination |
| PATCH | `/jobs/:job_id/status` | Update job status |
| POST | `/jobs/:job_id/progress` | Send progress update |
| POST | `/attendance/start` | Mark attendance |
| POST | `/attendance/end` | Punch out |
| GET | `/notifications` | Get notifications |
