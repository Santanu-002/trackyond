import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppJobCardSkeleton extends StatelessWidget {
  const AppJobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: AppShimmer(
        child: Row(
          children: [
            const AppSkeletonContainer(width: 48, height: 48, borderRadius: 12),
            AppUIConstants.widgets.horizontalBox$12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSkeletonText(
                    variant: AppSkeletonTextVariant.title,
                    width: 120,
                  ),
                  AppUIConstants.widgets.verticalBox$4,
                  AppSkeletonText(
                    variant: AppSkeletonTextVariant.caption,
                    width: 150,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const AppSkeletonText(
                  variant: AppSkeletonTextVariant.caption,
                  width: 40,
                ),
                AppUIConstants.widgets.verticalBox$4,
                AppSkeletonContainer(width: 60, height: 20, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
