import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/common/widgets/switch/app_switch.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/create_job_controller.dart';

class CreateJobPage extends GetView<CreateJobController> {
  const CreateJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.createJob;

    return AppScaffold(
      title: strings.appBarTitle,
      footer: Obx(
        () => AppButton.filled(
          onPressed: controller.createJob,
          isLoading: controller.isLoading.value,
          text: strings.createJobButton,
        ),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppUIConstants.spacing.space$24,
          children: [
            // Work/Job Field
            AppTextField(
              label: strings.workLabel,
              hintText: strings.workHint,
              controller: controller.workController,
              prefixIcon: AppIcons.jobs.work,
              validator: (val) => (val?.isEmpty ?? true)
                  ? AppStrings.common.requiredField
                  : null,
            ),

            // Customer Name Field
            AppTextField(
              label: strings.customerNameLabel,
              hintText: strings.customerNameHint,
              controller: controller.customerNameController,
              prefixIcon: AppIcons.common.person,
              validator: (val) => (val?.isEmpty ?? true)
                  ? AppStrings.common.requiredField
                  : null,
            ),

            // Phone Number Field
            AppTextField(
              label: strings.phoneLabel,
              hintText: strings.phoneHint,
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              prefix: Padding(
                padding: EdgeInsets.only(
                  left: AppUIConstants.spacing.space$12,
                  right: AppUIConstants.spacing.space$8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.auth.phone,
                      size: AppUIConstants.spacing.space$20,
                      color: context.theme.colorScheme.primary,
                    ),
                    AppUIConstants.widgets.horizontalBox$8,
                    Text(
                      AppStrings.common.countryCode,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return AppStrings.common.requiredField;
                }
                if (val.trim().length < 10) {
                  return AppStrings.addTeamMember.phoneInvalid;
                }
                return null;
              },
            ),

            // Address Field
            AppTextField(
              label: strings.addressLabel,
              hintText: strings.addressHint,
              controller: controller.addressController,
              prefixIcon: AppIcons.dashboard.location,
              textInputAction: TextInputAction.done,
            ),

            // Assign Worker Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.spacing.space$8,
              children: [
                Text(
                  strings.assignWorkerLabel,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                Obx(
                  () => InkWell(
                    onTap: () => controller.showWorkerPicker(context),
                    borderRadius: BorderRadius.circular(
                      AppUIConstants.radius.radius$12,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppUIConstants.spacing.space$16,
                        vertical: AppUIConstants.spacing.space$16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppUIConstants.radius.radius$12,
                        ),
                        border: Border.all(
                          color: context.theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            AppIcons.common.team,
                            size: 20,
                            color: context.theme.colorScheme.primary,
                          ),
                          AppUIConstants.widgets.horizontalBox$12,
                          Expanded(
                            child: Text(
                              controller.selectedWorker.value?.name ??
                                  strings.assignWorkerHint,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: controller.selectedWorker.value == null
                                    ? context.theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5)
                                    : null,
                              ),
                            ),
                          ),
                          Icon(
                            AppIcons.common.chevronDown,
                            color: context.theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Job Requirements Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.spacing.space$24,
              children: [
                Text(
                  strings.jobRequirementsTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => AppSwitch(
                    title: strings.photoOnCompletionTitle,
                    subtitle: strings.photoOnCompletionSubtitle,
                    value: controller.requirePhotoOnCompletion.value,
                    onChanged: (val) =>
                        controller.requirePhotoOnCompletion.value = val,
                  ),
                ),
                Obx(
                  () => AppSwitch(
                    title: strings.captureLocationTitle,
                    subtitle: strings.captureLocationSubtitle,
                    value: controller.captureLocation.value,
                    onChanged: (val) => controller.captureLocation.value = val,
                  ),
                ),
                Obx(
                  () => AppSwitch(
                    title: strings.photoOnStartTitle,
                    subtitle: strings.photoOnStartSubtitle,
                    value: controller.requirePhotoOnStart.value,
                    onChanged: (val) =>
                        controller.requirePhotoOnStart.value = val,
                  ),
                ),
              ],
            ),

            // Extra spacing for FAB/Bottom padding
            AppUIConstants.widgets.verticalBox$32,
          ],
        ),
      ),
    );
  }
}
