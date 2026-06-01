import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';

class MediaVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int index;
  final String? blurHash;
  final VoidCallback onTap;
  final Function(int, VideoPlayerController?) onControllerChanged;

  const MediaVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.index,
    this.blurHash,
    required this.onTap,
    required this.onControllerChanged,
  });

  @override
  State<MediaVideoPlayerWidget> createState() => _MediaVideoPlayerWidgetState();
}

class _MediaVideoPlayerWidgetState extends State<MediaVideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  String? _errorMessage;
  bool _showControls = true;
  Timer? _controlsTimer;

  Uint8List? _thumbnailBytes;
  static final Map<String, Uint8List> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
    _initializeController();
  }

  Future<void> _loadThumbnail() async {
    final fullUrl = widget.videoUrl;
    if (_thumbnailCache.containsKey(fullUrl)) {
      if (mounted) {
        setState(() {
          _thumbnailBytes = _thumbnailCache[fullUrl];
        });
      }
      return;
    }

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: fullUrl,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 512, // Higher quality for full screen preview
        quality: 85,
      );
      if (bytes != null) {
        _thumbnailCache[fullUrl] = bytes;
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

  Future<void> _initializeController() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();
      _controller.setLooping(false);
      _controller.addListener(_videoListener);
      if (mounted) {
        setState(() {
          _isInitialized = true;
          // Auto-play the video
          _controller.play();
          _isPlaying = true;
        });
        _startControlsTimer();
        widget.onControllerChanged(widget.index, _controller);
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _videoListener() {
    if (mounted) {
      final isPlaying = _controller.value.isPlaying;
      if (_isPlaying != isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }

      final position = _controller.value.position;
      final duration = _controller.value.duration;
      if (position >= duration && duration > Duration.zero) {
        _controller.seekTo(Duration.zero);
        _controller.pause();
      }
    }
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true;
        _controlsTimer?.cancel();
      } else {
        _controller.play();
        _startControlsTimer();
      }
    });
  }

  void _seekBackward10() {
    final currentPos = _controller.value.position;
    final targetPos = currentPos - const Duration(seconds: 10);
    final newPos = targetPos < Duration.zero ? Duration.zero : targetPos;
    _controller.seekTo(newPos);
    _startControlsTimer();
  }

  void _seekForward10() {
    final currentPos = _controller.value.position;
    final duration = _controller.value.duration;
    final targetPos = currentPos + const Duration(seconds: 10);
    final newPos = targetPos > duration ? duration : targetPos;
    _controller.seekTo(newPos);
    _startControlsTimer();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _controller.removeListener(_videoListener);
    widget.onControllerChanged(widget.index, null);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colorScheme.onPrimary, size: 40),
            const SizedBox(height: 12),
            Text(
              'Error playing video',
              style: TextStyle(color: colorScheme.onPrimary.withValues(alpha: 0.8)),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      final MemoryImage? decodedHashProvider = (widget.blurHash != null && widget.blurHash!.isNotEmpty)
          ? AppImage.getBlurHashProvider(widget.blurHash!)
          : null;

      return Stack(
        fit: StackFit.expand,
        children: [
          // Show thumbnail or blur hash fallback
          if (_thumbnailBytes != null)
            Image.memory(
              _thumbnailBytes!,
              fit: BoxFit.contain,
            )
          else if (decodedHashProvider != null)
            Image(
              image: decodedHashProvider,
              fit: BoxFit.contain,
            ),
          // Loader spinner on top
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          ),
        ],
      );
    }

    final showOverlay = _showControls || !_isPlaying;

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        // Three Tap Regions for Double-Tap seeking & single-tap overlay toggle
        Positioned.fill(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left region: double tap to seek 10s backward, single tap to toggle controls
              Expanded(
                flex: 3,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.onTap(); // Toggle outer page overlays
                    setState(() {
                      _showControls = !_showControls;
                      if (_showControls && _isPlaying) {
                        _startControlsTimer();
                      }
                    });
                  },
                  onDoubleTap: _seekBackward10,
                  child: const SizedBox.expand(),
                ),
              ),
              // Middle region: single tap to toggle controls/immersive mode
              Expanded(
                flex: 4,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.onTap(); // Toggle outer page overlays
                    setState(() {
                      _showControls = !_showControls;
                      if (_showControls && _isPlaying) {
                        _startControlsTimer();
                      }
                    });
                  },
                  child: const SizedBox.expand(),
                ),
              ),
              // Right region: double tap to seek 10s forward, single tap to toggle controls
              Expanded(
                flex: 3,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.onTap(); // Toggle outer page overlays
                    setState(() {
                      _showControls = !_showControls;
                      if (_showControls && _isPlaying) {
                        _startControlsTimer();
                      }
                    });
                  },
                  onDoubleTap: _seekForward10,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        // Buffering Indicator
        if (_isInitialized && _controller.value.isBuffering)
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          ),
        // Play/Pause Overlay
        AnimatedOpacity(
          opacity: showOverlay ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: IgnorePointer(
            ignoring: !showOverlay,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Backward 10s
                  GestureDetector(
                    onTap: _seekBackward10,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.replay_10_rounded,
                        color: colorScheme.onPrimary,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 28),
                  // Play/Pause
                  GestureDetector(
                    onTap: _togglePlay,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: colorScheme.onPrimary,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(width: 28),
                  // Forward 10s
                  GestureDetector(
                    onTap: _seekForward10,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.forward_10_rounded,
                        color: colorScheme.onPrimary,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
