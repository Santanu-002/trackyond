import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_shimmer.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_container.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/skeleton/activity_chat_skeleton.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/skeleton/incoming_chat_skeleton.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/skeleton/outgoing_chat_skeleton.dart';

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
          IncomingChatSkeleton(
            width: maxBubbleWidth * 0.7,
            height: 44,
            showAvatar: true,
            hasSameSenderBelow: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$2), // Actual consecutive spacing

          // 3. Incoming Message (Long, consecutive) - Same sender, no Avatar, consecutive above
          IncomingChatSkeleton(
            width: maxBubbleWidth,
            height: 72,
            showAvatar: false,
            hasSameSenderAbove: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$8), // Actual non-consecutive spacing

          // 4. Outgoing Message (Short) - consecutive below
          OutgoingChatSkeleton(
            width: maxBubbleWidth * 0.6,
            height: 44,
            hasSameSenderBelow: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$2), // Actual consecutive spacing

          // 5. Outgoing Message (Long, consecutive) - consecutive above
          OutgoingChatSkeleton(
            width: maxBubbleWidth,
            height: 80,
            hasSameSenderAbove: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$16), // Actual spacing next to headers/cards

          // 6. Activity Card (Square, 60% width, consecutive-aware, has avatar)
          ActivityChatSkeleton(
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
          IncomingChatSkeleton(
            width: maxBubbleWidth * 0.8,
            height: 56,
            showAvatar: true,
          ),
          SizedBox(height: AppUIConstants.spacing.space$8), // Actual spacing

          // 9. Outgoing Message (Medium)
          OutgoingChatSkeleton(
            width: maxBubbleWidth * 0.75,
            height: 52,
          ),
        ],
      ),
    );
  }
}
