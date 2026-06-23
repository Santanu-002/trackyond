import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class VideoTrimmerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final List<String> thumbnails;
  final double startProgress;
  final double endProgress;
  final bool isMuted;
  final int totalSize;
  final Function(double start, double end) onTrimChanged;
  final VoidCallback onMuteToggled;
  final ValueChanged<bool>? onDraggingChanged;

  const VideoTrimmerWidget({
    super.key,
    required this.controller,
    required this.thumbnails,
    required this.startProgress,
    required this.endProgress,
    required this.isMuted,
    required this.totalSize,
    required this.onTrimChanged,
    required this.onMuteToggled,
    this.onDraggingChanged,
  });

  @override
  State<VideoTrimmerWidget> createState() => _VideoTrimmerWidgetState();
}

class _VideoTrimmerWidgetState extends State<VideoTrimmerWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _playheadPositionNotifier = ValueNotifier<double>(0.0);
  final GlobalKey _trimbarKey = GlobalKey();

  Duration _lastKnownPosition = Duration.zero;
  DateTime _lastPositionUpdateTime = DateTime.now();
  bool _isDraggingHandles = false;
  bool _isDraggingPlayhead = false;

  late double _localStart;
  late double _localEnd;

  // Seek throttling state
  DateTime _lastSeekTime = DateTime.now();
  bool _isSeekPending = false;
  double? _pendingSeekProgress;

  bool get _isDragging => _isDraggingHandles || _isDraggingPlayhead;

  @override
  void initState() {
    super.initState();
    _localStart = widget.startProgress;
    _localEnd = widget.endProgress;
    _ticker = createTicker(_tick);
    widget.controller.addListener(_updateControllerState);
    _updateControllerState();
  }

  @override
  void didUpdateWidget(covariant VideoTrimmerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateControllerState);
      widget.controller.addListener(_updateControllerState);
    }
    // Update local progresses only when not actively dragging
    if (!_isDragging) {
      _localStart = widget.startProgress;
      _localEnd = widget.endProgress;
      _updateControllerState();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateControllerState);
    _ticker.dispose();
    _playheadPositionNotifier.dispose();
    super.dispose();
  }

  void _throttledSeek(double progress) {
    final now = DateTime.now();
    final duration = widget.controller.value.duration;
    if (duration.inMilliseconds == 0) return;

    final targetMs = (duration.inMilliseconds * progress).toInt();

    // Throttle seek calls to at most once every 60ms to avoid overloading the player decoder
    if (now.difference(_lastSeekTime) > const Duration(milliseconds: 60)) {
      widget.controller.seekTo(Duration(milliseconds: targetMs));
      _lastSeekTime = now;
      _isSeekPending = false;
    } else {
      _pendingSeekProgress = progress;
      if (!_isSeekPending) {
        _isSeekPending = true;
        Future.delayed(const Duration(milliseconds: 60), () {
          if (mounted && _isSeekPending && _pendingSeekProgress != null) {
            final finalTargetMs = (duration.inMilliseconds * _pendingSeekProgress!).toInt();
            widget.controller.seekTo(Duration(milliseconds: finalTargetMs));
            _lastSeekTime = DateTime.now();
            _isSeekPending = false;
          }
        });
      }
    }
  }

  void _updateControllerState() {
    if (_isDragging) return; // Ignore updates while user is dragging

    final isPlaying = widget.controller.value.isPlaying;
    final currentPos = widget.controller.value.position;
    final duration = widget.controller.value.duration;

    if (duration.inMilliseconds > 0) {
      final startMs = (duration.inMilliseconds * _localStart).toInt();
      final endMs = (duration.inMilliseconds * _localEnd).toInt();
      final currentPosMs = currentPos.inMilliseconds;

      // Ignore transient/seeking position updates that fall outside the active trim window
      if (currentPosMs < startMs || currentPosMs > endMs) {
        return;
      }
    }

    if (currentPos != _lastKnownPosition) {
      _lastKnownPosition = currentPos;
      _lastPositionUpdateTime = DateTime.now();
    }

    if (isPlaying) {
      if (!_ticker.isActive) {
        _lastKnownPosition = currentPos;
        _lastPositionUpdateTime = DateTime.now();
        _ticker.start();
      }
    } else {
      if (_ticker.isActive) {
        _ticker.stop();
      }
      if (duration.inMilliseconds > 0) {
        _playheadPositionNotifier.value =
            (currentPos.inMilliseconds / duration.inMilliseconds).clamp(_localStart, _localEnd);
      }
    }
  }

  void _tick(Duration elapsed) {
    if (!mounted || _isDragging) return;
    final duration = widget.controller.value.duration;
    if (duration.inMilliseconds == 0) return;

    if (widget.controller.value.isPlaying) {
      final now = DateTime.now();
      final diff = now.difference(_lastPositionUpdateTime);
      final estimatedMs = _lastKnownPosition.inMilliseconds + diff.inMilliseconds;

      final startMs = (duration.inMilliseconds * _localStart).toInt();
      final endMs = (duration.inMilliseconds * _localEnd).toInt();

      if (estimatedMs >= endMs || estimatedMs < startMs) {
        // Pause and seek back to the start of the trim window instead of looping
        _ticker.stop();
        widget.controller.pause();
        widget.controller.seekTo(Duration(milliseconds: startMs));
        _lastKnownPosition = Duration(milliseconds: startMs);
        _lastPositionUpdateTime = now;
        _playheadPositionNotifier.value = _localStart;
      } else {
        _playheadPositionNotifier.value = (estimatedMs / duration.inMilliseconds).clamp(_localStart, _localEnd);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final duration = widget.controller.value.duration;
    final startMs = (duration.inMilliseconds * _localStart).toInt();
    final endMs = (duration.inMilliseconds * _localEnd).toInt();

    final selectedDuration = Duration(milliseconds: endMs - startMs);
    final selectedDurationText = _formatDuration(selectedDuration);

    final selectedSize = (widget.totalSize * (_localEnd - _localStart)).toInt();
    final sizeText = AppUtils.formatFileSize(selectedSize);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Trimbar Slider
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            const double trimbarHeight = 50.0;

            final startX = _localStart * width;
            final endX = _localEnd * width;

            return Stack(
              key: _trimbarKey,
              clipBehavior: Clip.none,
              children: [
                // 1. Background thumbnails and unselected dimmed overlays (rounded corners)
                Container(
                  height: trimbarHeight,
                  width: width,
                  decoration: BoxDecoration(
                    color: colorScheme.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Thumbnails Row
                      Positioned.fill(
                        child: Row(
                          children: List.generate(
                            widget.thumbnails.isEmpty ? 8 : widget.thumbnails.length,
                            (i) => Expanded(
                              child: widget.thumbnails.isEmpty
                                  ? Container(
                                      color: colorScheme.onPrimary.withValues(alpha: 0.08),
                                    )
                                  : Image.file(
                                      File(widget.thumbnails[i]),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      // 2. Dimmed overlay on unselected left region
                      if (startX > 0)
                        Positioned(
                          left: 0,
                          width: startX,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            color: colorScheme.black.withValues(alpha: 0.6),
                          ),
                        ),

                      // 3. Dimmed overlay on unselected right region
                      if (endX < width)
                        Positioned(
                          left: endX,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            color: colorScheme.black.withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),

                // 4. White border enclosing the selected region (rounded corners, draggable)
                Positioned(
                  left: startX,
                  width: (endX - startX).clamp(0.0, width),
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (details) {
                      setState(() {
                        _isDraggingHandles = true;
                      });
                      widget.controller.pause();
                      widget.onDraggingChanged?.call(true);
                    },
                    onHorizontalDragUpdate: (details) {
                      final deltaProgress = details.delta.dx / width;
                      final durationProgress = _localEnd - _localStart;
                      double newStart = _localStart + deltaProgress;
                      double newEnd = _localEnd + deltaProgress;

                      if (newStart < 0.0) {
                        newStart = 0.0;
                        newEnd = durationProgress;
                      } else if (newEnd > 1.0) {
                        newEnd = 1.0;
                        newStart = 1.0 - durationProgress;
                      }

                      setState(() {
                        _localStart = newStart.clamp(0.0, 1.0);
                        _localEnd = newEnd.clamp(0.0, 1.0);
                      });
                      widget.onTrimChanged(_localStart, _localEnd);
                      _throttledSeek(_localStart);
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _isDraggingHandles = false;
                      });
                      final startMs = (duration.inMilliseconds * _localStart).toInt();
                      widget.controller.seekTo(Duration(milliseconds: startMs));
                      _lastKnownPosition = Duration(milliseconds: startMs);
                      _lastPositionUpdateTime = DateTime.now();
                      _playheadPositionNotifier.value = _localStart;
                      widget.onDraggingChanged?.call(false);
                    },
                    onHorizontalDragCancel: () {
                      setState(() {
                        _isDraggingHandles = false;
                      });
                      final startMs = (duration.inMilliseconds * _localStart).toInt();
                      widget.controller.seekTo(Duration(milliseconds: startMs));
                      _lastKnownPosition = Duration(milliseconds: startMs);
                      _lastPositionUpdateTime = DateTime.now();
                      _playheadPositionNotifier.value = _localStart;
                      widget.onDraggingChanged?.call(false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.onPrimary, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),

                // 5. Traveling Playhead Progress Line
                ValueListenableBuilder<double>(
                  valueListenable: _playheadPositionNotifier,
                  builder: (context, progress, child) {
                    if (duration.inMilliseconds == 0 || _isDraggingHandles) {
                      return const SizedBox.shrink();
                    }

                    final playheadX = progress * width;
                    final clampedPlayheadX = playheadX.clamp(startX, endX);

                    return Positioned(
                      left: (clampedPlayheadX - 1).clamp(startX, endX - 2),
                      top: 4,
                      bottom: 4,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragStart: (details) {
                          setState(() {
                            _isDraggingPlayhead = true;
                          });
                          widget.controller.pause();
                          widget.onDraggingChanged?.call(true);
                        },
                        onHorizontalDragUpdate: (details) {
                          final deltaProgress = details.delta.dx / width;
                          double newProgress = _playheadPositionNotifier.value + deltaProgress;
                          newProgress = newProgress.clamp(_localStart, _localEnd);

                          _playheadPositionNotifier.value = newProgress;
                          _lastKnownPosition = Duration(milliseconds: (duration.inMilliseconds * newProgress).toInt());
                          _lastPositionUpdateTime = DateTime.now();

                          _throttledSeek(newProgress);
                        },
                        onHorizontalDragEnd: (details) {
                          setState(() {
                            _isDraggingPlayhead = false;
                          });
                          widget.onDraggingChanged?.call(false);
                        },
                        onHorizontalDragCancel: () {
                          setState(() {
                            _isDraggingPlayhead = false;
                          });
                          widget.onDraggingChanged?.call(false);
                        },
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(1),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.black.withValues(alpha: 0.25),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // 6. Left Handle Dot (Visual Only)
                Positioned(
                  left: startX - 6,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // 7. Right Handle Dot (Visual Only)
                Positioned(
                  left: endX - 6,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // 8. Left Drag Area (HitTest / GestureDetector on top)
                Positioned(
                  left: startX - 20,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (details) {
                      setState(() {
                        _isDraggingHandles = true;
                      });
                      widget.controller.pause();
                      widget.onDraggingChanged?.call(true);
                    },
                    onHorizontalDragUpdate: (details) {
                      final deltaProgress = details.delta.dx / width;
                      double newStart = _localStart + deltaProgress;
                      newStart = newStart.clamp(0.0, _localEnd - 0.05);

                      setState(() {
                        _localStart = newStart;
                      });
                      widget.onTrimChanged(newStart, _localEnd);
                      _throttledSeek(newStart);
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _isDraggingHandles = false;
                      });
                      final startMs = (duration.inMilliseconds * _localStart).toInt();
                      widget.controller.seekTo(Duration(milliseconds: startMs));
                      _lastKnownPosition = Duration(milliseconds: startMs);
                      _lastPositionUpdateTime = DateTime.now();
                      _playheadPositionNotifier.value = _localStart;
                      widget.onDraggingChanged?.call(false);
                    },
                    onHorizontalDragCancel: () {
                      setState(() {
                        _isDraggingHandles = false;
                      });
                      final startMs = (duration.inMilliseconds * _localStart).toInt();
                      widget.controller.seekTo(Duration(milliseconds: startMs));
                      _lastKnownPosition = Duration(milliseconds: startMs);
                      _lastPositionUpdateTime = DateTime.now();
                      _playheadPositionNotifier.value = _localStart;
                      widget.onDraggingChanged?.call(false);
                    },
                    child: const SizedBox(width: 40),
                  ),
                ),

                // 9. Right Drag Area (HitTest / GestureDetector on top)
                Positioned(
                  left: endX - 20,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (details) {
                      setState(() {
                        _isDraggingHandles = true;
                      });
                      widget.controller.pause();
                      widget.onDraggingChanged?.call(true);
                    },
                    onHorizontalDragUpdate: (details) {
                      final deltaProgress = details.delta.dx / width;
                      double newEnd = _localEnd + deltaProgress;
                      newEnd = newEnd.clamp(_localStart + 0.05, 1.0);

                      setState(() {
                        _localEnd = newEnd;
                      });
                      widget.onTrimChanged(_localStart, newEnd);
                      _throttledSeek(newEnd);
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _isDraggingHandles = false;
                      });
                      final startMs = (duration.inMilliseconds * _localStart).toInt();
                      widget.controller.seekTo(Duration(milliseconds: startMs));
                      _lastKnownPosition = Duration(milliseconds: startMs);
                      _lastPositionUpdateTime = DateTime.now();
                      _playheadPositionNotifier.value = _localStart;
                      widget.onDraggingChanged?.call(false);
                    },
                    onHorizontalDragCancel: () {
                      setState(() {
                        _isDraggingHandles = false;
                      });
                      final startMs = (duration.inMilliseconds * _localStart).toInt();
                      widget.controller.seekTo(Duration(milliseconds: startMs));
                      _lastKnownPosition = Duration(milliseconds: startMs);
                      _lastPositionUpdateTime = DateTime.now();
                      _playheadPositionNotifier.value = _localStart;
                      widget.onDraggingChanged?.call(false);
                    },
                    child: const SizedBox(width: 40),
                  ),
                ),
              ],
            );
          },
        ),
        AppUIConstants.widgets.verticalBox$8,

        // 2. Bottom Row: Mute / duration & size info
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$8,
                vertical: AppUIConstants.spacing.space$4,
              ),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: widget.onMuteToggled,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(AppUIConstants.spacing.space$4),
                      child: Icon(
                        widget.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: colorScheme.onPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  AppUIConstants.widgets.horizontalBox$4,
                  Text(
                    '$selectedDurationText • $sizeText',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
