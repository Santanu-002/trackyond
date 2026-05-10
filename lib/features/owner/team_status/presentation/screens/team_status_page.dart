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
              if (controller.isLoading.value && controller.filteredMembers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
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

