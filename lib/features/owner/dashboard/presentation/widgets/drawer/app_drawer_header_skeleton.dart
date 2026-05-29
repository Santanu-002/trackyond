import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_shimmer.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_avatar.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_text.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppDrawerHeaderSkeleton extends StatelessWidget {
  const AppDrawerHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = context.mediaQueryPadding.top;

    return AppShimmer(
      child: Container(
        padding: EdgeInsets.only(
          left: AppUIConstants.spacing.space$24,
          right: AppUIConstants.spacing.space$24,
          top: topPadding + AppUIConstants.spacing.space$16,
          bottom: AppUIConstants.spacing.space$16,
        ),
        child: Row(
          spacing: AppUIConstants.spacing.space$16,
          children: [
            const AppSkeletonAvatar(size: 56), // radius 28 = size 56
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSkeletonText(width: 120, variant: AppSkeletonTextVariant.title),
                  SizedBox(height: 8),
                  AppSkeletonText(width: 100, variant: AppSkeletonTextVariant.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
