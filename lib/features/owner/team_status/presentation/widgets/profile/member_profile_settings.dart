import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/profile/settings_tile.dart';

class MemberProfileSettings extends StatelessWidget {
  const MemberProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: AppStrings.teamMemberProfile.customNotifications,
        ),
        SettingsTile(
          icon: Icons.security_outlined,
          title: AppStrings.teamMemberProfile.accessPermissions,
        ),
        SettingsTile(
          icon: Icons.block_flipped,
          title: AppStrings.teamMemberProfile.deactivateMember,
          isDestructive: true,
        ),
      ],
    );
  }
}
