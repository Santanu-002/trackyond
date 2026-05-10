import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/member_list_tile.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/add_member_tile.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/create_job_controller.dart';

class WorkerPickerSheet extends GetView<CreateJobController> {
  const WorkerPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppUIConstants.radius.radius$24),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$20,
          ),
          child: Column(
            children: [
              // Handle
              AppUIConstants.widgets.verticalBox$12,
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppUIConstants.widgets.verticalBox$24,

              // Header
              Row(
                children: [
                  Text(
                    AppStrings.createJob.assignWorkerLabel,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  AppButton.filled(
                    onPressed: () => Get.back(),
                    width: 36,
                    height: 36,
                    color: context.theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppUIConstants.widgets.verticalBox$16,

              // Search Bar with Dropdown
              AppSearchBar<String>(
                query: controller.workerSearchQuery,
                hintText: AppStrings.teamStatus.searchHint,
                searchByItems: const ['All', 'Name', 'Designation', 'Phone'],
                selectedSearchByGetter: () => controller.searchBy.value,
                searchByLabelBuilder: (value) => controller.getSearchByLabel(value),
                onSearchBySelected: (value) => controller.searchBy.value = value,
              ),
              AppUIConstants.widgets.verticalBox$16,

              // Picker List
              Expanded(
                child: Obx(() {
                  final members = controller.filteredMembers;

                  if (controller.isWorkersLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    controller: scrollController,
                    children: [
                      // Add Member Tile at the top (matches AddTeamMemberPage layout)
                      AddMemberTile(
                        onTap: () => Get.toNamed('/add-member-details'),
                      ),
                      AppUIConstants.widgets.verticalBox$16,

                      // Members Label
                      if (members.isNotEmpty) ...[
                        Text(
                          "Members",
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        AppUIConstants.widgets.verticalBox$12,
                      ],
                      
                      if (members.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppUIConstants.spacing.space$32,
                            ),
                            child: Text(
                              AppStrings.teamStatus.noMatchingMembers,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        )
                      else
                        ...members.map((memberStatus) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
                            child: InkWell(
                              onTap: () {
                                controller.setWorker(memberStatus.profile);
                                Get.back();
                              },
                              borderRadius: BorderRadius.circular(
                                AppUIConstants.radius.radius$12,
                              ),
                              child: MemberListTile(
                                member: memberStatus.profile,
                                status: memberStatus.status,
                                highlight: controller.workerSearchQuery.value,
                              ),
                            ),
                          );
                        }),
                      
                      AppUIConstants.widgets.verticalBox$32,
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
