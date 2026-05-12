import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/screens/team_member_profile_page.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/attendance_status_time.dart';

class TeamStatusCard extends GetView<OwnerDashboardController> {
  final TeamMemberStatusEntity member;

  const TeamStatusCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 110,
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
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$24,
            ),
            child: Padding(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppUIConstants.spacing.space$4,
                children: [
                  MemberAvatar(
                    name: member.profile.name,
                    image: member.profile.image,
                    radius: 20,
                  ),
                  Material(
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
                  AppStatusChip.attendance(
                    attendanceStatus: member.status,
                    context: context,
                  ),
                  AttendanceStatusTime(time: member.startAt),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
