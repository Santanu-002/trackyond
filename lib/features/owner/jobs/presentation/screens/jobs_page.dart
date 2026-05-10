import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/job_card.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/jobs_list_skeleton.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_filter_options.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/job_quick_filter_chip.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/status_quick_chip.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/jobs_action_bar_button.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/job_worker_capsule.dart';

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
                hintText: 'Search jobs...',
                searchByItems: JobSearchField.values,
                selectedSearchByGetter: () => controller.searchBy.value,
                searchByLabelBuilder: (value) =>
                    controller.getSearchByLabel(value),
                onSearchBySelected: (value) => controller.searchBy.value = value,
              ),

              // 2. Selected Worker Capsules (Below Search Bar)
              Obx(() {
                final selected = controller.selectedWorkers;
                if (selected.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: selected.map((worker) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: JobWorkerCapsule(
                            worker: worker,
                            onRemove: () => controller.toggleWorker(worker),
                            isCompact: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),

              // 3. Common Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Obx(() => JobQuickFilterChip(
                          label: "Today",
                          isSelected: controller.fromDate != null &&
                              controller.fromDate!.day == DateTime.now().day,
                          onTap: controller.setQuickFilterToday,
                        )),
                    AppUIConstants.widgets.horizontalBox$8,
                    const StatusQuickChip(
                        label: 'Pending', status: JobStatus.pending),
                    AppUIConstants.widgets.horizontalBox$8,
                    const StatusQuickChip(
                        label: 'In Progress', status: JobStatus.inProgress),
                    AppUIConstants.widgets.horizontalBox$8,
                    const StatusQuickChip(
                        label: 'Completed', status: JobStatus.completed),
                    AppUIConstants.widgets.horizontalBox$8,
                    AppButton.ghost(
                      text: 'This Week',
                      width: null,
                      height: 32,
                      onPressed: controller.setQuickFilterThisWeek,
                      shape: AppButtonShape.roundEdge,
                    ),
                    AppUIConstants.widgets.horizontalBox$8,
                    AppButton.ghost(
                      text: 'This Month',
                      width: null,
                      height: 32,
                      onPressed: controller.setQuickFilterThisMonth,
                      shape: AppButtonShape.roundEdge,
                    ),
                    AppUIConstants.widgets.horizontalBox$8,
                    AppButton.ghost(
                      text: 'Last 3 Months',
                      width: null,
                      height: 32,
                      onPressed: controller.setQuickFilterLast3Months,
                      shape: AppButtonShape.roundEdge,
                    ),
                  ],
                ),
              ),

              // 4. Jobs List
              Expanded(
                child: PagingListener<int, JobEntity>(
                  controller: controller.pagingController,
                  builder: (context, state, fetchNextPage) => RefreshIndicator(
                    onRefresh: () => Future.sync(() => controller.refreshJobs()),
                    child: PagedListView<int, JobEntity>.separated(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      padding: EdgeInsets.only(
                        top: AppUIConstants.spacing.space$16,
                        bottom: 80, // Space for bottom action bar
                      ),
                      separatorBuilder: (context, index) =>
                          AppUIConstants.widgets.verticalBox$12,
                      builderDelegate: PagedChildBuilderDelegate<JobEntity>(
                        itemBuilder: (context, item, index) =>
                            JobCard(job: item),
                        firstPageProgressIndicatorBuilder: (_) =>
                            const JobsListSkeleton(),
                        noItemsFoundIndicatorBuilder: (_) => Center(
                          child: Text(AppStrings.jobs.noJobsFound),
                        ),
                      ),
                    ),
                  ),
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      context.theme.colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                        icon: Icons.filter_list_rounded,
                        label: 'Filter',
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
                      icon: Icons.swap_vert_rounded,
                      label: 'Sort By',
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
