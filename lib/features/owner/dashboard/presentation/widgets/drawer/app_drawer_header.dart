import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';

class AppDrawerHeader extends StatelessWidget {
  final String name;
  final String phone;

  const AppDrawerHeader({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Container(
      padding: EdgeInsets.only(
        left: AppUIConstants.spacing.space$24,
        right: AppUIConstants.spacing.space$24,
        top: topPadding + AppUIConstants.spacing.space$16,
        bottom: AppUIConstants.spacing.space$16,
      ),
      child: Row(
        spacing: AppUIConstants.spacing.space$16,
        children: [
          MemberAvatar(name: name, radius: 28),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phone,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
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
