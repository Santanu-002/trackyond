import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class OutgoingChatSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const OutgoingChatSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    final double softRadius = AppUIConstants.radius.radius$16;
    final double hardRadius = 2.0;

    final double topRight = hasSameSenderAbove ? hardRadius : softRadius;
    final double bottomRight = hasSameSenderBelow ? hardRadius : softRadius;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight),
            bottomRight: Radius.circular(bottomRight),
            topLeft: Radius.circular(softRadius),
            bottomLeft: Radius.circular(softRadius),
          ),
        ),
      ),
    );
  }
}
