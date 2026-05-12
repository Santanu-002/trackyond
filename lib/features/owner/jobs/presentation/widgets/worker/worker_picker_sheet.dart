import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/member/member_list_tile.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

import 'package:trackyond/features/owner/add_team_member/presentation/widgets/add_member_tile.dart';
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
                  AppButton.icon(
                    onPressed: () => Get.back(),
                    size: 36,
                    icon: Icon(AppIcons.common.close, size: 20),
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
                searchByLabelBuilder: (value) =>
                    controller.getSearchByLabel(value),
                onSearchBySelected: (value) =>
                    controller.searchBy.value = value,
              ),
              AppUIConstants.widgets.verticalBox$16,

              // Picker List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // Add Member Tile at the top (matches AddTeamMemberPage layout)
                    AddMemberTile(onTap: controller.navigateToAddMemberDetails),
                    AppUIConstants.widgets.verticalBox$16,

                    // Constant Members Label
                    Text(
                      AppStrings.createJob.membersLabel,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                    AppUIConstants.widgets.verticalBox$12,

                    Obx(() {
                      final members = controller.filteredMembers;

                      if (controller.isWorkersLoading.value &&
                          members.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppUIConstants.spacing.space$32,
                            ),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (members.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppUIConstants.spacing.space$32,
                            ),
                            child: Text(
                              AppStrings.teamStatus.noMatchingMembers,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          ...members.asMap().entries.map((entry) {
                            final index = entry.key;
                            final memberStatus = entry.value;
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 400 + (index * 50),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      AppUIConstants.spacing.space$20 *
                                          (1 - value),
                                    ),
                                    child: child,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppUIConstants.spacing.space$4,
                                ),
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
                                    highlight:
                                        controller.workerSearchQuery.value,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }),

                    // Show loader at bottom when searching and list is not empty
                    Obx(
                      () =>
                          controller.isWorkersLoading.value &&
                              controller.filteredMembers.isNotEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppUIConstants.spacing.space$16,
                                ),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    AppUIConstants.widgets.verticalBox$32,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
