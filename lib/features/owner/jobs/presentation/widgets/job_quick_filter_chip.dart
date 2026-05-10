import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobQuickFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const JobQuickFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: isSelected ? Get.theme.colorScheme.primaryContainer : null,
      labelStyle: TextStyle(
        color: isSelected ? Get.theme.colorScheme.onPrimaryContainer : null,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }
}
