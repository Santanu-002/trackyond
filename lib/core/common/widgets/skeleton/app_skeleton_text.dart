import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_container.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

enum AppSkeletonTextVariant { title, subtitle, body, caption }

class AppSkeletonText extends StatelessWidget {
  final double? width;
  final AppSkeletonTextVariant variant;
  final EdgeInsetsGeometry? margin;

  const AppSkeletonText({
    super.key,
    this.width,
    this.variant = AppSkeletonTextVariant.body,
    this.margin,
  });

  double _getHeight() {
    switch (variant) {
      case AppSkeletonTextVariant.title:
        return 24.0;
      case AppSkeletonTextVariant.subtitle:
        return 18.0;
      case AppSkeletonTextVariant.body:
        return 14.0;
      case AppSkeletonTextVariant.caption:
        return 10.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSkeletonContainer(
      width: width ?? (variant == AppSkeletonTextVariant.title ? 180 : 120),
      height: _getHeight(),
      borderRadius: AppUIConstants.radius.radius$4,
      margin: margin,
    );
  }
}
