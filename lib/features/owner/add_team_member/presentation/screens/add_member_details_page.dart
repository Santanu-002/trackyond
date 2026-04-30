import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/dialog/app_alert_dialog.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/gender_chip.dart';

class AddMemberDetailsPage extends GetView<AddTeamMemberController> {
  const AddMemberDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          controller.handleBackNavigation(() => _showDiscardDialog(context));
        }
      },
      child: AppScaffold(
        title: AppStrings.addTeamMember.addNewMemberTile,
        onBackPressed: () =>
            controller.handleBackNavigation(() => _showDiscardDialog(context)),
        child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppUIConstants.spacing.space$24,
          children: [
            // Avatar Picker
            Center(
              child: GestureDetector(
                onTap: () => _showImagePickerSheet(context),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppUIConstants.spacing.space$4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          width: AppUIConstants.spacing.space$2,
                        ),
                      ),
                      child: Obx(() {
                        final imagePath = controller.avatarPath.value;
                        return AnimatedScale(
                          scale: imagePath != null ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          child: CircleAvatar(
                            radius: AppUIConstants.radius.radius$56,
                            backgroundColor: context
                                .theme
                                .colorScheme
                                .surfaceContainerHighest,
                            backgroundImage: imagePath != null
                                ? FileImage(File(imagePath))
                                : null,
                            child: imagePath == null
                                ? Icon(
                                    AppIcons.common.person,
                                    size: AppUIConstants.radius.radius$48,
                                    color: context.theme.colorScheme.primary,
                                  )
                                : null,
                          ),
                        );
                      }),
                    ),
                    Positioned(
                      bottom: AppUIConstants.spacing.space$4,
                      right: AppUIConstants.spacing.space$4,
                      child: Container(
                        padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.theme.colorScheme.surface,
                            width: AppUIConstants.spacing.space$2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.colorScheme.onSurface
                                  .withValues(alpha: 0.2),
                              blurRadius: AppUIConstants.spacing.space$4,
                              offset: Offset(0, AppUIConstants.spacing.space$2),
                            ),
                          ],
                        ),
                        child: Icon(
                          AppIcons.common.camera,
                          size: AppUIConstants.spacing.space$16,
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Fields
            Column(
              spacing: AppUIConstants.spacing.space$16,
              children: [
                AppTextField(
                  controller: controller.nameController,
                  label: AppStrings.addTeamMember.memberNameLabel,
                  hintText: AppStrings.addTeamMember.memberNameHint,
                  keyboardType: TextInputType.name,
                  prefixIcon: AppIcons.auth.user,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.addTeamMember.nameRequired;
                    }
                    return null;
                  },
                ),
                AppTextField(
                  controller: controller.phoneController,
                  label: AppStrings.addTeamMember.phoneLabel,
                  hintText: AppStrings.addTeamMember.phoneHint,
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.addTeamMember.phoneRequired;
                    }
                    if (value.trim().length < 10) {
                      return AppStrings.addTeamMember.phoneInvalid;
                    }
                    return null;
                  },
                ),
                AppTextField(
                  controller: controller.designationController,
                  label: AppStrings.addTeamMember.designationLabel,
                  hintText: AppStrings.addTeamMember.designationHint,
                  keyboardType: TextInputType.text,
                  prefixIcon: AppIcons.profile.badge,
                ),

                // Gender Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppUIConstants.spacing.space$12,
                  children: [
                    Text(
                      AppStrings.addTeamMember.genderLabel,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    Obx(
                      () => Row(
                        spacing: AppUIConstants.spacing.space$12,
                        children: Gender.values.map((gender) {
                          return GenderChip(
                            label: gender.value,
                            isSelected:
                                controller.selectedGender.value == gender,
                            onSelected: () => controller.setGender(gender),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            AppUIConstants.widgets.verticalBox$16,

            // Action Button
            Obx(
              () => AppButton.filled(
                text: AppStrings.addTeamMember.addButton,
                onPressed: controller.isFormValid.value
                    ? controller.addMember
                    : null,
                isLoading: controller.isLoading.value,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  void _showImagePickerSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(
          vertical: AppUIConstants.spacing.space$16,
        ),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppUIConstants.radius.radius$24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                AppIcons.common.camera,
                color: context.theme.colorScheme.onSurface,
              ),
              title: Text(
                AppStrings.addTeamMember.takePhoto,
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                AppIcons.common.gallery,
                color: context.theme.colorScheme.onSurface,
              ),
              title: Text(
                AppStrings.addTeamMember.chooseFromGallery,
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            Obx(() {
              if (controller.avatarPath.value != null) {
                return ListTile(
                  leading: Icon(
                    AppIcons.common.delete,
                    color: context.theme.colorScheme.error,
                  ),
                  title: Text(
                    AppStrings.addTeamMember.removePhoto,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.theme.colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    controller.removeImage();
                  },
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    AppAlertDialog.show(
      context: context,
      title: AppStrings.addTeamMember.discardTitle,
      message: AppStrings.addTeamMember.discardMessage,
      confirmText: AppStrings.addTeamMember.discardConfirm,
      cancelText: AppStrings.addTeamMember.discardCancel,
      isDestructive: true,
      onConfirm: () => controller.discardChangesAndBack(),
    );
  }
}
