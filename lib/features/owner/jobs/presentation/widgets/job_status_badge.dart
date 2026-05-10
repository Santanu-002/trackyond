import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class JobStatusBadge extends StatelessWidget {
  final JobStatus status;

  const JobStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    final color = switch (status) {
      JobStatus.pending => colorScheme.pending,
      JobStatus.assigned => colorScheme.primary,
      JobStatus.inProgress => colorScheme.secondary,
      JobStatus.completed => colorScheme.tertiary,
      JobStatus.cancelled => colorScheme.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(
          AppUIConstants.radius.radius$8,
        ),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
