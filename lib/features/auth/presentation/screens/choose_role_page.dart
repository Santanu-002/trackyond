import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  const Spacer(flex: 2),
                  Container(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_tree_rounded,
                      size: 40,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppUIConstants.spacing.space$12,
                    children: [
                      Text(
                        strings.title,
                        style: context.textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        strings.subtitle,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
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
                  'Trackyond v1.0.0',
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
