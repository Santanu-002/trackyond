import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/utils/file_type_icon_resolver.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailItem extends StatefulWidget {
  final int index;
  final String path;
  final bool isActive;
  final bool isLoading;
  final ColorScheme colorScheme;
  final MediaPreviewType previewType;
  final VoidCallback onTap;

  const ThumbnailItem({
    super.key,
    required this.index,
    required this.path,
    required this.isActive,
    required this.isLoading,
    required this.colorScheme,
    required this.previewType,
    required this.onTap,
  });

  @override
  State<ThumbnailItem> createState() => _ThumbnailItemState();
}

class _ThumbnailItemState extends State<ThumbnailItem> {
  String? _thumbnailPath;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _generateThumbnailIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ThumbnailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _generateThumbnailIfNeeded();
    }
  }

  Future<void> _generateThumbnailIfNeeded() async {
    if (widget.previewType != MediaPreviewType.video) {
      if (mounted) setState(() => _thumbnailPath = null);
      return;
    }

    if (_isGenerating) return;

    if (mounted) setState(() => _isGenerating = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video: widget.path,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 128,
        quality: 75,
      );
      if (mounted) {
        setState(() {
          _thumbnailPath = thumbPath;
          _isGenerating = false;
        });
      }
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileTypeInfo =
        FileTypeIconResolver.resolve(widget.path, widget.colorScheme);
    final docIcon = fileTypeInfo.icon;
    final docIconColor = fileTypeInfo.color;

    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: EdgeInsets.only(right: AppUIConstants.spacing.space$8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
          border: Border.all(
            color: widget.isActive
                ? widget.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppUIConstants.radius.radius$12 - 2,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Video ──────────────────────────────────────────────────────
              if (widget.previewType == MediaPreviewType.video) ...[
                if (_thumbnailPath != null)
                  Image.file(File(_thumbnailPath!), fit: BoxFit.cover)
                else
                  Container(color: widget.colorScheme.surfaceContainerHighest),
                Center(
                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    color: widget.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
              ]

              // ── Document / PDF ─────────────────────────────────────────────
              else if (widget.previewType == MediaPreviewType.document ||
                  widget.previewType == MediaPreviewType.pdf) ...[
                Center(
                  child: docIcon is FaIconData
                      ? FaIcon(docIcon, color: docIconColor, size: 28)
                      : Icon(
                          docIcon as IconData,
                          color: docIconColor,
                          size: 28,
                        ),
                ),
              ]

              // ── Image ──────────────────────────────────────────────────────
              else
                Image.file(File(widget.path), fit: BoxFit.cover),

              // ── Inactive dim overlay ───────────────────────────────────────
              if (!widget.isActive)
                Container(
                  color: widget.colorScheme.black.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
