import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AddMoreButton extends StatelessWidget {
  final bool isLoading;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const AddMoreButton({
    super.key,
    required this.isLoading,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(Icons.add_rounded, color: colorScheme.onPrimary, size: 24),
      ),
    );
  }
}
