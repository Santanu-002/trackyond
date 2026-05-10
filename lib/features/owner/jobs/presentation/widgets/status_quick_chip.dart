import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/job_quick_filter_chip.dart';

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
      return JobQuickFilterChip(
        label: label,
        isSelected: isSelected,
        onTap: () => controller.setStatus(isSelected ? null : status),
      );
    });
  }
}
