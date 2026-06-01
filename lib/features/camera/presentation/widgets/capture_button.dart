import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class CaptureButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final double videoProgress;
  final bool isRecording;
  final bool disabled;

  const CaptureButton({
    super.key,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.videoProgress,
    required this.isRecording,
    this.disabled = false,
  });

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  double _buttonScale = 1.0;
  double _dragY = 0.0;
  bool _isLocked = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.disabled) return;
    
    if (widget.isRecording && _isLocked) {
      // Pressing stop button when locked
      setState(() {
        _buttonScale = 0.9;
      });
      return;
    }

    if (widget.isRecording) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _buttonScale = 0.9;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.disabled) return;

    if (widget.isRecording && _isLocked) {
      // Tapping stop button stops the locked video recording
      setState(() {
        _buttonScale = 1.0;
        _isLocked = false;
      });
      HapticFeedback.mediumImpact();
      widget.onLongPressEnd();
      return;
    }

    if (widget.isRecording) return;

    setState(() {
      _buttonScale = 1.0;
    });
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _handleTapCancel() {
    if (widget.disabled) return;
    setState(() {
      _buttonScale = 1.0;
    });
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    if (widget.disabled || widget.isRecording) return;
    setState(() {
      _isLocked = false;
      _dragY = 0.0;
    });
    HapticFeedback.heavyImpact();
    widget.onLongPressStart();
  }

  void _handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (widget.disabled || !widget.isRecording || _isLocked) return;

    final dy = details.localOffsetFromOrigin.dy;
    setState(() {
      // Clamp drag upward to 70 pixels
      _dragY = dy.clamp(-70.0, 0.0);
    });

    if (_dragY <= -70.0) {
      HapticFeedback.heavyImpact();
      setState(() {
        _isLocked = true;
        _dragY = 0.0;
      });
    }
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    if (widget.disabled || !widget.isRecording) return;

    if (_isLocked) {
      // If locked, releasing long press shouldn't stop recording
      return;
    }

    setState(() {
      _dragY = 0.0;
    });
    HapticFeedback.mediumImpact();
    widget.onLongPressEnd();
  }

  @override
  void didUpdateWidget(covariant CaptureButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset local lock state if recording stops
    if (oldWidget.isRecording && !widget.isRecording) {
      setState(() {
        _isLocked = false;
        _dragY = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPressStart: _handleLongPressStart,
      onLongPressMoveUpdate: _handleLongPressMoveUpdate,
      onLongPressEnd: _handleLongPressEnd,
      child: AnimatedScale(
        scale: _buttonScale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 150,
          height: 260,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Lock Hint pill & Chevron indicators
              if (widget.isRecording && !_isLocked)
                Positioned(
                  bottom: 115,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lock icon translating upwards
                      Transform.translate(
                        offset: Offset(0, _dragY),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.onPrimary.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.lock_open_rounded,
                            color: colorScheme.onPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Slide up to lock',
                        style: TextStyle(
                          color: colorScheme.onPrimary.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: colorScheme.black.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                        size: 18,
                      ),
                    ],
                  ),
                ),

              // Bottom control elements
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Ring
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: widget.isRecording ? 105 : 80,
                        height: widget.isRecording ? 105 : 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.onPrimary.withValues(alpha: widget.isRecording ? 0.3 : 1.0),
                            width: widget.isRecording ? 6 : 4,
                          ),
                        ),
                      ),

                      // Circular Progress Indicator (drawn along outer ring)
                      if (widget.isRecording)
                        IgnorePointer(
                          child: SizedBox(
                            width: 105,
                            height: 105,
                            child: CustomPaint(
                              painter: CircularProgressBarPainter(
                                progress: widget.videoProgress,
                                color: primaryColor,
                                strokeWidth: 6,
                              ),
                            ),
                          ),
                        ),

                      // Inner solid circle / red square stop button
                      IgnorePointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          width: widget.isRecording ? 32 : 62,
                          height: widget.isRecording ? 32 : 62,
                          decoration: BoxDecoration(
                            color: widget.isRecording ? colorScheme.error : colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(widget.isRecording ? 8 : 31),
                          ),
                        ),
                      ),
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

class CircularProgressBarPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressBarPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
