import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class JobDetailsStatusBadge extends StatelessWidget {
  final JobStatus status;

  const JobDetailsStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$12,
        vertical: AppUIConstants.spacing.space$6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.label(context).toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
