import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/team/team_status_card.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/skeleton/team_status_card_skeleton.dart';

class TeamStatusSection extends GetView<OwnerDashboardController> {
  final List<TeamMemberStatusEntity> members;
  final bool isLoading;

  const TeamStatusSection({
    super.key,
    required this.members,
    this.isLoading = false,
  });

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
        height: 156,
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              SizedBox(width: AppUIConstants.spacing.space$8),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$24,
          ).copyWith(
            bottom: AppUIConstants.spacing.space$8,
          ),
          itemCount: isLoading ? 5 : members.length,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const TeamStatusCardSkeleton();
            }
            final member = members[index];
            return TeamStatusCard(
              member: member,
            );
          },
        ),
      ),
    );
  }
}
