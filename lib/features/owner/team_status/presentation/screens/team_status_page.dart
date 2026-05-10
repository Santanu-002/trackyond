import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/stats/team_stats_summary.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/filter/team_filter_row.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/team_member_tile.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/search/team_search_bar.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';

class TeamStatusPage extends GetView<TeamStatusController> {
  const TeamStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.teamStatus.title,
      useScrollView: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TeamSearchBar(),
          AppUIConstants.widgets.verticalBox$16,
          const TeamStatsSummary(),
          AppUIConstants.widgets.verticalBox$24,
          const TeamFilterRow(),
          AppUIConstants.widgets.verticalBox$16,
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      AppUIConstants.widgets.verticalBox$8,
                  itemBuilder: (context, index) => const TeamMemberTileSkeleton(),
                );
              }

              final members = controller.filteredMembers;

              if (members.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.isEmpty
                        ? AppStrings.teamStatus.noMembersFound
                        : AppStrings.teamStatus.noMatchingMembers,
                    style: context.textTheme.bodyLarge,
                  ),
                );
              }

              return RefreshIndicator.adaptive(
                onRefresh: controller.fetchTeamStatus,
                child: ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (context, index) =>
                      AppUIConstants.widgets.verticalBox$8,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return TeamMemberTile(
                      member: member,
                      highlight: controller.searchQuery.value,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class TeamMemberTileSkeleton extends StatelessWidget {
  const TeamMemberTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: AppShimmer(
        child: Row(
          children: [
            const AppSkeletonAvatar(size: 48),
            AppUIConstants.widgets.horizontalBox$12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppUIConstants.spacing.space$4,
                children: [
                  const AppSkeletonText(width: 120, variant: AppSkeletonTextVariant.body),
                  const AppSkeletonText(width: 150, variant: AppSkeletonTextVariant.caption),
                ],
              ),
            ),
            AppUIConstants.widgets.horizontalBox$8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppUIConstants.spacing.space$4,
              children: [
                const AppSkeletonContainer(
                  width: 60,
                  height: 20,
                  borderRadius: 10,
                ),
                const AppSkeletonText(width: 40, variant: AppSkeletonTextVariant.caption),
              ],
            ),
            AppUIConstants.widgets.horizontalBox$12,
            const AppSkeletonAvatar(size: 36, shape: BoxShape.circle),
          ],
        ),
      ),
    );
  }
}
