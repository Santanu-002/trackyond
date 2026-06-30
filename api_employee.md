# Trackyond Employee (Worker/Technician) API — `/api/v1/employee`

**Base URL:** `http://<host>:<port>/api/v1/employee`  
*(Production default: `https://api.yourapp.com/api/v1/employee`)*

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
| **POST** | `/attendance/start` | Start workday attendance check-in | Yes |
| **POST** | `/attendance/end` | End workday attendance check-out | Yes |
| **GET** | `/attendance/status` | Get current attendance status | Yes |
| **GET** | `/profiles` | List all member profiles for the user | Yes |
| **GET** | `/profiles/me` | Get worker's primary active profile details | Yes |
| **POST** | `/profiles/switch` | Switch worker's primary active profile | Yes |
| **GET** | `/jobs` | Get assigned jobs list with filters | Yes |
| **POST** | `/jobs/mock` | Create a demo mock job for testing | Yes |
| **PATCH**| `/jobs/{job_id}/status` | Update status of assigned job (in_progress, completed) | Yes |
| **GET** | `/dashboard` | Get worker dashboard summary and stats | Yes |
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
    "otpId": "xjhs34cv",
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
    "otpId": "new_xjhs34cv",
    "expiresAt": "2026-06-30T12:05:00.000000Z",
    "resendableAt": "2026-06-30T12:04:00.000000Z",
    "remainingAttempts": 3
  }
}
```

---

### POST `/auth/verify-otp`
Verifies OTP code and signs in the worker.

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
  "otpId": "xjhs34cv",
  "otp": "000000"
}
```

**Response — 200 (Success)**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userUid": "user_4567abcd",
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

## 2. Attendance

### POST `/attendance/start`
Marks the start of the worker's shift.

**Request Body (JSON)**
```json
{
  "profileUid": "profile_worker01",
  "latitude": 22.5726,
  "longitude": 88.3639,
  "address": "123 Main St, Kolkata"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Attendance started successfully",
  "data": {
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
```

---

### POST `/attendance/end`
Marks the end of the worker's shift.

**Request Body (JSON)**
```json
{
  "profileUid": "profile_worker01",
  "latitude": 22.5786,
  "longitude": 88.3699,
  "address": "456 Park Rd, Kolkata"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Attendance ended successfully",
  "data": {
    "id": 12,
    "profileUid": "profile_worker01",
    "userUid": "user_w01",
    "companyUid": "comp_a8e2f6d1",
    "status": "ended",
    "startAt": "2026-06-30T08:00:00.000000Z",
    "endAt": "2026-06-30T17:00:00.000000Z",
    "startLatitude": 22.5726,
    "startLongitude": 88.3639,
    "endLatitude": 22.5786,
    "endLongitude": 88.3699,
    "workHours": 9.0,
    "startAddress": "123 Main St, Kolkata",
    "endAddress": "456 Park Rd, Kolkata"
  }
}
```

---

### GET `/attendance/status`
Fetches the current attendance status details for a given member.

**Query Parameters**
- `profile_uid`: `<string>` (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "Current status fetched",
  "data": {
    "status": "working",
    "attendance": {
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
}
```

---

## 3. Profiles

### GET `/profiles`
Retrieves all profile memberships (companies they are added to) for the worker.

**Response — 200**
```json
{
  "success": true,
  "message": "Profiles fetched successfully",
  "data": [
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

### GET `/profiles/me`
Retrieves details of the primary active profile and its company.

**Response — 200**
```json
{
  "success": true,
  "message": "Profile fetched successfully",
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

### POST `/profiles/switch`
Switches the worker's active membership profile to another company/profile ID.

**Query Parameters**
- `profile_uid`: `<string>` (Required)

**Response — 200**
```json
{
  "success": true,
  "message": "Profile switched successfully",
  "data": {
    "uid": "profile_worker02",
    "userUid": "user_w01",
    "name": "Suraj Kumar",
    "phone": "+919876056789",
    "designation": "Helper",
    "image": null,
    "gender": "male",
    "companyUid": "comp_other"
  }
}
```

---

## 4. Jobs

### GET `/jobs`
Fetches a list of jobs assigned to the worker.

**Query Parameters**
- `limit`: Max records per page (Optional, Default: `20`)
- `offset`: Offset index (Optional, Default: `0`)
- `orderBy`: Sort column: `createdAt` \| `jobTitle` \| `status` (Optional, Default: `createdAt`)
- `order`: Sort order: `asc` \| `desc` (Optional, Default: `desc`)
- `statuses`: Filter list: `pending` \| `assigned` \| `in_progress` \| `completed` \| `cancelled` (Optional)
- `search`: Search query string (Optional)
- `searchBy`: `all` \| `title` \| `customer` \| `address` (Optional, Default: `all`)
- `fromDate`: ISO datetime string (Optional)
- `toDate`: ISO datetime string (Optional)

**Response — 200**
```json
{
  "success": true,
  "message": "Assigned jobs fetched successfully",
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

### POST `/jobs/mock`
Creates a mock job automatically assigned to the logged-in worker for simulation and UI testing.

**Response — 200**
```json
{
  "success": true,
  "message": "Mock job created successfully",
  "data": {
    "jobId": "JOB_MOCK_XYZ",
    "jobTitle": "Mock Demo Job 45",
    "customerName": "Demo Customer",
    "customerPhone": "+910000000000",
    "customerAddress": "123 Test Street, Mock City",
    "workerProfileUid": "profile_worker01",
    "workerName": "Suraj Kumar",
    "workerImage": "uploads/comp_a8e2f6d1/profile_worker01/avatar.jpg",
    "createdByProfileUid": "profile_worker01",
    "createdByName": "Suraj Kumar",
    "status": "assigned",
    "requirePhotoOnStart": false,
    "requirePhotoOnComplete": false,
    "captureLocation": false,
    "createdAt": "2026-06-30T11:30:00.000000Z",
    "assignedAt": "2026-06-30T11:30:00.000000Z",
    "startedAt": null,
    "updatedAt": "2026-06-30T11:30:00.000000Z",
    "completedAt": null,
    "lastMessage": null,
    "lastMessageAt": null,
    "lastActivityType": "created",
    "lastActivityMessage": "Mock demo job created by Suraj Kumar",
    "lastActivityAt": "2026-06-30T11:30:00.000000Z",
    "allowedActions": ["reached"]
  }
}
```

---

### PATCH `/jobs/{job_id}/status`
Updates job status. Used to transition jobs through workflow status states (`in_progress`, `completed`).

**Request Body (JSON)**
```json
{
  "status": "in_progress"
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Job status updated to in_progress",
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
    "status": "in_progress",
    "requirePhotoOnStart": true,
    "requirePhotoOnComplete": true,
    "captureLocation": true,
    "createdAt": "2026-06-30T10:15:00.000000Z",
    "assignedAt": "2026-06-30T10:20:00.000000Z",
    "startedAt": "2026-06-30T11:45:00.000000Z",
    "updatedAt": "2026-06-30T11:45:00.000000Z",
    "completedAt": null,
    "lastMessage": null,
    "lastMessageAt": null,
    "lastActivityType": "started",
    "lastActivityMessage": "Job started",
    "lastActivityAt": "2026-06-30T11:45:00.000000Z",
    "allowedActions": ["take_break", "send_location", "complete_job_with_capture_photo"]
  }
}
```

---

## 5. Dashboard

### GET `/dashboard`
Provides attendance status, assigned job counts, unread alerts count, and recent job listings.

**Response — 200**
```json
{
  "success": true,
  "message": "Employee dashboard fetched successfully",
  "data": {
    "attendanceStatus": {
      "status": "working",
      "attendance": {
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
    },
    "unreadNotificationCount": 1,
    "recentJobs": [
      {
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
        "status": "in_progress",
        "requirePhotoOnStart": true,
        "requirePhotoOnComplete": true,
        "captureLocation": true,
        "createdAt": "2026-06-30T10:15:00.000000Z",
        "assignedAt": "2026-06-30T10:20:00.000000Z",
        "startedAt": "2026-06-30T11:45:00.000000Z",
        "updatedAt": "2026-06-30T11:45:00.000000Z",
        "completedAt": null,
        "lastMessage": null,
        "lastMessageAt": null,
        "lastActivityType": "started",
        "lastActivityMessage": "Job started",
        "lastActivityAt": "2026-06-30T11:45:00.000000Z",
        "allowedActions": ["take_break", "send_location", "complete_job_with_capture_photo"]
      }
    ],
    "jobCounts": {
      "todayStats": {
        "pending": 0,
        "inProgress": 1,
        "completed": 0,
        "cancelled": 0,
        "completedToday": 0,
        "totalAssigned": 1
      },
      "overallStats": {
        "pending": 2,
        "inProgress": 1,
        "completed": 8,
        "cancelled": 0,
        "completedToday": 0,
        "totalAssigned": 3
      }
    }
  }
}
```

---

## 6. Notifications

### GET `/notifications`
Fetches a list of notifications for the worker.

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
      "id": "notif_001",
      "userUid": "user_w01",
      "profileUid": "profile_worker01",
      "title": "New Job Assigned",
      "body": "You have been assigned a new job.",
      "dataPayload": {},
      "status": "sent",
      "read": false,
      "seen": false,
      "createdAt": "2026-06-30T10:20:00.000000Z",
      "updatedAt": "2026-06-30T10:20:00.000000Z",
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
  "notificationIds": ["notif_001"],
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
  "notificationIds": ["notif_001"]
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

## 7. Common / Shared APIs

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
    "senderUid": "profile_worker01",
    "type": "message",
    "createdByAuthorAt": "2026-06-30T10:30:00.000000Z",
    "content": [
      {
        "type": "text",
        "content": "I have reached the location."
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
        "uid": "msg_001",
        "localUid": "local_abc",
        "jobId": "JOB883F21",
        "senderUid": "profile_worker01",
        "type": "message",
        "createdByAuthorAt": "2026-06-30T10:30:00.000000Z",
        "createdAt": "2026-06-30T10:30:01.000000Z",
        "updatedAt": "2026-06-30T10:30:01.000000Z",
        "seenAt": null,
        "deliveredAt": null,
        "active": true,
        "deleted": false,
        "content": [
          {
            "type": "text",
            "content": "I have reached the location.",
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
  "messageUids": ["msg_001"],
  "deletedByUserAt": "2026-06-30T10:35:00.000000Z"
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
  "messageUids": ["msg_002"]
}
```

**Response — 200**
```json
{
  "success": true,
  "message": "Marked 1 messages as seen",
  "data": {
    "messageUids": ["msg_002"]
  }
}
```

---

### POST `/v1/common/job-chat/{job_id}/delivered`
Marks chat messages as delivered.

**Request Body (JSON)**
```json
{
  "messageUids": ["msg_002"]
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
      "notificationId": "notif_001",
      "title": "New Job Assigned",
      "body": "You have been assigned a new job.",
      "read": false,
      "seen": false,
      "createdAt": "2026-06-30T10:20:00.000000Z"
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
