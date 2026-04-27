import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/team_status_card.dart';

class TeamStatusSection extends GetView<OwnerDashboardController> {
  final List<TeamMemberStatus> members;

  const TeamStatusSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.ownerDashboard;

    return AppSection(
      title: strings.teamStatus,
      onActionPressed: controller.goToTeam,
      actionLabel: AppStrings.ownerDashboard.viewAll,
      child: Container(
        color: Colors.transparent,
        clipBehavior: Clip.none,
        height: 146,
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              SizedBox(width: AppUIConstants.spacing.space$8),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$24,
            vertical: AppUIConstants.spacing.space$8,
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            return TeamStatusCard(member: members[index]);
          },
        ),
      ),
    );
  }
}
