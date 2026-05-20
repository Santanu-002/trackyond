import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class HeaderCard extends StatelessWidget {
  final Widget child;

  const HeaderCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppUIConstants.spacing.space$16,
              vertical: AppUIConstants.spacing.space$8,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
              border: Border.all(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

