import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class ReplyImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final String? blurHash;
  final int remainingCount;
  final double size;
  final double borderRadius;
  final bool isVideo;

  const ReplyImageThumbnail({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.remainingCount = 0,
    this.size = 30.0,
    this.borderRadius = 2.0,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final MemoryImage? decodedHashProvider = (blurHash != null && blurHash!.isNotEmpty)
        ? AppImage.getBlurHashProvider(blurHash!)
        : null;

    Widget backgroundWidget;
    if (isVideo) {
      if (decodedHashProvider != null) {
        backgroundWidget = Image(
          image: decodedHashProvider,
          fit: BoxFit.cover,
        );
      } else {
        backgroundWidget = Container(
          color: colorScheme.surfaceContainerHighest,
        );
      }
    } else {
      backgroundWidget = AppImage(
        imageUrl: imageUrl,
        blurHash: blurHash,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
          color: colorScheme.surfaceDim,
          child: const Center(child: Icon(Icons.error_outline, size: 14)),
        ),
      );
    }

    Widget displayWidget = backgroundWidget;

    if (remainingCount > 0) {
      displayWidget = Stack(
        fit: StackFit.expand,
        children: [
          backgroundWidget,
          Container(
            color: colorScheme.black.withValues(alpha: 0.6),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (isVideo) {
      displayWidget = Stack(
        fit: StackFit.expand,
        children: [
          backgroundWidget,
          Center(
            child: Icon(
              Icons.play_circle_outline_rounded,
              color: colorScheme.onPrimary,
              size: size * 0.6,
            ),
          ),
        ],
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: displayWidget,
      ),
    );
  }
}
