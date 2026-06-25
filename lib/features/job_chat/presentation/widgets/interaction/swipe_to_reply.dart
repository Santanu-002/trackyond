import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_selection_controller.dart';

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;
  final String messageUid;
  final bool isSwipeEnabled;

  const SwipeToReply({
    super.key,
    required this.child,
    required this.onReply,
    required this.messageUid,
    this.isSwipeEnabled = true,
  });

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with TickerProviderStateMixin {
  // --- Swipe drag animation ---
  late final AnimationController _swipeController;
  double _dragExtent = 0.0;
  bool _hasTriggeredHaptic = false;

  static const double _triggerThreshold = 70.0;
  static const double _maxDragExtent = 90.0;

  // --- Highlight fade-out animation ---
  late final AnimationController _highlightController;
  Worker? _highlightWorker;

  @override
  void initState() {
    super.initState();

    // Swipe snap-back controller
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _swipeController.addListener(() {
      setState(() {
        _dragExtent = _swipeController.value * _maxDragExtent;
      });
    });

    // Highlight fade-out controller (1.5 seconds, 1.0 → 0.0)
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // React to highlightedMessageUid changes
    final chatController = Get.find<JobChatController>();
    _highlightWorker = ever(chatController.highlightedMessageUid, (uid) {
      if (uid == widget.messageUid) {
        // reverse(from: 1.0) → starts fully opaque, fades to 0 over 1.5s
        _highlightController.reverse(from: 1.0);
      }
    });
  }

  @override
  void dispose() {
    _highlightWorker?.dispose();
    _swipeController.dispose();
    _highlightController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_swipeController.isAnimating) {
      _swipeController.stop();
    }

    final newExtent =
        (_dragExtent + details.delta.dx).clamp(0.0, _maxDragExtent);
    if (newExtent != _dragExtent) {
      setState(() {
        _dragExtent = newExtent;
      });

      if (_dragExtent >= _triggerThreshold && !_hasTriggeredHaptic) {
        HapticFeedback.lightImpact();
        HapticFeedback.selectionClick();
        _hasTriggeredHaptic = true;
      } else if (_dragExtent < _triggerThreshold) {
        _hasTriggeredHaptic = false;
      }
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragExtent >= _triggerThreshold) {
      widget.onReply();
    }
    _resetDrag();
  }

  void _onDragCancel() {
    _resetDrag();
  }

  void _resetDrag() {
    _hasTriggeredHaptic = false;
    _swipeController.value = _dragExtent / _maxDragExtent;
    _swipeController.animateTo(
      0.0,
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final chatController = Get.find<JobChatController>();
    final selectionController = Get.find<JobChatSelectionController>();

    return Obx(() {
      final isSelectionMode = selectionController.isSelectionMode.value;
      final isSelected = selectionController.selectedMessageUids.contains(widget.messageUid);
      final isTriggered = _dragExtent >= _triggerThreshold;
      final swipeProgress = (_dragExtent / _triggerThreshold).clamp(0.0, 1.0);
      final msg = chatController.messages.firstWhereOrNull((m) => m.uid == widget.messageUid);
      final isDeleted = msg?.deleted ?? false;

      return SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onLongPress: isSelectionMode
              ? null
              : () => selectionController.enterSelectionMode(widget.messageUid),
          onHorizontalDragUpdate: (isSelectionMode || isDeleted || !widget.isSwipeEnabled) ? null : _onDragUpdate,
          onHorizontalDragEnd: (isSelectionMode || isDeleted || !widget.isSwipeEnabled) ? null : _onDragEnd,
          onHorizontalDragCancel: (isSelectionMode || isDeleted || !widget.isSwipeEnabled) ? null : _onDragCancel,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Highlight overlay — fades over 1.5s when this message is scrolled to
              AnimatedBuilder(
                animation: _highlightController,
                builder: (context, child) {
                  final highlightOpacity = _highlightController.value;
                  if (highlightOpacity == 0.0) return const SizedBox.shrink();
                  return Positioned.fill(
                    child: Container(
                      color: colorScheme.primary
                          .withValues(alpha: 0.12 * highlightOpacity),
                    ),
                  );
                },
              ),
              // Selection highlight overlay
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                  ),
                ),
              // Swipe reply indicator icon
              if (_dragExtent > 0 && !isSelectionMode) ...[
                Positioned(
                  left: 12.0,
                  width: 40,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: OverflowBox(
                      minWidth: 0,
                      minHeight: 0,
                      maxWidth: 40,
                      maxHeight: 40,
                      child: Opacity(
                        opacity: swipeProgress,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: isTriggered
                                  ? colorScheme.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    value: swipeProgress,
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isTriggered
                                          ? colorScheme.primary
                                          : colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.6),
                                    ),
                                    backgroundColor:
                                        colorScheme.onSurface.withValues(alpha: 0.05),
                                  ),
                                ),
                                Icon(
                                  Icons.reply_rounded,
                                  color: isTriggered
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              // Front visual layer — translated by _dragExtent on every frame
              Transform.translate(
                offset: Offset(isSelectionMode ? 0.0 : _dragExtent, 0),
                child: widget.child,
              ),
              // Selection mode overlay to intercept all taps on the bubble
              if (isSelectionMode)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectionController.toggleSelection(widget.messageUid),
                    onLongPress: () => selectionController.toggleSelection(widget.messageUid),
                    child: const SizedBox.expand(),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
