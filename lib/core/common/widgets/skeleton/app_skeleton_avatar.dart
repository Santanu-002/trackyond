import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_container.dart';

class AppSkeletonAvatar extends StatelessWidget {
  final double size;
  final BoxShape shape;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppSkeletonAvatar({
    super.key,
    this.size = 48,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkeletonContainer(
      width: size,
      height: size,
      shape: shape,
      borderRadius: borderRadius,
      margin: margin,
    );
  }
}
