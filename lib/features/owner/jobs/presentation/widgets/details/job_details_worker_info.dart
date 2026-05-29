import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/avatar_utils.dart';

class JobDetailsWorkerInfo extends StatelessWidget {
  final JobEntity job;

  const JobDetailsWorkerInfo({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final workerName = job.workerName;
    if (workerName == null || workerName.trim().isEmpty) {
      return Text(
        AppStrings.jobDetails.unassigned,
        style: context.textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AvatarUtils.getAvatarColor(workerName),
          child: Text(
            AvatarUtils.getInitials(workerName),
            style: context.textTheme.labelLarge?.copyWith(
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
        ),
        AppUIConstants.widgets.horizontalBox$12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workerName,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                job.workerProfileUid,
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
