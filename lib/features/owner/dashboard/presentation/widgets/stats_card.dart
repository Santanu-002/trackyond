import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isLoading;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Expanded(
      child: AppCard(
        padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppUIConstants.spacing.space$8,
          children: [
            isLoading
                ? const AppShimmer(
                    child: AppSkeletonContainer(
                      width: 36,
                      height: 36,
                      borderRadius: 12,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.spacing.space$4,
              children: [
                isLoading
                    ? const AppShimmer(
                        child: AppSkeletonText(
                          variant: AppSkeletonTextVariant.title,
                          width: 40,
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                isLoading
                    ? const AppShimmer(
                        child: AppSkeletonText(
                          variant: AppSkeletonTextVariant.caption,
                          width: 60,
                        ),
                      )
                    : Text(
                        title,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
