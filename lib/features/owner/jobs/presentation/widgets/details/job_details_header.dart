import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/details/job_details_status_badge.dart';

class JobDetailsHeader extends StatelessWidget {
  final JobEntity job;

  const JobDetailsHeader({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer.withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        border: Border.all(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job #${job.jobId}',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppUIConstants.widgets.verticalBox$4,
              Text(
                DateFormat('EEEE, dd MMMM').format(job.createdAt),
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
          JobDetailsStatusBadge(status: job.status),
        ],
      ),
    );
  }
}
