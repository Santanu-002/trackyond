import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color? color;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final activeColor = theme.colorScheme.primary;
    final itemColor = color ?? (isActive ? activeColor : theme.colorScheme.onSurface);

    return Stack(
      children: [
        if (isActive)
          Positioned(
            left: 0,
            top: 4,
            bottom: 4,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(AppUIConstants.radius.radius$4),
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$12,
            vertical: AppUIConstants.spacing.space$4,
          ),
          child: Theme(
            data: theme.copyWith(
              splashColor: activeColor.withValues(alpha: 0.1),
              hoverColor: activeColor.withValues(alpha: 0.05),
              highlightColor: activeColor.withValues(alpha: 0.05),
            ),
            child: ListTile(
              onTap: onTap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
              ),
              selected: isActive,
              selectedTileColor: activeColor.withValues(alpha: 0.1),
              leading: Icon(
                icon,
                color: itemColor,
                size: 24,
              ),
              title: Text(
                label,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: itemColor,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
