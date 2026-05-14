import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/common/widgets/card/stats_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';

class WorkerStatsSection extends GetView<WorkerDashboardController> {
  final bool isLoading;

  const WorkerStatsSection({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.workerDashboard;

    return AppSection(
      title: strings.jobStatsTitle,
      padding: EdgeInsets.zero,
      childPadding: EdgeInsets.zero,
      headerPadding: EdgeInsets.zero,
      spacing: AppUIConstants.spacing.space$8,
      trailing: Obx(
        () => SegmentedButton<StatsFilter>(
          segments: [
            ButtonSegment<StatsFilter>(
              value: StatsFilter.today,
              label: Text(strings.today, style: context.textTheme.labelSmall),
            ),
            ButtonSegment<StatsFilter>(
              value: StatsFilter.overall,
              label: Text(strings.overall, style: context.textTheme.labelSmall),
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
        final stats = controller.dashboardStats;
        final colorScheme = context.colorScheme;

        return LayoutBuilder(
          builder: (context, constraints) {
            final spacing = AppUIConstants.spacing.space$12;
            final cardWidth = (constraints.maxWidth - spacing) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: StatsCard(
                    title: strings.pending,
                    value: stats.pending.toString(),
                    icon: AppIcons.dashboard.timer,
                    color: colorScheme.pending,
                    isLoading: isLoading,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: StatsCard(
                    title: strings.inProgress,
                    value: stats.inProgress.toString(),
                    icon: AppIcons.dashboard.active,
                    color: colorScheme.inProgress,
                    isLoading: isLoading,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: StatsCard(
                    title: strings.completed,
                    value: stats.completed.toString(),
                    icon: AppIcons.dashboard.completed,
                    color: colorScheme.completed,
                    isLoading: isLoading,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: StatsCard(
                    title: strings.cancelled,
                    value: stats.cancelled.toString(),
                    icon: AppIcons.dashboard.cancelled,
                    color: colorScheme.cancelled,
                    isLoading: isLoading,
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
