import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/types/chat_image_grid/chat_image_grid_layout.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/core/common/enums/job_chat_message_status.dart';

class ChatImageGrid extends StatelessWidget {
  final JobChatMessageEntity message;
  final List<JobChatMessageContentEntity> imageContents;
  final bool isMe;
  final double? width;
  final bool showTimeOverlay;

  const ChatImageGrid({
    super.key,
    required this.message,
    required this.imageContents,
    required this.isMe,
    this.width,
    this.showTimeOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final double rowHeight = 118.0;
    final double spacing = AppUIConstants.spacing.space$4;
    final double imageRadius = AppUIConstants.radius.radius$16 - 2.0;

    final chatController = Get.find<JobChatController>();
    final isPending = message.status == JobChatMessageStatus.pending;

    if (isPending && imageContents.length > 2) {
      return Obx(() {
        final uploadProgress = chatController.uploadProgressMap[message.uid];
        final uploadError = chatController.uploadErrorMap[message.uid];

        return ClipRRect(
          borderRadius: BorderRadius.circular(imageRadius),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ChatImageGridLayout(
                message: message,
                imageContents: imageContents,
                imageRadius: imageRadius,
                rowHeight: rowHeight,
                spacing: spacing,
                skipPendingOverlay: true,
                width: width,
                showTimeOverlay: showTimeOverlay,
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
              if (uploadError != null)
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Red border for error state
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircularProgressIndicator(
                            value: 1.0,
                            color: Colors.red.shade600,
                            strokeWidth: 3.5,
                          ),
                        ),
                      ),
                      // Retry/Refresh button in center
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(26),
                          onTap: () => chatController.retryMessageUpload(message.uid),
                          child: const SizedBox.expand(
                            child: Center(
                              child: Icon(
                                Icons.refresh_rounded,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Tiny close badge at top right to allow cancellation
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () => chatController.cancelMessageUpload(message.uid),
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.black87,
                              size: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Green progress indicator wrapped around the border
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircularProgressIndicator(
                            value: uploadProgress ?? 0.0,
                            color: const Color(0xFF0F9D58), // Clean vibrant green
                            backgroundColor: Colors.transparent, // No grey background track
                            strokeWidth: 3.5,
                          ),
                        ),
                      ),
                      // Close/Cancel button in the center
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(26),
                          onTap: () => chatController.cancelMessageUpload(message.uid),
                          child: const SizedBox.expand(
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.black87,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      });
    } else {
      return ChatImageGridLayout(
        message: message,
        imageContents: imageContents,
        imageRadius: imageRadius,
        rowHeight: rowHeight,
        spacing: spacing,
        skipPendingOverlay: false,
        width: width,
        showTimeOverlay: showTimeOverlay,
      );
    }
  }
}
