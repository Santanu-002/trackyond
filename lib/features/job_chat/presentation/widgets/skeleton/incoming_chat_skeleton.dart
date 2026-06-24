import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_avatar.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class IncomingChatSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final bool showAvatar;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const IncomingChatSkeleton({
    super.key,
    required this.width,
    required this.height,
    required this.showAvatar,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    final double softRadius = AppUIConstants.radius.radius$16;
    final double hardRadius = 2.0;

    final double topLeft = hasSameSenderAbove ? hardRadius : softRadius;
    final double bottomLeft = hasSameSenderBelow ? hardRadius : softRadius;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAvatar)
          const AppSkeletonAvatar(size: 28)
        else
          const SizedBox(width: 28),
        AppUIConstants.widgets.horizontalBox$8,
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeft),
              bottomLeft: Radius.circular(bottomLeft),
              topRight: Radius.circular(softRadius),
              bottomRight: Radius.circular(softRadius),
            ),
          ),
        ),
      ],
    );
  }
}
