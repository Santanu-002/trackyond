import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class JobItemWidget extends StatelessWidget {
  final JobEntity job;
  final VoidCallback? onTap;

  const JobItemWidget({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = context.theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
      child: Container(
        padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(50)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.jobTitle,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: job.status),
              ],
            ),
            AppUIConstants.widgets.verticalBox$12,
            _InfoRow(icon: AppIcons.jobs.customer, label: job.customerName),
            AppUIConstants.widgets.verticalBox$8,
            _InfoRow(
              icon: AppIcons.dashboard.location,
              label: job.customerAddress ?? 'No address provided',
            ),
            AppUIConstants.widgets.verticalBox$12,
            const Divider(),
            AppUIConstants.widgets.verticalBox$8,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Created At',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(job.createdAt),
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.theme.colorScheme.primary.withAlpha(180),
        ),
        AppUIConstants.widgets.horizontalBox$8,
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final JobStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color color;
    switch (status) {
      case JobStatus.pending:
      case JobStatus.assigned:
        color = colorScheme.pending;
      case JobStatus.inProgress:
        color = colorScheme.secondary;
      case JobStatus.completed:
        color = colorScheme.tertiary;
      case JobStatus.cancelled:
        color = colorScheme.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.value.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
