# Trackyond Employer (Admin/Owner) API — `/api/v1/admin`

**Base URL:** `http://<host>:<port>/api/v1/admin`  
*(Production default: `https://api.yourapp.com/api/v1/admin`)*

All protected endpoints require:
```http
Authorization: Bearer <access_token>
```

---

## Endpoint Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| **POST** | `/auth/send-otp` | Send OTP to phone | No |
| **POST** | `/auth/resend-otp` | Resend OTP to phone | No |
| **POST** | `/auth/verify-otp` | Verify OTP and issue tokens | No |
| **POST** | `/auth/refresh` | Refresh access token | Yes (refresh token header) |
| **POST** | `/auth/logout` | Revoke tokens and log out | Yes |
| **POST** | `/company` | Create employer company profile | Yes |
| **GET** | `/company` | Get company profile details | Yes |
| **GET** | `/company/team-status` | Get real-time status of team members | Yes |
| **GET** | `/members` | List all team members | Yes |
| **POST** | `/members` | Add new member (with profile image) | Yes |
| **GET** | `/dashboard` | Get administrative dashboard summary | Yes |
| **GET** | `/attendance` | Get detailed attendance logs with filters | Yes |
| **GET** | `/attendance/export/csv` | Request a CSV export download link | Yes |
| **GET** | `/attendance/export/pdf` | Request a PDF export download link | Yes |
| **GET** | `/jobs` | Get all jobs with filters and search | Yes |
| **POST** | `/jobs` | Create a new job and assign it | Yes |
| **POST** | `/jobs/{job_id}/notify` | Send push notification alert to worker | Yes |
| **GET** | `/profiles/me` | Fetch admin's own profile and company info | Yes |
| **GET** | `/notifications` | Get notifications list with pagination | Yes |
| **POST** | `/notifications/status` | Bulk update status (read/seen) of notifications | Yes |
| **DELETE**| `/notifications` | Bulk delete notifications | Yes |
| **POST** | `/notifications/fcm-token` | Register/update Firebase FCM token for device | Yes |

---

## 1. Auth

### POST `/auth/send-otp`
Initiates mobile number verification.

**Headers**
- `device-id`: `<string>` (Required)

**Request Body (JSON)**
```json
{
  "phone": "+919876543210"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Otp sent successfully",
  "data": {
    "phone": "+919876543210",
    "otpId": "payload_b64.signature",
    "expiresAt": "2026-06-30T12:00:00.000000Z",
    "resendableAt": "2026-06-30T11:58:30.000000Z",
    "remainingAttempts": 4
  }
}
```

---

### POST `/auth/resend-otp`
Requests another OTP token.

**Headers**
- `device-id`: `<string>` (Required)

**Request Body (JSON)**
```json
{
  "phone": "+919876543210"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Otp resent successfully",
  "data": {
    "phone": "+919876543210",
    "otpId": "new_payload_b64.signature",
    "expiresAt": "2026-06-30T12:05:00.000000Z",
    "resendableAt": "2026-06-30T12:04:00.000000Z",
    "remainingAttempts": 3
  }
}
```

---

### POST `/auth/verify-otp`
Verifies OTP code and signs in the user.

**Headers**
- `device-id`: `<string>` (Required)
- `device-os`: `<string>` (Required)
- `device-os-version`: `<string>` (Required)
- `device-name`: `<string>` (Required)
- `browser`: `<string>` (Required)
- `browser-version`: `<string>` (Required)
- `app-version`: `<string>` (Required)

**Request Body (JSON)**
```json
{
  "phone": "+919876543210",
  "otpId": "payload_b64.signature",
  "otp": "000000"
}
```

**Response — 200 (Success)**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userUid": "user_1234abcd",
    "phoneNo": "+919876543210",
    "isNewUser": false,
    "accessToken": "mock_access_token_value",
    "refreshToken": "mock_refresh_token_value",
    "accessTokenExpireAt": "2026-06-30T13:00:00.000000Z",
    "refreshTokenExpireAt": "2026-06-30T20:00:00.000000Z",
    "tokenIssuedAt": "2026-06-30T12:00:00.000000Z"
  }
}
```

---

### POST `/auth/refresh`
Refreshes credentials with an existing refresh token.

**Headers**
- `Authorization`: `Bearer <access_token>` (Required)
- `x-refresh-token`: `<refresh_token>` (Required)
- `device-id`: `<string>` (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "accessToken": "new_mock_access_token_value",
    "refreshToken": "new_mock_refresh_token_value",
    "accessTokenExpireAt": "2026-06-30T14:00:00.000000Z",
    "refreshTokenExpireAt": "2026-06-30T21:00:00.000000Z",
    "tokenIssuedAt": "2026-06-30T13:00:00.000000Z"
  }
}
```

---

### POST `/auth/logout`
Logs out and deactivates Firebase FCM token for the device.

**Headers**
- `device-id`: `<string>` (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "Logged out successfully",
  "data": null
}
```

---

## 2. Company

### POST `/company`
Creates a new company profile. Called when a user verifies their phone and `isNewUser` is `true`.

**Request Body (JSON)**
```json
{
  "companyName": "Dharma AC Services",
  "ownerUid": "user_1234abcd",
  "ownerName": "Ravi Kumar",
  "ownerPhone": "+919876543210",
  "teamSize": 5
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Company profile created successfully",
  "data": {
    "ownerProfile": {
      "uid": "profile_abc123",
      "userUid": "user_1234abcd",
      "name": "Ravi Kumar",
      "phone": "+919876543210",
      "designation": "Owner",
      "image": null,
      "gender": null
    },
    "company": {
      "companyId": "comp_a8e2f6d1",
      "companyName": "Dharma AC Services",
      "teamSize": 5,
      "ownerUid": "user_1234abcd",
      "createdAt": "2026-06-30T12:00:00.000000Z"
    }
  }
}
```

---

### GET `/company`
Retrieves company profile information.

**Response — 200**
```json
{
  "success": true,
  "message": "Company fetched successfully",
  "data": {
    "companyId": "comp_a8e2f6d1",
    "companyName": "Dharma AC Services",
    "teamSize": 5,
    "ownerUid": "user_1234abcd"
  }
}
```

---

### GET `/company/team-status`
Returns real-time status and today's attendance logs for team members.

**Query Parameters**
- `statusFilter`: `all` \| `working` \| `notStarted` \| `ended` (Optional, Default: `all`)
- `order`: `asc` \| `desc` (Optional, Default: `desc`)
- `limit`: `<string>` (Optional, Default: `50`)

**Response — 200**
```json
{
  "success": true,
  "message": "Team status fetched successfully",
  "data": {
    "members": [
      {
        "profile": {
          "uid": "profile_worker01",
          "userUid": "user_w01",
          "name": "Suraj Kumar",
          "phone": "+919876056789",
          "designation": "Technician",
          "image": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
          "gender": "male",
          "companyUid": "comp_a8e2f6d1"
        },
        "todayAttendance": {
          "id": 12,
          "profileUid": "profile_worker01",
          "userUid": "user_w01",
          "companyUid": "comp_a8e2f6d1",
          "status": "working",
          "startAt": "2026-06-30T08:00:00.000000Z",
          "endAt": null,
          "startLatitude": 22.5726,
          "startLongitude": 88.3639,
          "endLatitude": null,
          "endLongitude": null,
          "workHours": null,
          "startAddress": "123 Main St, Kolkata",
          "endAddress": null
        }
      }
    ],
    "stats": {
      "total": 5,
      "working": 1,
      "notStarted": 4,
      "ended": 0
    },
    "options": {
      "statusFilter": "all",
      "order": "desc"
    },
    "pagination": {
      "limit": 50,
      "totalItems": 1
    }
  }
}
```

---

## 3. Members

### GET `/members`
Lists all members registered under the company.

**Response — 200**
```json
{
  "success": true,
  "message": "Members fetched successfully",
  "data": [
    {
      "uid": "profile_abc123",
      "userUid": "user_1234abcd",
      "name": "Ravi Kumar",
      "phone": "+919876543210",
      "designation": "Owner",
      "image": null,
      "gender": null,
      "companyUid": "comp_a8e2f6d1"
    },
    {
      "uid": "profile_worker01",
      "userUid": "user_w01",
      "name": "Suraj Kumar",
      "phone": "+919876056789",
      "designation": "Technician",
      "image": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
      "gender": "male",
      "companyUid": "comp_a8e2f6d1"
    }
  ]
}
```

---

### POST `/members`
Adds a member profile. Requires `multipart/form-data`.

**Request Form Fields**
- `memberName`: `Suraj Kumar` (Required)
- `userPhoneNo`: `+919876056789` (Required, E.164 pattern: `^\+91\d{10}$`)
- `designation`: `Technician` (Required)
- `gender`: `male` \| `female` \| `other` (Optional)
- `companyUid`: `comp_a8e2f6d1` (Required)
- `memberImage`: File (Optional)

**Response — 200**
```json
{
  "success": true,
  "message": "Member added successfully",
  "data": {
    "uid": "profile_worker01",
    "userUid": "user_w01",
    "name": "Suraj Kumar",
    "phone": "+919876056789",
    "designation": "Technician",
    "image": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
    "gender": "male",
    "companyUid": "comp_a8e2f6d1"
  }
}
```

---

## 4. Dashboard

### GET `/dashboard`
Provides metrics, team status summary, recent jobs, and notification counts.

**Response — 200**
```json
{
  "success": true,
  "message": "Dashboard data fetched successfully",
  "data": {
    "teamMembersStatus": [
      {
        "profile": {
          "uid": "profile_worker01",
          "userUid": "user_w01",
          "name": "Suraj Kumar",
          "phone": "+919876056789",
          "designation": "Technician",
          "image": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
          "gender": "male",
          "companyUid": "comp_a8e2f6d1"
        },
        "todayAttendance": {
          "id": 12,
          "profileUid": "profile_worker01",
          "userUid": "user_w01",
          "companyUid": "comp_a8e2f6d1",
          "status": "working",
          "startAt": "2026-06-30T08:00:00.000000Z",
          "endAt": null,
          "startLatitude": 22.5726,
          "startLongitude": 88.3639,
          "endLatitude": null,
          "endLongitude": null,
          "workHours": null,
          "startAddress": "123 Main St, Kolkata",
          "endAddress": null
        }
      }
    ],
    "unreadNotificationCount": 2,
    "jobCounts": {
      "todayStats": {
        "pending": 1,
        "inProgress": 1,
        "completed": 0,
        "cancelled": 0
      },
      "overallStats": {
        "pending": 5,
        "inProgress": 2,
        "completed": 10,
        "cancelled": 1
      }
    },
    "jobChart": [
      {"label": "Pending", "value": 5, "color": "0xFFFBBF24"},
      {"label": "In Progress", "value": 2, "color": "0xFF3B82F6"},
      {"label": "Completed", "value": 10, "color": "0xFF10B981"},
      {"label": "Cancelled", "value": 1, "color": "0xFFB00020"}
    ],
    "recentJobs": [
      {
        "jobId": "JOB883F21",
        "jobTitle": "AC not cooling",
        "customerName": "Robert William",
        "customerPhone": "+917878787878",
        "customerAddress": "Kolkata, 700001",
        "workerProfileUid": "profile_worker01",
        "workerName": "Suraj Kumar",
        "workerImage": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
        "createdByProfileUid": "profile_abc123",
        "createdByName": "Ravi Kumar",
        "status": "assigned",
        "requirePhotoOnStart": true,
        "requirePhotoOnComplete": true,
        "captureLocation": true,
        "createdAt": "2026-06-30T10:15:00.000000Z",
        "assignedAt": "2026-06-30T10:20:00.000000Z",
        "startedAt": null,
        "updatedAt": "2026-06-30T10:20:00.000000Z",
        "completedAt": null,
        "lastMessage": null,
        "lastMessageAt": null,
        "lastActivityType": "created",
        "lastActivityMessage": "Job created by Ravi Kumar",
        "lastActivityAt": "2026-06-30T10:15:00.000000Z",
        "allowedActions": ["reached"]
      }
    ]
  }
}
```

---

## 5. Attendance

### GET `/attendance`
Fetches attendance logs for company members with options to filter, search, and sort.

**Query Parameters**
- `profileUid`: Filter logs for a specific member profile (Optional)
- `status`: Filter by attendance status, e.g. `working`, `ended` (Optional)
- `startDate`: ISO datetime string (Optional)
- `endDate`: ISO datetime string (Optional)
- `search`: Search across member names (Optional)
- `sortBy`: Database field to sort by (Optional, Default: `start_at`)
- `sortOrder`: `asc` \| `desc` (Optional, Default: `desc`)
- `limit`: Number of records (Optional, Default: `10`)
- `offset`: Pagination offset (Optional, Default: `0`)

**Response — 200**
```json
{
  "success": true,
  "message": "Attendance logs fetched successfully",
  "data": [
    {
      "id": 12,
      "profileUid": "profile_worker01",
      "userUid": "user_w01",
      "companyUid": "comp_a8e2f6d1",
      "status": "working",
      "startAt": "2026-06-30T08:00:00.000000Z",
      "endAt": null,
      "startLatitude": 22.5726,
      "startLongitude": 88.3639,
      "endLatitude": null,
      "endLongitude": null,
      "workHours": null,
      "startAddress": "123 Main St, Kolkata",
      "endAddress": null
    }
  ]
}
```

---

### GET `/attendance/export/csv`
Returns a download URL to download the attendance report as a CSV.

**Query Parameters**
- `profileUid`: Profile ID of the worker (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "CSV Export ready",
  "data": {
    "downloadUrl": "https://api.trackyond.com/exports/attendance_profile_worker01.csv"
  }
}
```

---

### GET `/attendance/export/pdf`
Returns a download URL to download the attendance report as a PDF.

**Query Parameters**
- `profileUid`: Profile ID of the worker (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "PDF Export ready",
  "data": {
    "downloadUrl": "https://api.trackyond.com/exports/attendance_profile_worker01.pdf"
  }
}
```

---

## 6. Jobs

### GET `/jobs`
Lists all jobs with advanced filtering, search, and pagination.

**Query Parameters**
- `limit`: Number of records per page (Optional, Default: `20`)
- `offset`: Offset index for pagination (Optional, Default: `0`)
- `orderBy`: Sort column: `createdAt`, `assignedAt`, `jobTitle`, `status`, `customerName`, `workerName` (Optional, Default: `assignedAt`)
- `order`: Sort order: `asc` \| `desc` (Optional, Default: `desc`)
- `statuses[]`: Filter list: `pending` \| `assigned` \| `in_progress` \| `completed` \| `cancelled` (Optional)
- `workerIds[]`: Filter jobs assigned to specific profiles (Optional)
- `search`: Search query string (Optional)
- `searchBy`: `all` \| `title` \| `customer` \| `address` \| `worker` (Optional, Default: `all`)
- `fromDate`: ISO datetime string (Optional)
- `toDate`: ISO datetime string (Optional)
- `logicalOperator`: Filter combine logic: `and` \| `or` (Optional, Default: `and`)

**Response — 200**
```json
{
  "success": true,
  "message": "Jobs fetched successfully",
  "data": {
    "totalCount": 1,
    "totalPages": 1,
    "itemCount": 1,
    "limit": 20,
    "offset": 0,
    "jobs": [
      {
        "jobId": "JOB883F21",
        "jobTitle": "AC not cooling",
        "customerName": "Robert William",
        "customerPhone": "+917878787878",
        "customerAddress": "Kolkata, 700001",
        "workerProfileUid": "profile_worker01",
        "workerName": "Suraj Kumar",
        "workerImage": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
        "createdByProfileUid": "profile_abc123",
        "createdByName": "Ravi Kumar",
        "status": "assigned",
        "requirePhotoOnStart": true,
        "requirePhotoOnComplete": true,
        "captureLocation": true,
        "createdAt": "2026-06-30T10:15:00.000000Z",
        "assignedAt": "2026-06-30T10:20:00.000000Z",
        "startedAt": null,
        "updatedAt": "2026-06-30T10:20:00.000000Z",
        "completedAt": null,
        "lastMessage": null,
        "lastMessageAt": null,
        "lastActivityType": "created",
        "lastActivityMessage": "Job created by Ravi Kumar",
        "lastActivityAt": "2026-06-30T10:15:00.000000Z",
        "allowedActions": ["reached"]
      }
    ]
  }
}
```

---

### POST `/jobs`
Creates a job assignment.

**Request Body (JSON)**
```json
{
  "title": "AC not cooling",
  "customerName": "Robert William",
  "customerPhone": "+917878787878",
  "customerAddress": "Room no 204, Swasti Apartment, Kolkata",
  "workerProfileUid": "profile_worker01",
  "requirePhotoOnStart": true,
  "requirePhotoOnComplete": true,
  "captureLocation": true
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Job created successfully",
  "data": {
    "jobId": "JOB883F21",
    "jobTitle": "AC not cooling",
    "customerName": "Robert William",
    "customerPhone": "+917878787878",
    "customerAddress": "Room no 204, Swasti Apartment, Kolkata",
    "workerProfileUid": "profile_worker01",
    "workerName": "Suraj Kumar",
    "workerImage": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
    "createdByProfileUid": "profile_abc123",
    "createdByName": "Ravi Kumar",
    "status": "assigned",
    "requirePhotoOnStart": true,
    "requirePhotoOnComplete": true,
    "captureLocation": true,
    "createdAt": "2026-06-30T10:15:00.000000Z",
    "assignedAt": "2026-06-30T10:15:00.000000Z",
    "startedAt": null,
    "updatedAt": "2026-06-30T10:15:00.000000Z",
    "completedAt": null,
    "lastMessage": null,
    "lastMessageAt": null,
    "lastActivityType": "created",
    "lastActivityMessage": "Job created by Ravi Kumar",
    "lastActivityAt": "2026-06-30T10:15:00.000000Z",
    "allowedActions": ["reached"]
  }
}
```

---

### POST `/jobs/{job_id}/notify`
Sends an update push notification to the assigned employee about the job.

**Response — 200**
```json
{
  "success": true,
  "message": "Notification sent for job JOB883F21",
  "data": null
}
```

---

## 7. Profiles

### GET `/profiles/me`
Fetches profile and company structure for the authenticated administrator.

**Response — 200**
```json
{
  "success": true,
  "message": "Profile fetched successfully",
  "data": {
    "uid": "profile_abc123",
    "userUid": "user_1234abcd",
    "name": "Ravi Kumar",
    "phone": "+919876543210",
    "designation": "Owner",
    "image": null,
    "gender": null,
    "companyUid": "comp_a8e2f6d1"
  }
}
```

---

## 8. Notifications

### GET `/notifications`
Fetches a list of notifications for the admin.

**Query Parameters**
- `limit`: Max records (Optional, Default: `50`)
- `offset`: Offset (Optional, Default: `0`)
- `isRead`: Filter read status (Optional)
- `isNewestFirst`: Order direction (Optional, Default: `true`)

**Response — 200**
```json
{
  "success": true,
  "message": "Notifications fetched successfully",
  "data": [
    {
      "id": "notif_998f2b",
      "userUid": "user_1234abcd",
      "profileUid": "profile_abc123",
      "title": "Job status updated",
      "body": "Suraj Kumar marked Job#JOB883F21 as completed.",
      "dataPayload": {},
      "status": "sent",
      "read": false,
      "seen": false,
      "createdAt": "2026-06-30T11:00:00.000000Z",
      "updatedAt": "2026-06-30T11:00:00.000000Z",
      "deliveredAt": null,
      "seenAt": null
    }
  ]
}
```

---

### POST `/notifications/status`
Updates read/seen status for multiple notifications.

**Request Body (JSON)**
```json
{
  "notificationIds": ["notif_998f2b"],
  "status": "read"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Notifications marked as read",
  "data": null
}
```

---

### DELETE `/notifications`
Bulk deletes selected notifications.

**Request Body (JSON)**
```json
{
  "notificationIds": ["notif_998f2b"]
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Notifications deleted successfully",
  "data": null
}
```

---

### POST `/notifications/fcm-token`
Associates an FCM token with the device for push notification dispatching.

**Headers**
- `device-id`: `<string>` (Required)
- `device-os`: `android` \| `ios` (Required)
- `app-version`: `<string>` (Required)

**Request Body (JSON)**
```json
{
  "fcmToken": "fcm_token_value_xyz"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "FCM token registered successfully",
  "data": null
}
```

---

## 9. Common / Shared APIs

These endpoints are shared across both Owner and Worker roles and are mounted on `/api/v1/common`.

### POST `/v1/common/files/upload`
Uploads a file to a specific subdirectory.

**Request Body (Form Data)**
- `file`: File payload (Required)
- `path`: target subdirectory path, e.g. `comp_abc/job_xyz` (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "data": "uploads/comp_abc/job_xyz/5f2b8a09bc.jpg"
}
```

---

### GET `/v1/common/files/download/{file_path:path}`
Serves file contents directly from the filesystem storage folder.

**Response**
Binary file contents.

---

### GET `/v1/common/job-chat/{job_id}/messages`
Retrieves chat timeline entries for a specific job.

**Query Parameters**
- `limit`: Number of entries (Optional)
- `offset`: Offset (Optional)
- `search`: Search within message texts (Optional)
- `type`: Message type filter, e.g. `text`, `activity` (Optional)

**Response — 200**
```json
{
  "success": true,
  "message": "Messages fetched successfully",
  "data": [
    {
      "uid": "msg_001",
      "localUid": "local_abc",
      "jobId": "JOB883F21",
      "senderUid": "profile_worker01",
      "type": "message",
      "metadata": {},
      "actionPerformed": null,
      "createdByAuthorAt": "2026-06-30T10:30:00.000000Z",
      "createdAt": "2026-06-30T10:30:01.000000Z",
      "updatedAt": "2026-06-30T10:30:01.000000Z",
      "seenAt": null,
      "deliveredAt": "2026-06-30T10:30:05.000000Z",
      "active": true,
      "deleted": false,
      "content": [
        {
          "type": "text",
          "content": "I have reached the location.",
          "metadata": null
        }
      ],
      "deletedByUid": null,
      "deletedByUserType": null,
      "deletedFor": [],
      "deletedAt": null,
      "deletedByUserAt": null
    }
  ]
}
```

---

### POST `/v1/common/job-chat/{job_id}/messages`
Sends messages to a job chat timeline.

**Request Body (JSON list)**
```json
[
  {
    "localUid": "local_abc",
    "jobId": "JOB883F21",
    "senderUid": "profile_abc123",
    "type": "message",
    "createdByAuthorAt": "2026-06-30T10:45:00.000000Z",
    "content": [
      {
        "type": "text",
        "content": "Keep me posted."
      }
    ]
  }
]
```

**Response — 200**
```json
{
  "success": true,
  "message": "Messages sent successfully",
  "data": {
    "messages": [
      {
        "uid": "msg_002",
        "localUid": "local_abc",
        "jobId": "JOB883F21",
        "senderUid": "profile_abc123",
        "type": "message",
        "createdByAuthorAt": "2026-06-30T10:45:00.000000Z",
        "createdAt": "2026-06-30T10:45:01.000000Z",
        "updatedAt": "2026-06-30T10:45:01.000000Z",
        "seenAt": null,
        "deliveredAt": null,
        "active": true,
        "deleted": false,
        "content": [
          {
            "type": "text",
            "content": "Keep me posted.",
            "metadata": null
          }
        ]
      }
    ],
    "job": {
      "jobId": "JOB883F21",
      "jobTitle": "AC not cooling",
      "status": "assigned"
    },
    "seenMessageUids": []
  }
}
```

---

### GET `/v1/common/job-chat/{job_id}/members`
Retrieves details of members related to a job chat (creator/assigner and assignee).

**Response — 200**
```json
{
  "success": true,
  "message": "Members fetched successfully",
  "data": [
    {
      "uid": "profile_abc123",
      "name": "Ravi Kumar",
      "phone": "+919876543210",
      "designation": "Owner",
      "image": null,
      "gender": null,
      "companyUid": "comp_a8e2f6d1"
    },
    {
      "uid": "profile_worker01",
      "name": "Suraj Kumar",
      "phone": "+919876056789",
      "designation": "Technician",
      "image": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
      "gender": "male",
      "companyUid": "comp_a8e2f6d1"
    }
  ]
}
```

---

### POST `/v1/common/job-chat/{job_id}/messages/delete`
Deletes specified chat messages (for the sender or everyone).

**Request Body (JSON)**
```json
{
  "deleteType": "everyone",
  "messageUids": ["msg_002"],
  "deletedByUserAt": "2026-06-30T10:50:00.000000Z"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Messages deleted successfully",
  "data": null
}
```

---

### POST `/v1/common/job-chat/{job_id}/seen`
Marks chat messages as seen.

**Request Body (JSON)**
```json
{
  "messageUids": ["msg_001"]
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Marked 1 messages as seen",
  "data": {
    "messageUids": ["msg_001"]
  }
}
```

---

### POST `/v1/common/job-chat/{job_id}/delivered`
Marks chat messages as delivered.

**Request Body (JSON)**
```json
{
  "messageUids": ["msg_001"]
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Marked 1 messages as delivered",
  "data": null
}
```

---

### GET `/v1/common/notifications`
Alternative endpoint to fetch user notifications.

**Response — 200**
```json
{
  "notifications": [
    {
      "notificationId": "notif_998f2b",
      "title": "Job status updated",
      "body": "Completed job JOB883F21",
      "read": false,
      "seen": false,
      "createdAt": "2026-06-30T11:00:00.000000Z"
    }
  ]
}
```

---

### POST `/v1/common/notifications/{notification_id}/read`
Alternative endpoint to mark a single notification as read.

**Response — 200**
```json
{
  "success": true,
  "message": "Notification marked as read",
  "data": null
}
```

---

### WebSocket `/v1/common/ws`
Full-duplex WebSocket connection.

**Connection URL**
`ws://<host>:<port>/api/v1/common/ws?token=<access_token>&device_id=<device_id>`  
*(Authorization headers can also be sent instead of query params)*

Sends automatic connections, network checkouts, and handles real-time job timeline syncing.
- Connection frames provide heartbeat intervals:
```json
{
  "event": "connection",
  "type": "connected",
  "headers": {},
  "data": {
    "heartbeatIntervalSeconds": 45
  }
}
```
