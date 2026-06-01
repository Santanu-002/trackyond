import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final String? blurHash;
  final BoxFit fit;
  final double? width;
  final double? height;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    this.blurHash,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  static final Map<String, Uint8List> _thumbnailCache = {};

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    final fullUrl = AppImage.getFullUrl(widget.videoUrl);
    if (VideoThumbnailWidget._thumbnailCache.containsKey(fullUrl)) {
      if (mounted) {
        setState(() {
          _thumbnailBytes = VideoThumbnailWidget._thumbnailCache[fullUrl];
        });
      }
      return;
    }

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: fullUrl,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 256, // Higher resolution for grid preview
        quality: 75,
      );
      if (bytes != null) {
        VideoThumbnailWidget._thumbnailCache[fullUrl] = bytes;
      }
      if (mounted) {
        setState(() {
          _thumbnailBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('Error loading video thumbnail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final MemoryImage? decodedHashProvider = (widget.blurHash != null && widget.blurHash!.isNotEmpty)
        ? AppImage.getBlurHashProvider(widget.blurHash!)
        : null;

    Widget imageWidget;
    if (_thumbnailBytes != null) {
      imageWidget = Image.memory(
        _thumbnailBytes!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
      );
    } else if (decodedHashProvider != null) {
      imageWidget = Image(
        image: decodedHashProvider,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
      );
    } else {
      imageWidget = Container(
        color: colorScheme.black.withValues(alpha: 0.12),
        width: widget.width,
        height: widget.height,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        imageWidget,
        // Play Button Overlay
        Center(
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: colorScheme.onPrimary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
