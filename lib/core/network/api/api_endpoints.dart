class ApiEndpoints {
  // static const String baseUrl = 'http://192.168.1.28:8000/api/v1';

  static const String baseUrl = 'http://10.185.93.67:8000/api/v1';

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

  // Company
  String get company => '$_root/company';

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
  String get profiles => '$_root/profiles';

  String get profilesSwitch => '$_root/profiles/switch';

  // Jobs
  String get jobs => '$_root/jobs';

  String jobStatus(String jobId) => '$_root/jobs/$jobId/status';

  String jobProgress(String jobId) => '$_root/jobs/$jobId/progress';

  // Attendance
  String get attendanceStart => '$_root/attendance/start';

  String get attendanceEnd => '$_root/attendance/end';

  String get attendanceMark => '$_root/attendance/mark';

  String get attendanceStatus => '$_root/attendance/status';

  // Notifications
  String get notifications => '$_root/notifications';
}

// ─────────────────────────────────────────
// Common endpoints
// ─────────────────────────────────────────
class _CommonEndpoints {
  const _CommonEndpoints();

  static const String _root = '/common';

  String download(String path) => '$_root/files/download/$path';
}
