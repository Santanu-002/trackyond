import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';

class FilterInlineOperatorDropdown extends StatelessWidget {
  final LogicalOperator value;
  final ValueChanged<LogicalOperator?> onChanged;

  const FilterInlineOperatorDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.theme.colorScheme.outlineVariant)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.theme.colorScheme.outlineVariant),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LogicalOperator>(
                value: value,
                isDense: true,
                onChanged: onChanged,
                items: LogicalOperator.values.map((op) {
                  return DropdownMenuItem(
                    value: op,
                    child: Text(
                      op.name.toUpperCase(),
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(child: Divider(color: context.theme.colorScheme.outlineVariant)),
        ],
      ),
    );
  }
}
