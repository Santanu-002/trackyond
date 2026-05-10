import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/job_status_badge.dart';

class JobCard extends StatelessWidget {
  final JobEntity job;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = job.status == JobStatus.completed;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withAlpha(50),
              borderRadius: BorderRadius.circular(
                AppUIConstants.radius.radius$12,
              ),
            ),
            child: Icon(
              !isCompleted ? AppIcons.jobs.work : AppIcons.dashboard.completed,
              color: colorScheme.primary,
            ),
          ),
          AppUIConstants.widgets.horizontalBox$12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.jobTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppUIConstants.widgets.verticalBox$4,
                Text(
                  job.customerAddress ?? 'No address provided',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppUIConstants.widgets.horizontalBox$8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppUtils.formatRelativeTime(job.createdAt),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              AppUIConstants.widgets.verticalBox$4,
              JobStatusBadge(status: job.status),
            ],
          ),
        ],
      ),
    );
  }
}
