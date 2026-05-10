import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A premium switch widget that follows the project's design system.
/// It can be used as a standalone switch or as a form row with title and subtitle.
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeTrackColor;
  final Color? activeThumbColor;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.activeTrackColor,
    this.activeThumbColor,
  }) : assert(
          subtitle == null || title != null,
          'Subtitle cannot be present without a title',
        );

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeTrackColor: activeTrackColor ?? context.theme.colorScheme.primary,
      activeThumbColor: activeThumbColor ?? context.theme.colorScheme.onPrimary,
    );

    if (title == null) {
      return switchWidget;
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
        switchWidget,
      ],
    );
  }
}
