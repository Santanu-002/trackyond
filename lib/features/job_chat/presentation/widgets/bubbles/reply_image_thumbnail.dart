import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class ReplyImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final String? blurHash;
  final int remainingCount;
  final double size;
  final double borderRadius;

  const ReplyImageThumbnail({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.remainingCount = 0,
    this.size = 30.0,
    this.borderRadius = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    Widget img = AppImage(
      imageUrl: imageUrl,
      blurHash: blurHash,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        color: colorScheme.surfaceDim,
        child: const Center(child: Icon(Icons.error_outline, size: 14)),
      ),
    );

    if (remainingCount > 0) {
      img = Stack(
        fit: StackFit.expand,
        children: [
          img,
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
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: img,
      ),
    );
  }
}
