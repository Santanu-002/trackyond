import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/chat_action_button.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewTopBar extends StatelessWidget {
  final bool isDraggingTrim;
  final bool isVideo;
  final VideoPlayerController? videoController;
  final double startProgress;
  final double endProgress;
  final bool isCropping;
  final bool isLoading;
  final bool canUndo;
  final bool canRedo;
  final bool showCropOption;
  final VoidCallback onBack;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onDoneCrop;
  final VoidCallback onDelete;
  final VoidCallback onCrop;

  const MediaPreviewTopBar({
    super.key,
    required this.isDraggingTrim,
    required this.isVideo,
    this.videoController,
    required this.startProgress,
    required this.endProgress,
    required this.isCropping,
    required this.isLoading,
    required this.canUndo,
    required this.canRedo,
    required this.showCropOption,
    required this.onBack,
    required this.onUndo,
    required this.onRedo,
    required this.onDoneCrop,
    required this.onDelete,
    required this.onCrop,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$16,
            vertical: AppUIConstants.spacing.space$8,
          ),
          child: isDraggingTrim && isVideo && videoController != null && videoController!.value.isInitialized
              ? Builder(
                  builder: (context) {
                    final duration = videoController!.value.duration;
                    final startMs = (duration.inMilliseconds * startProgress).toInt();
                    final endMs = (duration.inMilliseconds * endProgress).toInt();
                    final startText = _formatDuration(Duration(milliseconds: startMs));
                    final endText = _formatDuration(Duration(milliseconds: endMs));

                    return Center(
                      child: Text(
                        '$startText - $endText',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontFeatures: const [ui.FontFeature.tabularFigures()],
                        ),
                      ),
                    );
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChatActionButton(
                      icon: Icon(
                        isCropping
                            ? Icons.arrow_back_ios_new_rounded
                            : Icons.close_rounded,
                        size: 24,
                      ),
                      onPressed: onBack,
                      disabled: isLoading,
                    ),
                    if (isCropping)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChatActionButton(
                            icon: const Icon(Icons.undo_rounded, size: 24),
                            onPressed: onUndo,
                            disabled: isLoading || !canUndo,
                          ),
                          AppUIConstants.widgets.horizontalBox$8,
                          ChatActionButton(
                            icon: const Icon(Icons.redo_rounded, size: 24),
                            onPressed: onRedo,
                            disabled: isLoading || !canRedo,
                          ),
                          AppUIConstants.widgets.horizontalBox$8,
                          ChatActionButton(
                            icon: const Icon(Icons.check_rounded, size: 24),
                            onPressed: onDoneCrop,
                            disabled: isLoading,
                            backgroundColor: colorScheme.completed,
                            iconColor: colorScheme.onPrimary,
                          ),
                        ],
                      )
                    else Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChatActionButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 24,
                            ),
                            onPressed: onDelete,
                            disabled: isLoading,
                            backgroundColor: colorScheme.error.withValues(
                              alpha: 0.8,
                            ),
                            iconColor: colorScheme.onError,
                          ),
                          if (showCropOption) ...[
                            AppUIConstants.widgets.horizontalBox$8,
                            ChatActionButton(
                              icon: const Icon(
                                Icons.crop_rounded,
                                size: 24,
                              ),
                              onPressed: onCrop,
                              disabled: isLoading,
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
