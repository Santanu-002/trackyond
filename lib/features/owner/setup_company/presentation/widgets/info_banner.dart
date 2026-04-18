import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$16,
        vertical: AppUIConstants.spacing.space$12,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer.withValues(
          alpha: 0.2,
        ),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
        border: Border.all(
          color: context.theme.colorScheme.primaryContainer,
          width: 0.5,
        ),
      ),
      child: Row(
        spacing: AppUIConstants.spacing.space$16,
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            color: context.theme.colorScheme.primary,
            size: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.spacing.space$4,
              children: [
                Text(
                  AppStrings.chooseTeamSize.freeBanner,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
                Text(
                  AppStrings.chooseTeamSize.noCreditCard,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
