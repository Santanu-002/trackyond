import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/team_status_filter_chip.dart';

class TeamFilterRow extends StatelessWidget {
  const TeamFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamStatusController>();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: TeamStatusController.filters.length,
              separatorBuilder: (context, index) =>
                  AppUIConstants.widgets.horizontalBox$8,
              itemBuilder: (context, index) {
                final filter = TeamStatusController.filters[index];
                return TeamStatusFilterChip(
                  label: filter.label,
                  status: filter.status,
                );
              },
            ),
          ),
        ),
        AppUIConstants.widgets.horizontalBox$12,
        Obx(() {
          final isSelected = controller.selectedOrder.value == 'desc';
          return ActionChip(
            label: Text(
              isSelected ? 'Newest' : 'Oldest',
              style: TextStyle(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              controller.setOrder(
                controller.selectedOrder.value == 'desc' ? 'asc' : 'desc',
              );
            },
            avatar: Icon(
              controller.selectedOrder.value == 'desc'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 16,
              color: context.theme.colorScheme.primary,
            ),
            side: BorderSide(color: context.theme.colorScheme.primary.withValues(alpha: 0.2)),
          );
        }),
      ],
    );
  }
}
