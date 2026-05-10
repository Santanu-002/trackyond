import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

/// A base wrapper for shimmering effects that adapts to the current theme.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// A granular rectangular skeleton box with custom shape and size.
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
        color: Colors.white,
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

/// A specialized skeleton for avatars.
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

/// A specialized skeleton for text with variants.
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

/// A specialized skeleton for buttons.
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
      borderRadius: borderRadius ?? AppUIConstants.radius.radius$32, // Pill by default
      margin: margin,
    );
  }
}

/// A skeleton card that mimics a standard app card.
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

