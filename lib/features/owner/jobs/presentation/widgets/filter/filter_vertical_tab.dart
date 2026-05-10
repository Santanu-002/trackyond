import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterVerticalTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterVerticalTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? context.theme.colorScheme.surface : Colors.transparent,
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: context.theme.colorScheme.primary,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? context.theme.colorScheme.primary
                : context.theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
