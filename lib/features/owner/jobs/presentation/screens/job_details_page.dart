import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/theme/text_styles.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/job_details_controller.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/utils/avatar_utils.dart';
import 'package:intl/intl.dart';

class JobDetailsPage extends GetView<JobDetailsController> {
  const JobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.jobDetails.appBarTitle,
          style: AppTextStyles.light.titleLarge,
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
              _buildHeader(context, job),
              AppUIConstants.widgets.verticalBox$24,
              _buildSection(
                context,
                title: AppStrings.jobDetails.customerInfo,
                icon: AppIcons.jobs.customer,
                children: [
                  _buildDetailRow(
                    context,
                    label: AppStrings.jobDetails.customerName,
                    value: job.customerName,
                  ),
                  _buildDetailRow(
                    context,
                    label: AppStrings.jobDetails.phone,
                    value: job.customerPhone,
                    onTap: () {
                      // TODO: Implement call
                    },
                  ),
                  _buildDetailRow(
                    context,
                    label: AppStrings.jobDetails.address,
                    value: job.customerAddress ?? 'N/A',
                  ),
                ],
              ),
              AppUIConstants.widgets.verticalBox$24,
              _buildSection(
                context,
                title: AppStrings.jobDetails.jobInfo,
                icon: AppIcons.jobs.work,
                children: [
                  _buildDetailRow(
                    context,
                    label: AppStrings.jobDetails.work,
                    value: job.jobTitle,
                  ),
                  _buildDetailRow(
                    context,
                    label: AppStrings.jobDetails.scheduledAt,
                    value: job.assignedAt != null
                        ? DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(job.assignedAt!)
                        : 'N/A',
                  ),
                  _buildDetailRow(
                    context,
                    label: AppStrings.jobDetails.createdAt,
                    value: DateFormat(
                      'dd MMM yyyy, hh:mm a',
                    ).format(job.createdAt),
                  ),
                ],
              ),
              AppUIConstants.widgets.verticalBox$24,
              _buildSection(
                context,
                title: AppStrings.jobDetails.assignmentInfo,
                icon: AppIcons.common.team,
                children: [_buildWorkerInfo(context, job)],
              ),
              AppUIConstants.widgets.verticalBox$24,
              _buildSection(
                context,
                title: AppStrings.jobDetails.requirements,
                icon: AppIcons.dashboard.assignment,
                children: [
                  _buildRequirementItem(
                    context,
                    label: AppStrings.jobDetails.photoRequiredOnStart,
                    value: job.requirePhotoOnStart,
                  ),
                  _buildRequirementItem(
                    context,
                    label: AppStrings.jobDetails.photoRequiredOnCompletion,
                    value: job.requirePhotoOnComplete,
                  ),
                  _buildRequirementItem(
                    context,
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

  Widget _buildHeader(BuildContext context, JobEntity job) {
    return Container(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.2),
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
                style: AppTextStyles.light.titleLarge.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              AppUIConstants.widgets.verticalBox$4,
              Text(
                DateFormat('EEEE, dd MMMM').format(job.createdAt),
                style: AppTextStyles.light.labelSmall,
              ),
            ],
          ),
          _buildStatusBadge(context, job.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, JobStatus status) {
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
        style: AppTextStyles.light.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: context.colorScheme.primary),
            AppUIConstants.widgets.horizontalBox$8,
            Text(
              title,
              style: AppTextStyles.light.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        AppUIConstants.widgets.verticalBox$12,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$16,
            ),
            border: Border.all(color: context.colorScheme.outlineVariant),
            boxShadow: AppUIConstants.shadows.sm,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.light.bodyMedium.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: AppTextStyles.light.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: onTap != null ? context.colorScheme.primary : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerInfo(BuildContext context, JobEntity job) {
    final workerName = job.workerName;
    if (workerName == null || workerName.trim().isEmpty) {
      return Text(
        AppStrings.jobDetails.unassigned,
        style: AppTextStyles.light.bodyMedium.copyWith(
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
            style: AppTextStyles.light.labelLarge.copyWith(color: Colors.white),
          ),
        ),
        AppUIConstants.widgets.horizontalBox$12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workerName,
                style: AppTextStyles.light.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (job.workerAccountUid != null)
                Text(
                  job.workerAccountUid!,
                  style: AppTextStyles.light.labelSmall,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementItem(
    BuildContext context, {
    required String label,
    required bool value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$8),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: value ? Colors.green : Colors.grey,
          ),
          AppUIConstants.widgets.horizontalBox$8,
          Text(label, style: AppTextStyles.light.bodyMedium),
        ],
      ),
    );
  }
}
