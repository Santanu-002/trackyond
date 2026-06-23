import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_shimmer.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_avatar.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_container.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class ChatSkeletonList extends StatelessWidget {
  const ChatSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final maxBubbleWidth = screenWidth * 0.60; // Max 60% of screen width

    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$16,
          vertical: AppUIConstants.spacing.space$16,
        ),
        children: [
          // 1. Date Header (Smaller width, slightly taller height)
          Center(
            child: AppSkeletonContainer(
              width: 80,
              height: 22,
              borderRadius: AppUIConstants.radius.radius$12,
              margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$16),
            ),
          ),

          // 2. Incoming Message (Short) - Has Avatar, consecutive below
          _buildIncomingBubble(
            context,
            width: maxBubbleWidth * 0.7,
            height: 44,
            showAvatar: true,
            hasSameSenderBelow: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$2), // Actual consecutive spacing

          // 3. Incoming Message (Long, consecutive) - Same sender, no Avatar, consecutive above
          _buildIncomingBubble(
            context,
            width: maxBubbleWidth,
            height: 72,
            showAvatar: false,
            hasSameSenderAbove: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$8), // Actual non-consecutive spacing

          // 4. Outgoing Message (Short) - consecutive below
          _buildOutgoingBubble(
            context,
            width: maxBubbleWidth * 0.6,
            height: 44,
            hasSameSenderBelow: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$2), // Actual consecutive spacing

          // 5. Outgoing Message (Long, consecutive) - consecutive above
          _buildOutgoingBubble(
            context,
            width: maxBubbleWidth,
            height: 80,
            hasSameSenderAbove: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$16), // Actual spacing next to headers/cards

          // 6. Activity Card (Square, 60% width, consecutive-aware, has avatar)
          _buildActivityCard(
            context,
            size: maxBubbleWidth,
            showAvatar: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$16),

          // 7. Another Date Header (Smaller width, slightly taller height)
          Center(
            child: AppSkeletonContainer(
              width: 70,
              height: 22,
              borderRadius: AppUIConstants.radius.radius$12,
              margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$16),
            ),
          ),

          // 8. Incoming Message (Medium) - Has Avatar
          _buildIncomingBubble(
            context,
            width: maxBubbleWidth * 0.8,
            height: 56,
            showAvatar: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$8), // Actual spacing

          // 9. Outgoing Message (Medium)
          _buildOutgoingBubble(
            context,
            width: maxBubbleWidth * 0.75,
            height: 52,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingBubble(
    BuildContext context, {
    required double width,
    required double height,
    required bool showAvatar,
    bool hasSameSenderAbove = false,
    bool hasSameSenderBelow = false,
  }) {
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

  Widget _buildOutgoingBubble(
    BuildContext context, {
    required double width,
    required double height,
    bool hasSameSenderAbove = false,
    bool hasSameSenderBelow = false,
  }) {
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

  Widget _buildActivityCard(
    BuildContext context, {
    required double size,
    required bool showAvatar,
    bool hasSameSenderAbove = false,
    bool hasSameSenderBelow = false,
  }) {
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
          width: size,
          height: size,
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
