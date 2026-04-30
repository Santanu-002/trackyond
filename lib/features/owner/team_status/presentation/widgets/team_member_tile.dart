import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';
import 'package:trackyond/features/owner/team_status/presentation/bindings/team_member_profile_binding.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/screens/team_member_profile_page.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_call_button.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_info_row.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_name_text.dart';

class TeamMemberTile extends StatelessWidget {
  final TeamMemberStatus member;
  final String? highlight;

  const TeamMemberTile({super.key, required this.member, this.highlight});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: OpenContainer(
        transitionType: ContainerTransitionType.fade,
        openElevation: 0,
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        ),
        closedColor: Colors.transparent,
        openBuilder: (context, _) {
          if (!Get.isRegistered<TeamMemberProfileController>()) {
            TeamMemberProfileBinding().dependencies();
          }
          final controller = Get.find<TeamMemberProfileController>();
          controller.member = member;
          controller.fetchLogs();
          return const TeamMemberProfilePage();
        },
        closedBuilder: (context, openContainer) {
          return InkWell(
            onTap: openContainer,
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$16,
            ),
            splashColor: context.theme.primaryColor.withValues(alpha: 0.1),
            highlightColor: context.theme.primaryColor.withValues(alpha: 0.2),
            child: Padding(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              child: Row(
                children: [
                  Hero(
                    tag: 'avatar_${member.accountUid}',
                    child: MemberAvatar(
                      name: member.name,
                      image: member.image,
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
                          tag: 'name_${member.accountUid}',
                          child: Material(
                            color: Colors.transparent,
                            child: MemberNameText(
                              name: member.name,
                              highlight: highlight,
                            ),
                          ),
                        ),
                        MemberInfoRow(
                          designation: member.designation,
                          phone: member.phone,
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
                  MemberCallButton(phoneNumber: member.phone),
                ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
