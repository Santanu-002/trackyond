import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppSkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const AppSkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(
                borderRadius ?? AppUIConstants.radius.radius$12,
              )
            : null,
      ),
    );
  }
}
