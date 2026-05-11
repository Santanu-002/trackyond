import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_sort_options.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/menu/app_menu.dart';

class AdvancedFilterBar extends GetView<JobsController> {
  const AdvancedFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // 1. Sort Button
          AppMenu<JobSortField>(
            items: JobSortField.values,
            selectedValueGetter: () => controller.sort.value.field,
            labelBuilder: (field) => controller.getSortFieldLabel(field),
            onSelected: (field) {
              final currentOrder = controller.sort.value.order;
              controller.setSort(field, currentOrder);
            },
            builder: (context, menuController, child) {
              return Obx(() => InputChip(
                    onPressed: () => menuController.isOpen
                        ? menuController.close()
                        : menuController.open(),
                    avatar: Icon(
                      controller.sort.value.order == SortOrder.desc
                          ? AppIcons.common.arrowDown
                          : AppIcons.common.arrowUp,
                      size: 14,
                    ),
                    label: Text(
                        '${AppStrings.jobs.sortBy}: ${controller.getSortFieldLabel(controller.sort.value.field)}'),
                    onDeleted: () {
                      final newOrder =
                          controller.sort.value.order == SortOrder.desc
                              ? SortOrder.asc
                              : SortOrder.desc;
                      controller.setSort(controller.sort.value.field, newOrder);
                    },
                    deleteIcon: Icon(AppIcons.jobs.sort, size: 14),
                  ));
            },
          ),
          AppUIConstants.widgets.horizontalBox$8,

          // 2. Logical Operator Toggle (AND/OR)
          Obx(() {
            final isAnd = controller.filter.value.advancedFilter.logicalOperator ==
                LogicalOperator.and;
            return ActionChip(
              label: Text(isAnd ? 'Match ALL' : 'Match ANY'), // TODO: Add these to AppStrings if they grow
              onPressed: () {
                controller.setLogicalOperator(
                    isAnd ? LogicalOperator.or : LogicalOperator.and);
              },
              backgroundColor: context.theme.colorScheme.secondaryContainer
                  .withValues(alpha: 0.5),
              labelStyle: context.textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            );
          }),
          AppUIConstants.widgets.horizontalBox$8,

          // 3. Today's Task (Quick Filter)
          Obx(() => AppFilterChip(
                label: AppStrings.jobs.today,
                isSelected: controller.fromDate != null &&
                    controller.fromDate!.day == DateTime.now().day,
                onTap: () {
                  final today = DateTime.now();
                  final start = DateTime(today.year, today.month, today.day);
                  final end =
                      DateTime(today.year, today.month, today.day, 23, 59, 59);
                  controller.setDateRange(start, end);
                },
              )),

          AppUIConstants.widgets.horizontalBox$8,
          
          // 4. Active Rules
          Obx(() {
            final rules = controller.filter.value.advancedFilter.rules;
            return Row(
              children: rules.asMap().entries.map((entry) {
                final index = entry.key;
                final rule = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('${controller.getFieldLabel(rule.field)}: ${controller.getValueLabel(rule.value)}'),
                    onDeleted: () => controller.removeRule(index),
                    deleteIcon: Icon(AppIcons.common.close, size: 14),
                  ),
                );
              }).toList(),
            );
          }),
          
          // 5. Add Filter Button
          IconButton.filledTonal(
            onPressed: () => controller.showAddFilterMenu(context),
            icon: Icon(AppIcons.common.add, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
