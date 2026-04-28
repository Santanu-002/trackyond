import 'package:flutter/material.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/chip/app_tag.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:get/get.dart';

class MemberListTile extends StatelessWidget {
  final MemberProfile member;

  const MemberListTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final isOwner = member.designation.toLowerCase() == 'owner';

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: AppUIConstants.spacing.space$4,
      ),
      leading: MemberAvatar(name: member.name, image: member.image),
      title: Text(
        member.name,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        member.phone,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: AppTag(
        label: member.designation,
        icon: isOwner ? AppIcons.status.verified : null,
        color: isOwner ? context.theme.colorScheme.primary : null,
      ),
    );
  }
}
