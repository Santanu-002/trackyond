import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class StatusQuickChip extends GetView<JobsController> {
  final String label;
  final JobStatus status;
  const StatusQuickChip({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.isStatusSelected(status);
      return AppFilterChip(
        label: label,
        isSelected: isSelected,
        onTap: () => controller.setStatus(status),
      );
    });
  }
}
