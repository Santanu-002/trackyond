import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';

class TeamStatusCard extends StatelessWidget {
  final TeamMemberStatus member;

  const TeamStatusCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 110,
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppUIConstants.spacing.space$4,
        children: [
          MemberAvatar(name: member.name, image: member.image, radius: 20),
          Text(
            member.name,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppStatusChip.attendance(
            attendanceStatus: member.status,
            context: context,
          ),
          if (member.startAt != null)
            Text(
              DateFormat('hh:mm a').format(member.startAt!),
              style: context.textTheme.labelSmall?.copyWith(fontSize: 10),
            )
          else
            Text(
              '-',
              style: context.textTheme.labelSmall?.copyWith(fontSize: 10),
            ),
        ],
      ),
    );
  }
}
