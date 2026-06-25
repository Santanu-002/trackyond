import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
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

    if (isPending) {
      return Obx(() {
        final isUploading = chatController.uploadingMedia.contains(message.uid);
        final isPendingInQueue = chatController.pendingUploads.contains(message.uid);
        final isFailed = chatController.failedUploads.contains(message.uid);
        final uploadProgress = chatController.uploadProgressMap[message.uid];
        final uploadError = chatController.uploadErrorMap[message.uid];

        final shouldShowRetry = isFailed || uploadError != null || (!isUploading && !isPendingInQueue);

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
                width: imageContents.length > 2 ? double.infinity : width,
                showTimeOverlay: showTimeOverlay,
              ),
              if (shouldShowRetry)
                Center(
                  child: Material(
                    color: context.theme.colorScheme.surface,
                    shadowColor: context.theme.colorScheme.shadow.withValues(alpha: 0.2),
                    elevation: 2,
                    borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$32),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$32),
                      onTap: () => chatController.retryMessageUpload(message.uid),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppUIConstants.spacing.space$20,
                          vertical: AppUIConstants.spacing.space$12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              AppIcons.common.upload,
                              color: context.theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            AppUIConstants.widgets.horizontalBox$8,
                            Text(
                              AppStrings.common.retry,
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.all(AppUIConstants.spacing.space$2),
                            child: CircularProgressIndicator(
                              value: uploadProgress,
                              color: context.theme.colorScheme.primary,
                              backgroundColor: Colors.transparent,
                              strokeWidth: 3.0,
                            ),
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
                            onTap: () => chatController.cancelMessageUpload(message.uid),
                            child: SizedBox.expand(
                              child: Center(
                                child: Icon(
                                  AppIcons.common.close,
                                  color: context.theme.colorScheme.onSurface,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
        width: width,
        showTimeOverlay: showTimeOverlay,
      );
    }
  }
}
