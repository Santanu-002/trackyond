import 'package:flutter/material.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';

class WorkingStatusContent extends StatelessWidget {
  final AttendanceStatus status;

  const WorkingStatusContent({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AttendanceStatus.working:
        return AppStatusChip.attendance(
          key: const ValueKey('working_chip'),
          attendanceStatus: status,
          context: context,
        );
      case AttendanceStatus.notStarted:
        return const SizedBox.shrink(key: ValueKey('empty'));
    }
  }
}
