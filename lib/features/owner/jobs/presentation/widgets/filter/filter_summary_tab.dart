import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_inline_operator_dropdown.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_rule_summary_card.dart';

class FilterSummaryTab extends StatelessWidget {
  final JobsController controller;
  const FilterSummaryTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rules = controller.filter.value.advancedFilter.rules;
      final operators = controller.filter.value.advancedFilter.operators;

      if (rules.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_list_off_rounded,
                size: 48,
                color: context.theme.colorScheme.outline,
              ),
              AppUIConstants.widgets.verticalBox$12,
              Text(
                'No filters applied',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: rules.length,
        separatorBuilder: (context, index) {
          final op = operators.length > index ? operators[index] : LogicalOperator.and;
          return FilterInlineOperatorDropdown(
            value: op,
            onChanged: (newOp) => controller.updateOperator(index, newOp!),
          );
        },
        itemBuilder: (context, index) {
          final rule = rules[index];
          return FilterRuleSummaryCard(
            rule: rule,
            onDelete: () => controller.removeRule(index),
            controller: controller,
          );
        },
      );
    });
  }
}
