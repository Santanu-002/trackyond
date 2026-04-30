import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class AppStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  factory AppStatusChip.attendance({
    Key? key,
    required AttendanceStatus attendanceStatus,
    required BuildContext context,
  }) {
    final theme = context.theme;
    switch (attendanceStatus) {
      case AttendanceStatus.working:
        return AppStatusChip(
          key: key,
          label: 'Working',
          color: theme.colorScheme.completed,
        );
      case AttendanceStatus.ended:
        return AppStatusChip(
          key: key,
          label: 'Ended',
          color: theme.colorScheme.onSurfaceVariant,
        );
      case AttendanceStatus.notStarted:
        return AppStatusChip(
          key: key,
          label: 'Not Started',
          color: theme.colorScheme.pending,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
