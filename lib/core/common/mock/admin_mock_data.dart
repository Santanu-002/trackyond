class OwnerMockData {
  static Map<String, dynamic> sendOtpResponse(String phone) => {
        "success": true,
        "message": "Otp sent successfully",
        "data": {
          "phone": phone,
          "otpId": "xjhs34cv",
          "otp_expires_in": 120,
          "remaining_attempts": 3
        }
      };

  static Map<String, dynamic> verifyOtpResponse(String phone) {
    final now = DateTime.now().toUtc();
    return {
      "success": true,
      "message": "Login successful",
      "data": {
        "user_uid": "user1234",
        "phone_no": phone,
        "is_new_user": false,
        "access_token": "mock_access_token_xyz",
        "refresh_token": "mock_refresh_token_abc",
        "access_token_expire_at":
            now.add(const Duration(minutes: 10)).toIso8601String(),
        "refresh_token_expire_at":
            now.add(const Duration(days: 7)).toIso8601String(),
        "token_issued_at": now.toIso8601String()
      }
    };
  }

  static Map<String, dynamic> companyProfileResponse = {
    "success": true,
    "message": "Company profile created successfully",
    "data": {
      "company_id": "comp001",
      "company_name": "Dharma AC Services",
      "created_at": "2026-04-13T08:00:00.000Z"
    }
  };

  static Map<String, dynamic> membersResponse = {
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
  };

  static Map<String, dynamic> dashboardResponse = {
    "success": true,
    "message": "Dashboard data fetched successfully",
    "data": {
      "team_members_status": [
        {"uid": "user4567", "name": "Suraj Kumar", "status": "on_job"}
      ],
      "job_counts": {"pending": 3, "in_progress": 2, "completed": 10},
      "recent_jobs": [
        {
          "job_id": "job001",
          "job_title": "AC not cooling",
          "status": "in_progress",
          "assigned_to": "Suraj Kumar"
        }
      ]
    }
  };

  static Map<String, dynamic> jobsResponse = {
    "success": true,
    "message": "Jobs fetched successfully",
    "data": {
      "jobs": [
        {
          "job_id": "job001",
          "job_title": "AC not cooling",
          "status": "assigned",
          "worker_name": "Suraj Kumar",
          "worker_uid": "user4567",
          "customer_name": "Robert William",
          "customer_phone": "+917878787878",
          "created_at": "2026-04-13T08:00:00.000Z"
        }
      ],
      "pagination": {"total": 120, "page": 1, "limit": 10}
    }
  };
}
