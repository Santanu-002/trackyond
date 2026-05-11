import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip_row.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';

class TeamFilterRow extends GetView<TeamStatusController> {
  const TeamFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            // Read the reactive value here so GetX tracks it within this Obx scope.
            // The ScrollablePositionedList calls itemBuilder lazily (outside Obx scope),
            // so we must capture the value upfront and pass a plain closure down.
            final currentStatus = controller.selectedStatus.value;
            return AppFilterChipRow.fromEntityList(
              items: controller.filterEntities,
              isSelected: (index) =>
                  currentStatus == controller.filterEntities[index].value,
            );
          }),
        ),
        AppUIConstants.widgets.horizontalBox$12,
        Obx(() {
          // Capture reactive value in the Obx scope.
          final isDesc = controller.selectedOrder.value == 'desc';
          return ActionChip(
            label: Text(
              isDesc ? AppStrings.teamStatus.newest : AppStrings.teamStatus.oldest,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              controller.setOrder(isDesc ? 'asc' : 'desc');
            },
            avatar: Icon(
              isDesc ? AppIcons.common.arrowDown : AppIcons.common.arrowUp,
              size: 16,
              color: context.theme.colorScheme.primary,
            ),
            side: BorderSide(
              color: context.theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          );
        }),
      ],
    );
  }
}

