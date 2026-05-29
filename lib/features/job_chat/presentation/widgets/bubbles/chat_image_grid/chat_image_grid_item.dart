import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/screens/media_viewer_page.dart';

class ChatImageGridItem extends StatelessWidget {
  final int index;
  final JobChatMessageEntity message;
  final List<JobChatMessageContentEntity> imageContents;
  final bool isLast;
  final double imageRadius;

  const ChatImageGridItem({
    super.key,
    required this.index,
    required this.message,
    required this.imageContents,
    this.isLast = false,
    required this.imageRadius,
  });

  @override
  Widget build(BuildContext context) {
    final content = imageContents[index];
    final url = content.metadata?['url'] ?? '';
    final blurHash = content.metadata?['blurHash'] as String? ??
        content.metadata?['blur_hash'] as String?;

    final colorScheme = context.colorScheme;

    Widget img = AppImage(
      imageUrl: url,
      blurHash: blurHash,
      fit: BoxFit.cover,
    );

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
          'imageUrls': imageContents.map((c) => AppImage.getFullUrl(c.metadata?['url'] as String? ?? '')).toList(),
          'blurHashes': imageContents.map((c) => (c.metadata?['blurHash'] as String? ?? c.metadata?['blur_hash'] as String?)).toList(),
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
          child: img,
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
