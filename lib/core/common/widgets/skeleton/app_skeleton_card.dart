import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_container.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppSkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppSkeletonCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkeletonContainer(
      width: width ?? double.infinity,
      height: height ?? 100,
      borderRadius: borderRadius ?? AppUIConstants.radius.radius$16,
      margin: margin,
    );
  }
}
