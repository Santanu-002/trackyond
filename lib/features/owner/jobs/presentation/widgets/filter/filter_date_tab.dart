import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';

class FilterDateTab extends StatelessWidget {
  final JobsController controller;
  const FilterDateTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.jobs.dateRange, style: context.textTheme.titleMedium),
        AppUIConstants.widgets.verticalBox$16,
        Obx(() {
          final fromDate = controller.fromDate;
          final dateRule = controller.filter.value.advancedFilter.rules
              .firstWhereOrNull((r) => r.field == JobFilterField.date);

          return AppButton.outlined(
            text: fromDate == null
                ? AppStrings.jobs.chooseDateRange
                : controller.getValueLabel(dateRule?.value),
            leading: Icon(AppIcons.common.calendarRange, size: 20),
            onPressed: () => controller.showDatePicker(),
          );
        }),
      ],
    );
  }
}
