import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/border/app_dashed_border.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AddMemberTile extends StatelessWidget {
  final VoidCallback onTap;

  const AddMemberTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppButton.custom(
      onPressed: onTap,
      borderRadius: AppUIConstants.radius.radius$12,
      child: AppDashedBorder(
        color: context.theme.colorScheme.primary.withValues(alpha: 0.5),
        borderRadius: AppUIConstants.radius.radius$12,
        dashWidth: 6,
        dashSpace: 4,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$12,
            ),
            color: context.theme.colorScheme.primaryContainer.withValues(
              alpha: 0.05,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: AppUIConstants.spacing.space$12,
            children: [
              Container(
                padding: EdgeInsets.all(AppUIConstants.spacing.space$4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.colorScheme.primary,
                ),
                child: Icon(
                  AppIcons.common.add,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              Text(
                AppStrings.addTeamMember.addNewMemberTile,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
