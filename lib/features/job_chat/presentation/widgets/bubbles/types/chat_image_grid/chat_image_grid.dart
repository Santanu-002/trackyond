import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/types/chat_image_grid/chat_image_grid_item.dart';

import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';

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
    final displayCount = imageContents.length > 4 ? 4 : imageContents.length;

    final double rowHeight = 118.0;
    final double spacing = AppUIConstants.spacing.space$4;
    final double imageRadius = AppUIConstants.radius.radius$16 - 2.0;

    if (displayCount == 1) {
      final content = imageContents[0];
      final isVideo = content.type == JobChatMessageContentType.video;
      double? imgWidth;
      double? imgHeight;
      double? videoAspectRatio;

      if (isVideo) {
        final videoMetadata = content.metadata?['videoMetadata'] as Map<String, dynamic>?;
        videoAspectRatio = (videoMetadata?['aspectRatio'] ?? content.metadata?['aspectRatio'])?.toDouble();
      } else {
        final imageMetadata = content.metadata?['imageMetadata'] as Map<String, dynamic>?;
        imgWidth = (imageMetadata?['width'] ?? content.metadata?['width'])?.toDouble();
        imgHeight = (imageMetadata?['height'] ?? content.metadata?['height'])?.toDouble();
      }

      final imgWidget = ChatImageGridItem(
        index: 0,
        message: message,
        imageContents: imageContents,
        imageRadius: imageRadius,
        showTimeOverlay: showTimeOverlay,
      );

      if (isVideo && videoAspectRatio != null && videoAspectRatio > 0) {
        double calculatedAspectRatio = videoAspectRatio;
        if (calculatedAspectRatio < 0.8) {
          calculatedAspectRatio = 0.8;
        }
        return SizedBox(
          width: width ?? 240,
          child: AspectRatio(
            aspectRatio: calculatedAspectRatio,
            child: imgWidget,
          ),
        );
      } else if (imgWidth != null && imgHeight != null && imgHeight > 0) {
        double calculatedAspectRatio = imgWidth / imgHeight;
        if (calculatedAspectRatio < 0.8) {
          calculatedAspectRatio = 0.8;
        }
        return SizedBox(
          width: width ?? 240,
          child: AspectRatio(
            aspectRatio: calculatedAspectRatio,
            child: imgWidget,
          ),
        );
      } else {
        return SizedBox(
          width: width ?? 200,
          height: 150,
          child: imgWidget,
        );
      }
    }

    if (displayCount == 2) {
      return SizedBox(
        width: width ?? double.infinity,
        height: rowHeight,
        child: Row(
          children: [
            Expanded(
              child: ChatImageGridItem(
                index: 0,
                message: message,
                imageContents: imageContents,
                imageRadius: imageRadius,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: ChatImageGridItem(
                index: 1,
                message: message,
                imageContents: imageContents,
                imageRadius: imageRadius,
              ),
            ),
          ],
        ),
      );
    }

    if (displayCount == 3) {
      return SizedBox(
        width: width ?? double.infinity,
        height: rowHeight * 2 + spacing,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ChatImageGridItem(
                index: 0,
                message: message,
                imageContents: imageContents,
                imageRadius: imageRadius,
              ),
            ),
            SizedBox(height: spacing),
            SizedBox(
              height: rowHeight,
              child: Row(
                children: [
                  Expanded(
                    child: ChatImageGridItem(
                      index: 1,
                      message: message,
                      imageContents: imageContents,
                      imageRadius: imageRadius,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: ChatImageGridItem(
                      index: 2,
                      message: message,
                      imageContents: imageContents,
                      imageRadius: imageRadius,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // displayCount == 4 (4 or more images)
    return SizedBox(
      width: width ?? double.infinity,
      height: rowHeight * 2 + spacing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: ChatImageGridItem(
                    index: 0,
                    message: message,
                    imageContents: imageContents,
                    imageRadius: imageRadius,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: ChatImageGridItem(
                    index: 1,
                    message: message,
                    imageContents: imageContents,
                    imageRadius: imageRadius,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing),
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: ChatImageGridItem(
                    index: 2,
                    message: message,
                    imageContents: imageContents,
                    imageRadius: imageRadius,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: ChatImageGridItem(
                    index: 3,
                    message: message,
                    imageContents: imageContents,
                    isLast: true,
                    imageRadius: imageRadius,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
