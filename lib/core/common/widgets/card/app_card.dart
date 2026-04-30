import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppUIConstants.spacing.space$16),
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
