import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

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

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.shimmerBase,
      highlightColor: theme.colorScheme.shimmerHighlight,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}
