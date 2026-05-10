import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';

class TeamStatusFilterChip extends GetView<TeamStatusController> {
  final String label;
  final AttendanceStatus? status;

  const TeamStatusFilterChip({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      return ChoiceChip(
        label: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? context.theme.colorScheme.onPrimary
                : context.theme.colorScheme.onSurfaceVariant,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            HapticFeedback.lightImpact();
            controller.setStatusFilter(status);
            // Auto-scroll to make the chip visible
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.5,
            );
          }
        },
        pressElevation: 0,
      );
    });
  }
}
