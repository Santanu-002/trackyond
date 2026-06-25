import 'package:flutter/material.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/types/chat_image_grid/chat_image_grid_item.dart';

/// Lays out 1–4 media items in the appropriate grid configuration.
///
/// Extracted from [ChatImageGrid._buildGrid] to keep the parent widget focused
/// on pending/upload overlay logic.
class ChatImageGridLayout extends StatelessWidget {
  final JobChatMessageEntity message;
  final List<JobChatMessageContentEntity> imageContents;
  final double imageRadius;
  final double rowHeight;
  final double spacing;
  final double? width;
  final bool showTimeOverlay;

  const ChatImageGridLayout({
    super.key,
    required this.message,
    required this.imageContents,
    required this.imageRadius,
    required this.rowHeight,
    required this.spacing,
    this.width,
    this.showTimeOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = imageContents.length > 4 ? 4 : imageContents.length;

    if (displayCount == 1) {
      return _buildSingleItem();
    }

    if (displayCount == 2) {
      return _buildTwoItems();
    }

    if (displayCount == 3) {
      return _buildThreeItems();
    }

    // displayCount == 4 (4 or more images)
    return _buildFourItems();
  }

  Widget _buildSingleItem() {
    final content = imageContents[0];
    final isVideo = content.type == JobChatMessageContentType.video;
    double? imgWidth;
    double? imgHeight;
    double? videoAspectRatio;

    if (isVideo) {
      final videoMetadata =
          content.metadata?['videoMetadata'] as Map<String, dynamic>?;
      videoAspectRatio = (videoMetadata?['aspectRatio'] ??
              content.metadata?['aspectRatio'])
          ?.toDouble();
    } else {
      final imageMetadata =
          content.metadata?['imageMetadata'] as Map<String, dynamic>?;
      imgWidth =
          (imageMetadata?['width'] ?? content.metadata?['width'])?.toDouble();
      imgHeight =
          (imageMetadata?['height'] ?? content.metadata?['height'])?.toDouble();
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
        width: width ?? 240,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: imgWidget,
        ),
      );
    }
  }

  Widget _buildTwoItems() {
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

  Widget _buildThreeItems() {
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

  Widget _buildFourItems() {
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
