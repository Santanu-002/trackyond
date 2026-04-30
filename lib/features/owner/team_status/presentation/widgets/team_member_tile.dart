import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_call_button.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_info_row.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_name_text.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';

class TeamMemberTile extends GetView<TeamStatusController> {
  final TeamMemberStatusEntity member;
  final String? highlight;

  const TeamMemberTile({super.key, required this.member, this.highlight});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
      onTap: () => controller.goToMemberProfile(
        member.profile,
      ),
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: Row(
        children: [
          Hero(
            tag: 'avatar_${member.profile.accountUid}',
            child: MemberAvatar(
              name: member.profile.name,
              image: member.profile.image,
              radius: 24,
            ),
          ),
          AppUIConstants.widgets.horizontalBox$12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.spacing.space$4,
              children: [
                Hero(
                  tag: 'name_${member.profile.accountUid}',
                  child: Material(
                    color: Colors.transparent,
                    child: MemberNameText(
                      name: member.profile.name,
                      highlight: highlight,
                    ),
                  ),
                ),
                MemberInfoRow(
                  designation: member.profile.designation,
                  phone: member.profile.phone,
                  highlight: highlight,
                ),
              ],
            ),
          ),
          AppUIConstants.widgets.horizontalBox$8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: AppUIConstants.spacing.space$4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppStatusChip.attendance(
                    attendanceStatus: member.status,
                    context: context,
                  ),
                ],
              ),
              Text(
                member.startAt != null
                    ? DateFormat(
                        'hh:mm a',
                      ).format(member.startAt!.toLocal())
                    : '-',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          ...[
            AppUIConstants.widgets.horizontalBox$12,
            MemberCallButton(phoneNumber: member.profile.phone),
          ],
        ],
      ),
    );
  }
}
