import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/member/member_list_tile.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/job_worker_capsule.dart';

class FilterWorkerTab extends StatelessWidget {
  final JobsController controller;
  const FilterWorkerTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Search Bar for workers
        AppSearchBar<String>(
          query: controller.workerSearchQuery,
          hintText: AppStrings.teamStatus.searchHint,
          searchByItems: const ['All', 'Name', 'Designation', 'Phone'],
          selectedSearchByGetter: () => controller.workerSearchBy.value,
          searchByLabelBuilder: (value) =>
              controller.getWorkerSearchByLabel(value),
          onSearchBySelected: (value) => controller.workerSearchBy.value = value,
        ),
        AppUIConstants.widgets.verticalBox$12,

        // 2. Selected Capsules
        Obx(() {
          final selected = controller.selectedWorkers;
          if (selected.isEmpty) return const SizedBox.shrink();

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selected.map((worker) {
                return JobWorkerCapsule(
                  worker: worker,
                  onRemove: () => controller.toggleWorker(worker),
                );
              }).toList(),
            ),
          );
        }),

        // 3. Worker List
        Expanded(
          child: Obx(() {
            final members = controller.filteredMembers;

            if (controller.isWorkersLoading.value && members.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (members.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.teamStatus.noMatchingMembers,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: members.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 56),
              itemBuilder: (context, index) {
                final memberStatus = members[index];
                return InkWell(
                  onTap: () => controller.toggleWorker(memberStatus.profile),
                  borderRadius:
                      BorderRadius.circular(AppUIConstants.radius.radius$12),
                  child: MemberListTile(
                    member: memberStatus.profile,
                    isCompact: true,
                    highlight: controller.workerSearchQuery.value,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
