import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/entities/job/job_sort_options.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class SortBottomSheet extends GetView<JobsController> {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppUIConstants.radius.radius$24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppUIConstants.spacing.space$20,
        AppUIConstants.spacing.space$20,
        AppUIConstants.spacing.space$20,
        AppUIConstants.spacing.space$32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
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
                'Sort By',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Obx(
                () => IconButton(
                  onPressed: () {
                    final newOrder =
                        controller.sort.value.order == SortOrder.desc
                            ? SortOrder.asc
                            : SortOrder.desc;
                    controller.setSort(controller.sort.value.field, newOrder);
                  },
                  icon: Icon(
                    controller.sort.value.order == SortOrder.desc
                        ? AppIcons.common.arrowDown
                        : AppIcons.common.arrowUp,
                  ),
                ),
              ),
            ],
          ),
          AppUIConstants.widgets.verticalBox$16,

          // Sort List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: JobSortField.values.length,
              itemBuilder: (context, index) {
                final field = JobSortField.values[index];
                return Obx(() {
                  final isSelected = controller.sort.value.field == field;
                  return ListTile(
                    onTap: () {
                      controller.setSort(field, controller.sort.value.order);
                      Get.back();
                    },
                    selected: isSelected,
                    selectedTileColor: context.theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
                    ),
                    title: Text(
                      controller.getSortFieldLabel(field),
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected
                            ? context.theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            AppIcons.common.checkCircle,
                            color: context.theme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
