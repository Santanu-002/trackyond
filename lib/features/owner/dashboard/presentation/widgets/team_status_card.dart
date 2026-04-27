import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';
import 'package:trackyond/core/common/widgets/layout/app_card.dart';

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
          MemberAvatar(
            name: member.name,
            radius: 20,
          ),
          Text(
            member.name,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (member.isWorking)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary.withAlpha(20),
                borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
              ),
              child: Text(
                member.status,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              member.status,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.theme.colorScheme.onSurface,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          Text(
            member.time,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
