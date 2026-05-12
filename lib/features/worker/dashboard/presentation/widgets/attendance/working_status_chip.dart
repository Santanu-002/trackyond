import 'package:flutter/material.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance/working_status_content.dart';

class WorkingStatusChip extends StatelessWidget {
  final AttendanceStatus status;

  const WorkingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: WorkingStatusContent(status: status),
    );
  }
}
