import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/chat_image_grid/chat_image_grid_item.dart';

class ChatImageGrid extends StatelessWidget {
  final JobChatMessageEntity message;
  final List<JobChatMessageContentEntity> imageContents;
  final bool isMe;
  final double? width;

  const ChatImageGrid({
    super.key,
    required this.message,
    required this.imageContents,
    required this.isMe,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = imageContents.length > 4 ? 4 : imageContents.length;

    final double rowHeight = 118.0;
    final double spacing = AppUIConstants.spacing.space$4;
    final double imageRadius = AppUIConstants.radius.radius$16 - 2.0;

    if (displayCount == 1) {
      final fileMetadata =
          imageContents[0].metadata?['fileMetadata'] as Map<String, dynamic>?;
      final imageMetadata =
          fileMetadata?['imageMetadata'] as Map<String, dynamic>?;
      final imgWidth =
          (imageMetadata?['width'] ?? imageContents[0].metadata?['width']) as num?;
      final imgHeight =
          (imageMetadata?['height'] ?? imageContents[0].metadata?['height'])
              as num?;

      final imgWidget = ChatImageGridItem(
        index: 0,
        message: message,
        imageContents: imageContents,
        imageRadius: imageRadius,
      );

      if (imgWidth != null && imgHeight != null && imgHeight > 0) {
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
