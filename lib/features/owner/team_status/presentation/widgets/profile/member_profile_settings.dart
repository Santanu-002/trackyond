import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';

class MemberProfileSettings extends StatelessWidget {
  const MemberProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          context,
          Icons.notifications_none_rounded,
          AppStrings.teamMemberProfile.customNotifications,
        ),
        _buildListTile(
          context,
          Icons.security_outlined,
          AppStrings.teamMemberProfile.accessPermissions,
        ),
        _buildListTile(
          context,
          Icons.block_flipped,
          AppStrings.teamMemberProfile.deactivateMember,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? context.theme.colorScheme.error
        : context.theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(color: color),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    );
  }
}
