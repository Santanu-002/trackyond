import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/job_details_controller.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/details/job_details_header.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/details/job_details_section.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/details/job_details_row.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/details/job_details_worker_info.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/details/job_details_requirement_item.dart';

class JobDetailsPage extends GetView<JobDetailsController> {
  const JobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.jobDetails.appBarTitle,
          style: context.textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(AppIcons.common.back),
          onPressed: controller.onBack,
        ),
      ),
      body: Obx(() {
        final job = controller.job;
        if (job == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JobDetailsHeader(job: job),
              AppUIConstants.widgets.verticalBox$24,
              JobDetailsSection(
                title: AppStrings.jobDetails.customerInfo,
                icon: AppIcons.jobs.customer,
                children: [
                  JobDetailsRow(
                    label: AppStrings.jobDetails.customerName,
                    value: job.customerName,
                  ),
                  JobDetailsRow(
                    label: AppStrings.jobDetails.phone,
                    value: job.customerPhone,
                    onTap: () {
                      // TODO: Implement call
                    },
                  ),
                  JobDetailsRow(
                    label: AppStrings.jobDetails.address,
                    value: job.customerAddress ?? 'N/A',
                  ),
                ],
              ),
              AppUIConstants.widgets.verticalBox$24,
              JobDetailsSection(
                title: AppStrings.jobDetails.jobInfo,
                icon: AppIcons.jobs.work,
                children: [
                  JobDetailsRow(
                    label: AppStrings.jobDetails.work,
                    value: job.jobTitle,
                  ),
                  JobDetailsRow(
                    label: AppStrings.jobDetails.scheduledAt,
                    value: job.assignedAt != null
                        ? DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(job.assignedAt!)
                        : 'N/A',
                  ),
                  JobDetailsRow(
                    label: AppStrings.jobDetails.createdAt,
                    value: DateFormat(
                      'dd MMM yyyy, hh:mm a',
                    ).format(job.createdAt),
                  ),
                ],
              ),
              AppUIConstants.widgets.verticalBox$24,
              JobDetailsSection(
                title: AppStrings.jobDetails.assignmentInfo,
                icon: AppIcons.common.team,
                children: [JobDetailsWorkerInfo(job: job)],
              ),
              AppUIConstants.widgets.verticalBox$24,
              JobDetailsSection(
                title: AppStrings.jobDetails.requirements,
                icon: AppIcons.dashboard.assignment,
                children: [
                  JobDetailsRequirementItem(
                    label: AppStrings.jobDetails.photoRequiredOnStart,
                    value: job.requirePhotoOnStart,
                  ),
                  JobDetailsRequirementItem(
                    label: AppStrings.jobDetails.photoRequiredOnCompletion,
                    value: job.requirePhotoOnComplete,
                  ),
                  JobDetailsRequirementItem(
                    label: AppStrings.jobDetails.locationTrackingEnabled,
                    value: job.captureLocation,
                  ),
                ],
              ),
              AppUIConstants.widgets.verticalBox$32,
              AppButton.filled(
                text: 'Edit Job',
                onPressed: () {
                  // TODO: Implement Edit
                  AppSnackbar.warn(AppStrings.common.underDevelopment);
                },
                width: double.infinity,
              ),
            ],
          ),
        );
      }),
    );
  }
}
