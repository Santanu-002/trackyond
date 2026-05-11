import 'package:flutter/material.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/chip/app_tag.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:get/get.dart';

import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/member_name_text.dart';

class MemberListTile extends StatelessWidget {
  final MemberProfile member;
  final AttendanceStatus? status;
  final String? highlight;
  final bool isCompact;

  const MemberListTile({
    super.key,
    required this.member,
    this.status,
    this.highlight,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = member.designation.toLowerCase() == 'owner';

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: isCompact ? 0 : AppUIConstants.spacing.space$4,
      ),
      dense: isCompact,
      leading: MemberAvatar(
        name: member.name,
        image: member.image,
        radius: isCompact ? 16 : 20,
      ),
      title: MemberNameText(
        name: member.name,
        highlight: highlight,
        style: isCompact ? context.textTheme.titleSmall : null,
      ),
      subtitle: Text(
        member.phone,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.theme.colorScheme.onSurfaceVariant,
          fontSize: isCompact ? 11 : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppUIConstants.spacing.space$8,
        children: [
          if (status != null && !isCompact)
            AppStatusChip.attendance(
              attendanceStatus: status!,
              context: context,
            ),
          AppTag(
            label: member.designation,
            icon: isOwner ? AppIcons.status.verified : null,
            color: isOwner ? context.theme.colorScheme.primary : null,
            isCompact: isCompact,
          ),
        ],
      ),
    );
  }
}
