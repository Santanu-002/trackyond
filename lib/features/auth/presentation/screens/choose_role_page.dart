import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/header/app_header.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/features/auth/presentation/controllers/choose_role_controller.dart';

class ChooseRolePage extends GetView<ChooseRoleController> {
  const ChooseRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.chooseRole;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: AppUIConstants.spacing.space$24,
                children: [
                  const Spacer(flex: 1),
                  AppHeader(
                    icon: Icons.account_tree_rounded,
                    title: strings.title,
                    subtitle: strings.subtitle,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppUIConstants.spacing.space$24,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppUIConstants.spacing.space$8,
                  children: [
                    AppButton.filled(
                      text: strings.loginEmployee,
                      onPressed: () => controller.navigateToLogin(UserRole.worker),
                    ),
                    AppButton.outlined(
                      text: strings.loginCompany,
                      onPressed: () => controller.navigateToLogin(UserRole.owner),
                    ),
                  ],
                ),

                Text(
                  AppStrings.common.version,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ).paddingAll(AppUIConstants.spacing.space$24),
      ),
    );
  }
}
