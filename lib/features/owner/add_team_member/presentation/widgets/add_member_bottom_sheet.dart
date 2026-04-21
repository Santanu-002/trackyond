import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/dialog/app_alert_dialog.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/gender_chip.dart';

class AddMemberBottomSheet extends StatelessWidget {
  final AddTeamMemberController controller;

  const AddMemberBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryViewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: context.mediaQuerySize.height * 0.75,
          minHeight: context.mediaQuerySize.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppUIConstants.radius.radius$24),
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.1,
              ),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle and Header
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: AppUIConstants.spacing.space$12,
                  ),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppUIConstants.spacing.space$16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.addTeamMember.addNewMemberTile,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.handleCloseBottomSheet(() {
                          _showDiscardDialog(context);
                        }),
                        constraints: BoxConstraints.tight(const Size(32, 32)),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: context.theme.unselectedWidgetColor
                              .withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),

                // Scrollable Form
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        spacing: AppUIConstants.spacing.space$16,
                        children: [
                          // Avatar Picker (Polished)
                          Center(
                            child: GestureDetector(
                              onTap: controller.pickImage,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: context.theme.colorScheme.primary
                                            .withValues(alpha: 0.2),
                                        width: 2,
                                      ),
                                    ),
                                    child: Obx(() {
                                      final imagePath =
                                          controller.avatarPath.value;
                                      return AnimatedScale(
                                        scale: imagePath != null ? 1.05 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOutBack,
                                        child: CircleAvatar(
                                          radius: 46,
                                          backgroundColor: context
                                              .theme
                                              .colorScheme
                                              .surfaceContainerHighest,
                                          backgroundImage: imagePath != null
                                              ? FileImage(File(imagePath))
                                              : null,
                                          child: imagePath == null
                                              ? Icon(
                                                  Icons.person_rounded,
                                                  size: 40,
                                                  color: context
                                                      .theme
                                                      .colorScheme
                                                      .primary,
                                                )
                                              : null,
                                        ),
                                      );
                                    }),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color:
                                            context.theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              context.theme.colorScheme.surface,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: 16,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppUIConstants.widgets.verticalBox$8,
                          AppTextField(
                            controller: controller.nameController,
                            label: AppStrings.addTeamMember.memberNameLabel,
                            hintText: AppStrings.addTeamMember.memberNameHint,
                            keyboardType: TextInputType.name,
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          AppTextField(
                            controller: controller.phoneController,
                            label: AppStrings.addTeamMember.phoneLabel,
                            hintText: AppStrings.addTeamMember.phoneHint,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_android_rounded,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),

                          // Gender Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppUIConstants.spacing.space$8,
                            children: [
                              Text(
                                AppStrings.addTeamMember.genderLabel,
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Obx(
                                () => Row(
                                  spacing: AppUIConstants.spacing.space$12,
                                  children: List.generate(
                                    Gender.values.length,
                                    (index) {
                                      final gender = Gender.values[index];

                                      return GenderChip(
                                        label: gender.value,
                                        isSelected:
                                            controller.selectedGender.value ==
                                            gender,
                                        onSelected: () =>
                                            controller.setGender(gender),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Action Button
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
                child: Obx(
                  () => AppButton.filled(
                    text: AppStrings.addTeamMember.addButton,
                    onPressed: controller.isFormValid.value
                        ? controller.addMember
                        : null,
                    isLoading: controller.isLoading.value,
                  ),
                ),
              ),
            ),
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
      onConfirm: () {
        controller.resetForm();
        Get.back(); // Close dialog
        Get.back(); // Close bottom sheet
      },
    );
  }
}
