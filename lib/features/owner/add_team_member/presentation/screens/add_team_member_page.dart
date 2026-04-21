import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';

class AddTeamMemberPage extends GetView<AddTeamMemberController> {
  const AddTeamMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.addTeamMember.appBarTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUIConstants.spacing.space$24,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.spacing.space$8,
            children: [
              Text(
                AppStrings.addTeamMember.title,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              Text(
                AppStrings.addTeamMember.subtitle,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
            maxLength: 10,
          ),
          Obx(() => AppButton.filled(
                text: AppStrings.addTeamMember.addButton,
                onPressed: controller.isFormValid.value ? controller.addMember : null,
                isLoading: controller.isLoading.value,
              )),
          Center(
            child: AppButton.ghost(
              text: AppStrings.addTeamMember.continueButton,
              onPressed: controller.skip,
            ),
          ),
        ],
      ),
    );
  }
}
