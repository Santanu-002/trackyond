import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class JobsActionBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? badgeCount;
  final VoidCallback onPressed;

  const JobsActionBarButton({
    super.key,
    required this.icon,
    required this.label,
    this.badgeCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton.ghost(
      onPressed: onPressed,
      width: null,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 20),
              if (badgeCount != null)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        '$badgeCount',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.theme.colorScheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          AppUIConstants.widgets.horizontalBox$8,
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
