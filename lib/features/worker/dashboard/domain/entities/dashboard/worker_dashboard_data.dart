import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_status_entity.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';

class WorkerDashboardData extends Equatable {
  final AttendanceStatusEntity attendanceStatus;
  final List<JobEntity> recentJobs;
  final JobCountsEntity jobCounts;
  final int unreadNotificationCount;

  const WorkerDashboardData({
    required this.attendanceStatus,
    required this.recentJobs,
    required this.jobCounts,
    this.unreadNotificationCount = 0,
  });

  @override
  List<Object?> get props => [attendanceStatus, recentJobs, jobCounts, unreadNotificationCount];
}
