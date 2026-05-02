import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/stats_card.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';

class TeamStatsSummary extends GetView<TeamStatusController> {
  const TeamStatsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.teamStatus;
    
    return Row(
      spacing: AppUIConstants.spacing.space$12,
      children: [
        Obx(() => StatsCard(
              title: strings.working,
              value: controller.stats.value.working.toString(),
              icon: AppIcons.dashboard.active,
              color: context.theme.colorScheme.completed,
            )),
        Obx(() => StatsCard(
              title: strings.inactive,
              value: controller.stats.value.notStarted.toString(),
              icon: AppIcons.dashboard.timer,
              color: context.theme.colorScheme.pending,
            )),
        Obx(() => StatsCard(
              title: strings.total,
              value: controller.stats.value.total.toString(),
              icon: AppIcons.common.groups,
              color: context.theme.colorScheme.primary,
            )),
      ],
    );
  }
}
