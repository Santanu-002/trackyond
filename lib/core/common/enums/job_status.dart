import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

enum JobStatus {
  pending('pending'),
  assigned('assigned'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  final String value;
  const JobStatus(this.value);

  static JobStatus fromString(String? status) {
    if (status == null) return JobStatus.pending;
    
    return switch (status.toLowerCase()) {
      'pending' => JobStatus.pending,
      'assigned' => JobStatus.assigned,
      'inprogress' || 'in_progress' => JobStatus.inProgress,
      'completed' => JobStatus.completed,
      'cancelled' => JobStatus.cancelled,
      _ => JobStatus.pending,
    };
  }

  String toJson() => value;

  String label(BuildContext context) {
    return switch (this) {
      JobStatus.pending => AppStrings.jobs.pending,
      JobStatus.assigned => AppStrings.jobs.assigned,
      JobStatus.inProgress => AppStrings.jobs.inProgress,
      JobStatus.completed => AppStrings.jobs.completed,
      JobStatus.cancelled => AppStrings.jobs.cancelled,
    };
  }

  Color color(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return switch (this) {
      JobStatus.pending => colorScheme.pending,
      JobStatus.assigned => colorScheme.pending, // Using pending color for assigned
      JobStatus.inProgress => colorScheme.inProgress,
      JobStatus.completed => colorScheme.completed,
      JobStatus.cancelled => colorScheme.cancelled,
    };
  }
}
