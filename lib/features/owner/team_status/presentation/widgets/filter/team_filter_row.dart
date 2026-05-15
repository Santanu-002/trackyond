import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip_row.dart';
import 'package:trackyond/core/common/widgets/chip/app_sort_chip.dart';
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
          return AppSortChip(
            isDescending: controller.selectedOrder.value == 'desc',
            descendingLabel: AppStrings.teamStatus.newest,
            ascendingLabel: AppStrings.teamStatus.oldest,
            onToggle: () => controller.setOrder(
              controller.selectedOrder.value == 'desc' ? 'asc' : 'desc',
            ),
          );
        }),
      ],
    );
  }
}

