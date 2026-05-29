import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip_row.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/core/common/widgets/card/app_job_card.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/skeleton/jobs_list_skeleton.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/core/common/entities/job/job_filter_options.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/status_quick_chip.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/layout/jobs_action_bar_button.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/jobs_empty_state.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/worker/job_worker_capsule.dart';
class JobsPage extends GetView<JobsController> {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.jobs.appBarTitle,
      useScrollView: false,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Search Bar
              AppSearchBar<JobSearchField>(
                query: controller.searchQuery,
                hintText: AppStrings.jobs.searchHint,
                searchByItems: JobSearchField.values,
                selectedSearchByGetter: () => controller.searchBy.value,
                searchByLabelBuilder: (value) =>
                    controller.getSearchByLabel(value),
                onSearchBySelected: (value) =>
                    controller.searchBy.value = value,
              ),

              // 2. Selected Worker Capsules (Below Search Bar)
              Obx(() {
                final selected = controller.selectedWorkers;
                if (selected.isEmpty) return const SizedBox.shrink();

                return Column(
                  children: [
                    AppUIConstants.widgets.verticalBox$12,
                    Row(
                      children: [
                        Text(
                          '${AppStrings.jobs.members}:',
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppUIConstants.widgets.horizontalBox$8,
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: selected.map((worker) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: AppUIConstants.spacing.space$8,
                                  ),
                                  child: JobWorkerCapsule(
                                    worker: worker,
                                    onRemove: () =>
                                        controller.toggleWorker(worker),
                                    isCompact: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              AppUIConstants.widgets.verticalBox$12,

              // 3. Common Filter Chips
              Column(
                children: [
                  // Date Row
                  Row(
                    children: [
                      Text(
                        '${AppStrings.jobs.date}:',
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () {
                            // Register dependencies
                            controller.filter.value;
                            controller.activeDateFilterIndex.value;
                            
                            return AppFilterChipRow.fromEntityList(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppUIConstants.spacing.space$16,
                              ),
                              items: controller.dateFilterChips,
                              isSelected: (index) => switch (index) {
                                0 => controller.isTodaySelected,
                                1 => controller.isThisWeekSelected,
                                2 => controller.isThisMonthSelected,
                                3 => controller.isLast3MonthsSelected,
                                _ => false,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  AppUIConstants.widgets.verticalBox$8,
                  // Status Row
                  Row(
                    children: [
                      Text(
                        '${AppStrings.jobs.status}:',
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(
                        child: AppFilterChipRow.children(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppUIConstants.spacing.space$16,
                          ),
                          children: [
                            StatusQuickChip(
                              label: AppStrings.jobs.pending,
                              status: JobStatus.pending,
                            ),
                            StatusQuickChip(
                              label: AppStrings.jobs.inProgress,
                              status: JobStatus.inProgress,
                            ),
                            StatusQuickChip(
                              label: AppStrings.jobs.completed,
                              status: JobStatus.completed,
                            ),
                            StatusQuickChip(
                              label: AppStrings.jobs.cancelled,
                              status: JobStatus.cancelled,
                            ),
                            ],                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 4. Jobs List Action
              Obx(() {
                if (!controller.isFilteringActive) return const SizedBox.shrink();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton.ghost(
                      text: 'Clear',
                      onPressed: controller.clearFilters,
                      width: null,
                      height: null,
                      color: context.theme.colorScheme.primary,
                    ),
                  ],
                );
              }),

              // 5. Jobs List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: JobsListSkeleton(),
                    );
                  }

                  if (controller.jobs.isEmpty) {
                    return const JobsEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async => controller.refreshJobs(),
                    child: ListView.separated(
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(
                        top: AppUIConstants.spacing.space$16,
                        bottom: 100, // Extra space for bottom action bar
                      ),
                      itemCount:
                          controller.jobs.length +
                          (controller.hasMore.value ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          AppUIConstants.widgets.verticalBox$12,
                      itemBuilder: (context, index) {
                        if (index == controller.jobs.length) {
                          return Obx(() {
                            if (!controller.isMoreLoading.value) {
                              return const SizedBox.shrink();
                            }
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          });
                        }
                        return AppJobCard(
                          job: controller.jobs[index],
                          onTap: () => controller.goToJobChat(controller.jobs[index]),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),

          // 5. Bottom Action Bar
          Positioned(
            bottom: AppUIConstants.spacing.space$16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface.withValues(
                    alpha: 0.9,
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: AppUIConstants.shadows.normal,
                  border: Border.all(
                    color: context.theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      final count = controller.activeFilterCount;
                      return JobsActionBarButton(
                        icon: AppIcons.jobs.filter,
                        label: AppStrings.jobs.filter,
                        badgeCount: count > 0 ? count : null,
                        onPressed: controller.showFilterBottomSheet,
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 1,
                        height: 24,
                        color: context.theme.colorScheme.outlineVariant,
                      ),
                    ),
                    JobsActionBarButton(
                      icon: AppIcons.jobs.sort,
                      label: AppStrings.jobs.sortBy,
                      onPressed: controller.showSortBottomSheet,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
