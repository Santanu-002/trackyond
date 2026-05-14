import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/common/widgets/card/stats_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

class TaskStatsSection extends GetView<OwnerDashboardController> {
  final bool isLoading;

  const TaskStatsSection({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.ownerDashboard;

    return AppSection(
      title: strings.statsTitle,
      padding: EdgeInsets.zero,
      childPadding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$24,
      ),
      spacing: AppUIConstants.spacing.space$8,
      trailing: Obx(
        () => SegmentedButton<StatsFilter>(
          segments: [
            ButtonSegment<StatsFilter>(
              value: StatsFilter.today,
              label: Text(AppStrings.workerDashboard.today),
            ),
            ButtonSegment<StatsFilter>(
              value: StatsFilter.overall,
              label: Text(AppStrings.workerDashboard.overall),
            ),
          ],
          selected: {controller.selectedStatsFilter.value},
          onSelectionChanged: (Set<StatsFilter> newSelection) {
            controller.setStatsFilter(newSelection.first);
          },
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      child: Obx(() {
        final stats = controller.taskStats;
        return LayoutBuilder(
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
        );
      }),
    );
  }
}
