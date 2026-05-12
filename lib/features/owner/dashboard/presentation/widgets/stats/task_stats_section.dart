import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/task_stat_config.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/stats/stats_card.dart';

class TaskStatsSection extends StatelessWidget {
  final List<TaskStatConfig> stats;
  final bool isLoading;

  const TaskStatsSection({
    super.key,
    required this.stats,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.ownerDashboard;

    return AppSection(
      title: strings.statsTitle,
      childPadding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$16,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
          final spacing = AppUIConstants.spacing.space$12;
          final cardWidth =
              (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                  crossAxisCount;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: stats.map((stat) {
              return SizedBox(
                width: cardWidth,
                child: StatsCard(
                  title: stat.label,
                  value: stat.value.toString(),
                  icon: stat.icon,
                  color: stat.color,
                  isLoading: isLoading,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
