import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_strings.dart';

import 'package:trackyond/core/common/enums/attendance_status.dart';

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
      child: _buildChip(context),
    );
  }

  Widget _buildChip(BuildContext context) {
    switch (status) {
      case AttendanceStatus.working:
        return AppStatusChip(
          key: const ValueKey('working_chip'),
          label: AppStrings.ownerDashboard.working,
        );
      case AttendanceStatus.ended:
        return AppStatusChip(
          key: const ValueKey('ended_chip'),
          label: 'Ended',
          color: Colors.green, // Or use a theme color if available
        );
      case AttendanceStatus.notStarted:
        return const SizedBox.shrink(key: ValueKey('empty'));
    }
  }
}
