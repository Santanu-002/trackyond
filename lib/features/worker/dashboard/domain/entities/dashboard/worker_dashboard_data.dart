import 'package:trackyond/core/common/entities/attendance/attendance_status_entity.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';

class WorkerDashboardData {
  final AttendanceStatusEntity attendanceStatus;
  final List<JobEntity> recentJobs;
  final JobSummaryStats todayStats;
  final JobSummaryStats overallStats;

  WorkerDashboardData({
    required this.attendanceStatus,
    required this.recentJobs,
    required this.todayStats,
    required this.overallStats,
  });
}
