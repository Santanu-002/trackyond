import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_container.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppSkeletonButton extends StatelessWidget {
  final double? width;
  final double height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppSkeletonButton({
    super.key,
    this.width = 120,
    this.height = 44,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkeletonContainer(
      width: width,
      height: height,
      borderRadius: borderRadius ?? AppUIConstants.radius.radius$32,
      margin: margin,
    );
  }
}
