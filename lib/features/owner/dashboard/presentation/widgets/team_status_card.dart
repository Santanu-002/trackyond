import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/attendance_status_time.dart';

class TeamStatusCard extends StatelessWidget {
  final TeamMemberStatusEntity member;
  final VoidCallback? onTap;

  const TeamStatusCard({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      width: 110,
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppUIConstants.spacing.space$4,
        children: [
          Hero(
            tag: 'avatar_${member.profile.accountUid}',
            child: MemberAvatar(
              name: member.profile.name,
              image: member.profile.image,
              radius: 20,
            ),
          ),
          Hero(
            tag: 'name_${member.profile.accountUid}',
            child: Material(
              color: Colors.transparent,
              child: Text(
                member.profile.name,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          AppStatusChip.attendance(
            attendanceStatus: member.status,
            context: context,
          ),
          AttendanceStatusTime(time: member.startAt),
        ],
      ),
    );
  }
}
