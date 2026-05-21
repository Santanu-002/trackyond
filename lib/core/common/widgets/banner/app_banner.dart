import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

enum AppBannerType { info, success, destructive }

class AppBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? actionLabel;
  final AppBannerType type;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final IconData? icon;

  const AppBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.actionLabel,
    this.type = AppBannerType.info,
    this.onTap,
    this.onDismiss,
    this.icon,
  }) : assert(
          subtitle != null || subtitleWidget != null,
          'Either subtitle or subtitleWidget must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    Color bgColor;
    Color borderColor;
    Color contentColor;
    IconData defaultIcon;

    switch (type) {
      case AppBannerType.info:
        bgColor = colorScheme.primaryContainer.withValues(alpha: 0.1);
        borderColor = colorScheme.primaryContainer.withValues(alpha: 0.5);
        contentColor = colorScheme.primary;
        defaultIcon = AppIcons.status.info;
        break;
      case AppBannerType.success:
        bgColor = colorScheme.tertiary.withValues(alpha: 0.1);
        borderColor = colorScheme.tertiary.withValues(alpha: 0.5);
        contentColor = colorScheme.tertiary;
        defaultIcon = AppIcons.status.success;
        break;
      case AppBannerType.destructive:
        bgColor = colorScheme.errorContainer.withValues(alpha: 0.1);
        borderColor = colorScheme.errorContainer.withValues(alpha: 0.5);
        contentColor = colorScheme.error;
        defaultIcon = AppIcons.status.warn;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        child: Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon ?? defaultIcon,
                color: contentColor,
                size: 24,
              ),
              AppUIConstants.widgets.horizontalBox$12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppUIConstants.spacing.space$4,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: contentColor,
                      ),
                    ),
                    subtitleWidget ??
                        Text(
                          subtitle!,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                    if (onTap != null && actionLabel != null) ...[
                      AppUIConstants.widgets.verticalBox$4,
                      Text(
                        actionLabel!,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDismiss != null) ...[
                AppUIConstants.widgets.horizontalBox$8,
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    AppIcons.common.close,
                    size: 20,
                    color: contentColor,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
