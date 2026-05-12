import 'package:flutter/material.dart';
import 'package:trackyond/core/common/enums/job_status.dart';

class JobFilterChip extends StatelessWidget {
  final JobStatus? status;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const JobFilterChip({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(status == null
          ? 'All'
          : status!.name[0].toUpperCase() + status!.name.substring(1)),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
    );
  }
}
