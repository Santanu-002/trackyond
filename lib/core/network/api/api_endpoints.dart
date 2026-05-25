class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.2:8000/api/v1';
  static const String googleMapsApiKey = 'AIzaSyAvEMWvGiWP7TI37WzJ7LOo3NNUjw9grgk';

  // static const String baseUrl = 'http://10.102.78.67:8000/api/v1';

  static const admin = _AdminEndpoints();
  static const employee = _EmployeeEndpoints();
  static const common = _CommonEndpoints();
}

// ─────────────────────────────────────────
// Auth (shared — Employee + Admin OTP flow)
// ─────────────────────────────────────────
class _AuthEndpoints {
  final String prefix;

  const _AuthEndpoints({required this.prefix});

  static const String _root = '/auth';

  // Employee auth
  String get sendOtp => '$prefix$_root/send-otp';

  String get resendOtp => '$prefix$_root/resend-otp';

  String get verifyOtp => '$prefix$_root/verify-otp';

  String get refresh => '$prefix$_root/refresh';

  String get logout => '$prefix$_root/logout';
}

// ─────────────────────────────────────────
// Admin endpoints
// ─────────────────────────────────────────
class _AdminEndpoints {
  const _AdminEndpoints();

  static const String _root = '/admin';

  _AuthEndpoints get auth => _AuthEndpoints(prefix: _root);

  // Profiles
  String get profile => '$_root/profiles/me';

  // Company
  String get company => '$_root/company';

  String get teamStatus => '$company/team-status';

  // Members
  String get members => '$_root/members';

  // Dashboard
  String get dashboard => '$_root/dashboard';

  // Jobs
  String get jobs => '$_root/jobs';

  String jobNotify(String jobId) => '$_root/jobs/$jobId/notify';

  // Activity
  String get activitySummary => '$_root/activity/summary';

  // Notifications
  String get notifications => '$_root/notifications';

  String get notificationsStatus => '$_root/notifications/status';

  String get notificationsFcmToken => '$_root/notifications/fcm-token';

  // Attendance
  String get attendance => '$_root/attendance';

  String get attendanceExportCsv => '$_root/attendance/export/csv';

  String get attendanceExportPdf => '$_root/attendance/export/pdf';
}

// ─────────────────────────────────────────
// Employee endpoints
// ─────────────────────────────────────────
class _EmployeeEndpoints {
  const _EmployeeEndpoints();

  static const String _root = '/employee';

  _AuthEndpoints get auth => _AuthEndpoints(prefix: _root);

  // Profiles
  String get profile => '$_root/profiles/me';

  String get profiles => '$_root/profiles';

  String get profilesSwitch => '$_root/profiles/switch';

  // Jobs
  String get jobs => '$_root/jobs';

  String get jobsMock => '$_root/jobs/mock';

  String jobStatus(String jobId) => '$_root/jobs/$jobId/status';

  String jobProgress(String jobId) => '$_root/jobs/$jobId/progress';

  // Attendance
  String get attendanceStart => '$_root/attendance/start';

  String get attendanceEnd => '$_root/attendance/end';

  String get attendanceMark => '$_root/attendance/mark';

  String get attendanceStatus => '$_root/attendance/status';

  // Dashboard
  String get dashboard => '$_root/dashboard';

  // Notifications
  String get notifications => '$_root/notifications';

  String get notificationsStatus => '$_root/notifications/status';

  String get notificationsFcmToken => '$_root/notifications/fcm-token';
}

// ─────────────────────────────────────────
// Common endpoints
// ─────────────────────────────────────────
class _CommonEndpoints {
  const _CommonEndpoints();

  static const String _root = '/common';

  String get upload => '$_root/files/upload';

  String download(String path) => '$_root/files/download/$path';

  String jobChatMessages(String jobId) => '$_root/job-chat/$jobId/messages';

  String jobChatMembers(String jobId) => '$_root/job-chat/$jobId/members';
}
