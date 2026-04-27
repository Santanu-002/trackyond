import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class WorkerRecentJobsSection extends StatelessWidget {
  const WorkerRecentJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppUIConstants.spacing.space$16,
      children: [
        Text(
          AppStrings.workerDashboard.recentJobs,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                  child: Icon(Icons.work, color: context.theme.colorScheme.primary),
                ),
                title: Text(AppStrings.workerDashboard.jobHash(index + 101)),
                subtitle: Text(AppStrings.workerDashboard.completedTime('2 hours ago')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to job details
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
