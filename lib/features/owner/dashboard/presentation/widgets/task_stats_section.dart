import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/task_stat_config.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/stats_card.dart';

class TaskStatsSection extends StatelessWidget {
  final List<TaskStatConfig> stats;

  const TaskStatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.ownerDashboard;

    return AppSection(
      title: strings.statsTitle,
      child: Row(
        spacing: AppUIConstants.spacing.space$12,
        children: List.generate(stats.length, (index) {
          final stat = stats[index];
          return StatsCard(
            title: stat.label,
            value: stat.value.toString(),
            icon: stat.icon,
            color: stat.color,
          );
        }),
      ),
    );
  }
}
