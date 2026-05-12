import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
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
                AppIcons.jobs.filterOff,
                size: 48,
                color: context.theme.colorScheme.outline,
              ),
              AppUIConstants.widgets.verticalBox$12,
              Text(
                AppStrings.jobs.noFiltersApplied,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.jobs.filterLogic, style: context.textTheme.titleMedium),
          AppUIConstants.widgets.verticalBox$12,
          ...LogicalOperator.values.map((op) {
            final currentOp = controller.filter.value.advancedFilter.logicalOperator;
            final isSelected = currentOp == op;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(op.label, style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : null,
                )),
                subtitle: Text(op.description, style: context.textTheme.bodySmall),
                trailing: isSelected
                    ? Icon(
                        AppIcons.common.checkCircle,
                        color: context.theme.colorScheme.primary,
                        size: 20,
                      )
                    : null,
                onTap: () => controller.setLogicalOperator(op),
                selected: isSelected,
                selectedTileColor: context.theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppUIConstants.radius.radius$12,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? context.theme.colorScheme.primary
                        : context.theme.colorScheme.outlineVariant,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                dense: true,
              ),
            );
          }),
          AppUIConstants.widgets.verticalBox$16,
          const Divider(),
          AppUIConstants.widgets.verticalBox$16,
          Expanded(
            child: ListView.separated(
              itemCount: rules.length,
              separatorBuilder: (context, index) {
                final op =
                    operators.length > index ? operators[index] : LogicalOperator.or;
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
            ),
          ),
        ],
      );
    });
  }
}
