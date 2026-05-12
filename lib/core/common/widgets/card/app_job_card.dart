import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/core/common/widgets/chip/job_status_badge.dart';

class AppJobCard extends StatelessWidget {
  final JobEntity job;
  final VoidCallback? onTap;
  final bool showStatus;

  const AppJobCard({
    super.key,
    required this.job,
    this.onTap,
    this.showStatus = true,
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
                if (job.workerName != null) ...[
                  AppUIConstants.widgets.verticalBox$4,
                  Row(
                    children: [
                      Icon(
                        AppIcons.common.person,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      AppUIConstants.widgets.horizontalBox$4,
                      Expanded(
                        child: Text(
                          job.workerName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          AppUIConstants.widgets.horizontalBox$8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppUtils.formatRelativeTime(job.createdAt),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (showStatus) ...[
                AppUIConstants.widgets.verticalBox$4,
                JobStatusBadge(status: job.status),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
