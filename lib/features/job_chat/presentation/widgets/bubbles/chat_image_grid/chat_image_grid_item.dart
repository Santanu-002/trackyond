import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/screens/media_viewer_page.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/bubble_time_and_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/chat_image_grid/video_thumbnail_widget.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/utils/app_utils.dart';

import 'package:trackyond/core/network/api/api_endpoints.dart';

class ChatImageGridItem extends StatelessWidget {
  final int index;
  final JobChatMessageEntity message;
  final List<JobChatMessageContentEntity> imageContents;
  final bool isLast;
  final double imageRadius;
  final bool showTimeOverlay;

  const ChatImageGridItem({
    super.key,
    required this.index,
    required this.message,
    required this.imageContents,
    this.isLast = false,
    required this.imageRadius,
    this.showTimeOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = imageContents[index];
    final path = content.content ?? '';
    final url = path.startsWith('http') ? path : ApiEndpoints.common.download(path);
    final isVideo = content.type == JobChatMessageContentType.video;

    double? imageWidth;
    double? imageHeight;
    String? blurHash;

    int? durationSec;
    if (isVideo) {
      final dynamic videoMeta = content.metadata?['videoMetadata'];
      final double? videoAspectRatio = (videoMeta is Map ? videoMeta['aspectRatio'] : content.metadata?['aspectRatio'])?.toDouble();
      blurHash = (videoMeta is Map ? videoMeta['thumbnailBlurHash'] : null) ?? content.metadata?['thumbnailBlurHash'] as String?;
      durationSec = (videoMeta is Map ? videoMeta['duration'] : content.metadata?['duration'])?.toInt();
      if (videoAspectRatio != null && videoAspectRatio > 0) {
        imageWidth = videoAspectRatio;
        imageHeight = 1.0;
      }
    } else {
      final dynamic imageMeta = content.metadata?['imageMetadata'];
      imageWidth = (imageMeta is Map ? imageMeta['width'] : content.metadata?['width'])?.toDouble();
      imageHeight = (imageMeta is Map ? imageMeta['height'] : content.metadata?['height'])?.toDouble();
      blurHash = (imageMeta is Map ? imageMeta['blurHash'] : null) ??
          content.metadata?['blurHash'] as String? ??
          content.metadata?['blur_hash'] as String?;
    }

    final colorScheme = context.colorScheme;

    Widget img;
    if (isVideo) {
      img = VideoThumbnailWidget(
        videoUrl: url,
        blurHash: blurHash,
        width: imageContents.length == 1 ? imageWidth : null,
        height: imageContents.length == 1 ? imageHeight : null,
        fit: BoxFit.cover,
      );
    } else {
      img = AppImage(
        imageUrl: url,
        blurHash: blurHash,
        imageWidth: imageContents.length == 1 ? imageWidth : null,
        imageHeight: imageContents.length == 1 ? imageHeight : null,
        fit: BoxFit.cover,
        matchAspectRatio: imageContents.length == 1,
      );
    }

    if (isLast && imageContents.length > 4) {
      final remaining = imageContents.length - 4;
      img = Stack(
        fit: StackFit.expand,
        children: [
          img,
          Container(
            color: colorScheme.black.withValues(alpha: 0.6),
            child: Center(
              child: Text(
                '+$remaining',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        final routeArgs = {
          'imageUrls': imageContents.map((c) => c.content ?? c.metadata?['url'] as String? ?? '').toList(),
          'blurHashes': imageContents.map((c) {
            if (c.type == JobChatMessageContentType.video) {
              final dynamic videoMeta = c.metadata?['videoMetadata'];
              return (videoMeta is Map ? videoMeta['thumbnailBlurHash'] : null) ?? c.metadata?['thumbnailBlurHash'] as String?;
            } else {
              final dynamic imageMeta = c.metadata?['imageMetadata'];
              return (imageMeta is Map ? imageMeta['blurHash'] : null) ??
                  c.metadata?['blurHash'] as String? ??
                  c.metadata?['blur_hash'] as String?;
            }
          }).toList(),
          'contentTypes': imageContents.map((c) => c.type.value).toList(),
          'initialIndex': index,
          'messageUid': message.uid,
          'message': message,
        };

        Navigator.push(
          context,
          TransparentPageRoute(
            builder: (context) => const MediaViewerPage(),
            settings: RouteSettings(arguments: routeArgs),
          ),
        );
      },
      child: Hero(
        tag: 'image_${message.uid}_$index',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(imageRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              img,
              if (showTimeOverlay || isVideo)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 6,
                      bottom: 4,
                      top: 20, // Height gradient padding
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colorScheme.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isVideo)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.videocam_rounded,
                                color: colorScheme.onPrimary,
                                size: 14,
                              ),
                              Text(
                                AppUtils.formatVideoDuration(durationSec),
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox.shrink(),
                        if (showTimeOverlay)
                          BubbleTimeAndStatus(
                            timestamp: message.timestamp,
                            isMe: message.isMe,
                            status: message.status,
                            isOverlaid: true,
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransparentPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  TransparentPageRoute({
    required this.builder,
    super.settings,
  }) : super(
          opaque: false,
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
