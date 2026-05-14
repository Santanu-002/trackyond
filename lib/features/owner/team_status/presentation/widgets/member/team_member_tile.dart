import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/screens/team_member_profile_page.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/attendance_status_time.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/member_call_button.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/member_info_row.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/member_name_text.dart';

class TeamMemberTile extends StatelessWidget {
  final TeamMemberStatusEntity member;
  final String? highlight;

  const TeamMemberTile({super.key, required this.member, this.highlight});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 250),
        openBuilder: (context, _) {
          final controller = Get.put(TeamMemberProfilePageController());
          controller.memberStatus.value = member;
          return const TeamMemberProfilePage();
        },
        onClosed: (_) => Get.delete<TeamMemberProfilePageController>(),
        closedElevation: 0,
        closedColor: context.theme.colorScheme.surface,
        openColor: context.theme.scaffoldBackgroundColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
        ),
        closedBuilder: (context, openContainer) {
          return InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              openContainer();
            },
            borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
            child: Padding(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              child: Row(
                children: [
                  MemberAvatar(
                    name: member.profile.name,
                    image: member.profile.image,
                    radius: 24,
                  ),
                  AppUIConstants.widgets.horizontalBox$12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppUIConstants.spacing.space$4,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: MemberNameText(
                            name: member.profile.name,
                            highlight: highlight,
                          ),
                        ),
                        MemberInfoRow(
                          designation: member.profile.designation,
                          phone: member.profile.phone,
                          highlight: highlight,
                          profileUid: member.profile.uid,
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
                      AttendanceStatusTime(time: member.startAt),
                    ],
                  ),
                  ...[
                    AppUIConstants.widgets.horizontalBox$12,
                    MemberCallButton(phoneNumber: member.profile.phone),
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

