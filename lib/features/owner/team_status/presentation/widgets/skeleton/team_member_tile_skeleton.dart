import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class TeamMemberTileSkeleton extends StatelessWidget {
  const TeamMemberTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: AppShimmer(
        child: Row(
          children: [
            const AppSkeletonAvatar(size: 48),
            AppUIConstants.widgets.horizontalBox$12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppUIConstants.spacing.space$4,
                children: [
                  const AppSkeletonText(width: 120, variant: AppSkeletonTextVariant.body),
                  const AppSkeletonText(width: 150, variant: AppSkeletonTextVariant.caption),
                ],
              ),
            ),
            AppUIConstants.widgets.horizontalBox$8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppUIConstants.spacing.space$4,
              children: [
                const AppSkeletonContainer(
                  width: 60,
                  height: 20,
                  borderRadius: 10,
                ),
                const AppSkeletonText(width: 40, variant: AppSkeletonTextVariant.caption),
              ],
            ),
            AppUIConstants.widgets.horizontalBox$12,
            const AppSkeletonAvatar(size: 36, shape: BoxShape.circle),
          ],
        ),
      ),
    );
  }
}
