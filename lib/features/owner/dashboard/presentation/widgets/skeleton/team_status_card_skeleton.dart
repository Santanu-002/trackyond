import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class TeamStatusCardSkeleton extends StatelessWidget {
  const TeamStatusCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 110,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppUIConstants.spacing.space$8,
          horizontal: AppUIConstants.spacing.space$12,
        ),
        child: AppShimmer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppUIConstants.spacing.space$4,
            children: [
              const AppSkeletonAvatar(size: 40),
              const AppSkeletonText(width: 70, variant: AppSkeletonTextVariant.body),
              const AppSkeletonContainer(
                width: 60,
                height: 20,
                borderRadius: 10,
              ),
              const AppSkeletonText(width: 50, variant: AppSkeletonTextVariant.caption),
            ],
          ),
        ),
      ),
    );
  }
}
