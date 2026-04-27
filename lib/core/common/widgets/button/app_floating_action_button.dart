import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? icon;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            context.theme.colorScheme.primary,
            context.theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: const GradientRotation(2.35619), // 135 degrees
        ),
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: icon ??
                Icon(
                  Icons.add_rounded,
                  color: context.theme.colorScheme.onPrimary,
                  size: 28,
                ),
          ),
        ),
      ),
    );
  }
}
