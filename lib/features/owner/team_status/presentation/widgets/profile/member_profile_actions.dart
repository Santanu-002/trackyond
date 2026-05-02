import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class MemberProfileActions extends StatelessWidget {
  const MemberProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          AppIcons.auth.phoneOutlined,
          AppStrings.teamMemberProfile.call,
        ),
        _buildActionButton(
          context,
          Icons.chat_bubble_outline,
          AppStrings.teamMemberProfile.message,
        ),
        _buildActionButton(
          context,
          Icons.history_rounded,
          AppStrings.teamMemberProfile.logs,
        ),
        _buildActionButton(
          context,
          Icons.edit_outlined,
          AppStrings.teamMemberProfile.edit,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer.withValues(
              alpha: 0.3,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: context.theme.colorScheme.primary, size: 24),
        ),
        AppUIConstants.widgets.verticalBox$8,
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
