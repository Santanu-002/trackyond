# Employer (Admin) API — `v1/admin/`

**Base URL:** `https://api.yourapp.com/v1/admin`

All endpoints require:
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
    "otpId": "payload_b64.signature",
    "expiresAt": "2026-04-17T12:00:00.000000",
    "resendableAt": "2026-04-17T11:58:30.000000",
    "remainingAttempts": 4
  } 
}
```

**Response — 429 (Too many requests)**
```json
{
  "success": false,
  "message": "Maximum OTP attempts reached. Please try again later.",
  "data": {
    "errorCode": "rate_limit_exceeded",
    "retryAfter": "2026-04-17T12:29:31.656902"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | OTP sent successfully |
| 400 | Invalid phone format |
| 429 | Too many requests (rate limit / cooldown) |

---

### POST `/auth/resend-otp`

**Request**
```json
{
  "phone": "+919876543210",
  "otpId": "payload_b64.signature"
}
```

**Response — 200**
```json
{ 
  "success": true, 
  "message": "Otp sent successfully", 
  "data": {
    "phone": "+919876543210",
    "otpId": "new_payload_b64.signature",
    "expiresAt": "2026-04-17T12:05:00.000000",
    "resendableAt": "2026-04-17T12:04:00.000000",
    "remainingAttempts": 3
  } 
}
```

**Response — 400 (Too Early Resend)**
```json
{
  "success": false,
  "message": "Please wait 25s before resending OTP.",
  "data": {
    "errorCode": "too_early_resend"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | OTP resent successfully |
| 400 | Invalid phone, OTP ID, or resending too early |
| 429 | Too many requests (max attempts reached) |

---

### POST `/auth/verify-otp`

**Request**
```json
{
  "phone": "+919876543210",
  "otpId": "payload_b64.signature",
  "otp": "000000"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userUid": "user_1234abcd",
    "phoneNo": "+919876543210",
    "isNewUser": false,
    "accessToken": "mock_access_...",
    "refreshToken": "mock_refresh_...",
    "accessTokenExpireAt": "2026-04-17T13:00:00.000000",
    "refreshTokenExpireAt": "2026-04-17T20:00:00.000000",
    "tokenIssuedAt": "2026-04-17T12:00:00.000000"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Verified, tokens returned |
| 400 | Invalid/Expired OTP or already used |
| 401 | Invalid OTP PIN |

---

## Company

---

### POST `/company`

Create employer company profile. Called when `isNewUser: true`.

**Request**
```json
{
  "companyName": "Dharma AC Services",
  "userPhoneNo": "+919876543210",
  "userFullName": "Ravi Kumar",
  "teamSize": 5
}
```

**Response — 201**
```json
{
  "success": true,
  "message": "Company profile created successfully",
  "data": {
    "companyId": "comp001",
    "companyName": "Dharma AC Services",
    "createdAt": "2026-04-13T08:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 201 | Company created |
| 400 | Missing required fields |
| 401 | Unauthorized |
| 409 | Company already exists |

---

## Members

---

### GET `/members`

Fetch list of all team members.

**Response — 200**
```json
{
  "success": true,
  "message": "Members fetched successfully",
  "data": {
    "members": [
      {
        "uid": "user1234",
        "name": "Ravi Kumar",
        "phone": "+919876543210",
        "designation": "Manager",
        "image": "ravi.jpg",
        "gender": "male"
      },
      {
        "uid": "user4567",
        "name": "Suraj Kumar",
        "phone": "+919876056789",
        "designation": "worker",
        "image": "image.jpg",
        "gender": "male"
      }
    ]
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Members returned |
| 401 | Unauthorized |

---

### POST `/members`

Add a new team member. Requires `multipart/form-data`.

**Request (Form Data)**
| Field | Type | Description |
|-------|------|-------------|
| memberName | string | Name of the member |
| userPhoneNo | string | Phone number of the member |
| designation | string | Role (e.g., worker, supervisor) |
| gender | string | male, female, or other |
| companyUid | string | The UID of the company |
| memberImage | file | (Optional) Profile image file |

**Response — 201**
```json
{
  "success": true,
  "message": "Member added successfully",
  "data": {
    "uid": "user4567",
    "memberName": "Suraj Kumar",
    "designation": "worker",
    "image": "uploads/comp_123/user_456/profile_abc.jpg",
    "createdAt": "2026-04-13T08:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 201 | Member created |
| 400 | Missing required fields |
| 401 | Unauthorized |
| 409 | Member already exists |

---

## Dashboard

---

### GET `/dashboard`

Fetch team member statuses, job counts, recent jobs, and notifications.

**Response — 200**
```json
{
  "success": true,
  "message": "Dashboard data fetched successfully",
  "data": {
    "teamMembersStatus": [
      {
        "uid": "user4567",
        "name": "Suraj Kumar",
        "status": "on_job"
      }
    ],
    "jobCounts": {
      "pending": 3,
      "inProgress": 2,
      "completed": 10
    },
    "recentJobs": [
      {
        "jobId": "job001",
        "jobTitle": "AC not cooling",
        "status": "inProgress",
        "assignedTo": "Suraj Kumar"
      }
    ]
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Dashboard data returned |
| 401 | Unauthorized |

---

## Jobs

---

### GET `/jobs`

Fetch all jobs with advanced filtering and pagination.

**Query Params**
| Param | Type | Description |
|-------|------|-------------|
| status | string | Filter by: `pending`, `assigned`, `in_progress`, `completed` |
| workerUid | string | Filter jobs assigned to a specific worker |
| customerPhone | string | Filter jobs by customer phone number |
| limit | integer | Number of records per page (default: 10) |
| page | integer | Page number for pagination |
| sortBy | string | Field to sort by: `createdAt`, `status`, `workerUid` (default: `createdAt`) |
| order | string | Sort order: `asc`, `desc` (default: `desc`) |

**Response — 200**
```json
{
  "success": true,
  "message": "Jobs fetched successfully",
  "data": {
    "jobs": [
      {
        "jobId": "job001",
        "jobTitle": "AC not cooling",
        "status": "assigned",
        "workerName": "Suraj Kumar",
        "workerUid": "user4567",
        "customerName": "Robert William",
        "customerPhone": "+917878787878",
        "createdAt": "2026-04-13T08:00:00.000Z"
      }
    ],
    "pagination": {
      "total": 120,
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

### POST `/jobs`

Create a new job and assign to a worker.

**Request**
```json
{
  "jobTitle": "AC not cooling",
  "problemDescription": "AC is turning on but it's not cooling the air",
  "customerName": "Robert William",
  "customerPhone": "+917878787878",
  "customerAddress": "Room no 204, 2nd Floor, Swasti Apartment, 23/7, Near HSBC Bank, Kolkata, 700001",
  "workerUid": "user4567",
  "requirePhotoWhenWorkStart": true,
  "requirePhotoOnComplete": true,
  "captureLocation": true
}
```

**Response — 201**
```json
{
  "success": true,
  "message": "Job created and assigned successfully",
  "data": {
    "jobId": "job001",
    "jobTitle": "AC not cooling",
    "status": "assigned",
    "assignedTo": "user4567",
    "createdAt": "2026-04-13T08:00:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 201 | Job created |
| 400 | Missing required fields |
| 401 | Unauthorized |
| 404 | Worker not found |

---

### POST `/jobs/:job_id/notify`

Notify assigned member about job.

**Request**
```json
{ "workerUid": "user4567" }
```

**Response — 200**
```json
{
  "success": true,
  "message": "Member notified successfully",
  "data": {
    "notifiedAt": "2026-04-13T08:01:00.000Z"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Notification sent |
| 401 | Unauthorized |
| 404 | Job or member not found |

---

## Activity

---

### GET `/activity/summary`

Today's summary metrics.

**Query Params**
| Param | Type | Description |
|-------|------|-------------|
| date | string (ISO) | Filter by specific date |

**Response — 200**
```json
{
  "success": true,
  "message": "Activity summary fetched successfully",
  "data": {
    "totalJobs": 5,
    "completed": 3,
    "inProgress": 2,
    "lastActivityAt": "2026-04-14T10:15:00.000Z",
    "totalFieldWorkTime": "5h 30m",
    "averageJobTime": "45m"
  }
}
```

| Code | Meaning |
|------|---------|
| 200 | Activity returned |
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
        "notificationId": "notif002",
        "message": "Job job001 marked as complete",
        "createdAt": "2026-04-13T09:30:00.000Z",
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

### Company
```json
{
  "companyId": "string",
  "companyName": "string",
  "userPhoneNo": "string (E.164)",
  "userFullName": "string",
  "teamSize": "integer"
}
```

### Member
```json
{
  "uid": "string",
  "name": "string",
  "phone": "string (E.164)",
  "designation": "string",
  "gender": "string (male | female | other)",
  "image": "string (filename or URL)"
}
```

### Job
```json
{
  "jobId": "string",
  "jobTitle": "string",
  "problemDescription": "string",
  "customerName": "string",
  "customerPhone": "string (E.164)",
  "customerAddress": "string",
  "workerUid": "string",
  "status": "string (pending | assigned | inProgress | completed)",
  "requirePhotoWhenWorkStart": "boolean",
  "requirePhotoOnComplete": "boolean",
  "captureLocation": "boolean",
  "createdAt": "string (ISO 8601)"
}
```

### Auth Token
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "accessTokenExpireAt": "string (ISO 8601)",
  "refreshTokenExpireAt": "string (ISO 8601)",
  "tokenIssuedAt": "string (ISO 8601)"
}
```

### Notification
```json
{
  "notificationId": "string",
  "message": "string",
  "createdAt": "string (ISO 8601)",
  "read": "boolean"
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
    "errorCode": "string",
    "details": {},
    "retryAfter": "string (ISO 8601)" 
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
| POST | `/company` | Create company profile |
| GET | `/members` | List all members |
| POST | `/members` | Add new member |
| GET | `/dashboard` | Dashboard stats |
| GET | `/jobs` | List jobs with filters |
| POST | `/jobs` | Create new job |
| POST | `/jobs/:job_id/notify` | Notify member of job |
| GET | `/activity/summary` | Activity summary metrics |
| GET | `/notifications` | Get notifications |
