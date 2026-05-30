import 'dart:async';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackyond/core/common/widgets/button/chat_action_button.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage({super.key});

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage>
    with SingleTickerProviderStateMixin {
  static const _mediaScannerChannel = MethodChannel('media_scanner_channel');
  
  late final List<String> imageUrls;
  late final List<String?> blurHashes;
  late final int initialIndex;
  late final String messageUid;
  JobChatMessageEntity? message;
  
  late int _currentIndex;
  late final ExtendedPageController _pageController;
  late final AnimationController _doubleTapAnimationController;
  Animation<double>? _doubleTapAnimation;
  VoidCallback? _doubleTapListener;

  bool _isSharing = false;
  bool _isDownloading = false;
  bool _isSliding = false;
  bool _showOverlays = true;
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    // Parse arguments passed via Get.arguments
    final args = Get.arguments as Map<String, dynamic>;
    imageUrls = List<String>.from(args['imageUrls'] as List);
    blurHashes = args['blurHashes'] != null
        ? List<String?>.from(args['blurHashes'] as List)
        : [];
    initialIndex = args['initialIndex'] as int? ?? 0;
    messageUid = args['messageUid'] as String? ?? '';
    message = args['message'] as JobChatMessageEntity?;
    
    _currentIndex = initialIndex;
    _pageController = ExtendedPageController(initialPage: _currentIndex);
    
    _doubleTapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Auto-hide overlays after 2 seconds upon entering the page
    _startOverlayTimer();
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _pageController.dispose();
    _doubleTapAnimationController.dispose();
    super.dispose();
  }

  void _startOverlayTimer() {
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showOverlays = false;
        });
      }
    });
  }

  void _toggleOverlays() {
    setState(() {
      _showOverlays = !_showOverlays;
      if (_showOverlays) {
        _startOverlayTimer();
      } else {
        _overlayTimer?.cancel();
      }
    });
  }

  Future<void> _shareImage(String url) async {
    if (_isSharing) return;
    setState(() {
      _isSharing = true;
    });

    try {
      final fullUrl = AppImage.getFullUrl(url);
      final data = await getNetworkImageData(fullUrl);
      if (data != null) {
        final tempDir = await getTemporaryDirectory();
        final uri = Uri.parse(fullUrl);
        String filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'image.jpg';
        if (!filename.contains('.')) {
          filename = '$filename.jpg';
        }
        final file = File('${tempDir.path}/$filename');
        await file.writeAsBytes(data);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
          ),
        );
      } else {
        AppSnackbar.destructive(AppStrings.jobChat.shareImageFailed);
      }
    } catch (e) {
      AppSnackbar.destructive('${AppStrings.jobChat.shareError}$e');
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _downloadImage(String url) async {
    if (_isDownloading) return;
    setState(() {
      _isDownloading = true;
    });

    try {
      final fullUrl = AppImage.getFullUrl(url);
      final data = await getNetworkImageData(fullUrl);
      if (data != null) {
        Directory? dir;
        if (Platform.isAndroid) {
          final downloadDir = Directory('/storage/emulated/0/Download');
          if (await downloadDir.exists()) {
            try {
              final testFile = File('${downloadDir.path}/.test_write');
              await testFile.writeAsString('test');
              await testFile.delete();
              dir = downloadDir;
            } catch (_) {
              dir = await getExternalStorageDirectory();
            }
          } else {
            dir = await getExternalStorageDirectory();
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        if (dir != null) {
          final uri = Uri.parse(fullUrl);
          String filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'image.jpg';
          if (!filename.contains('.')) {
            filename = '$filename.jpg';
          }
          final savePath = '${dir.path}/$filename';
          final file = File(savePath);
          await file.writeAsBytes(data);
          
          if (Platform.isAndroid) {
            try {
              await _mediaScannerChannel.invokeMethod('scanFile', {'path': savePath});
            } catch (e) {
              debugPrint('Error invoking media scanner: $e');
            }
          }
          
          AppSnackbar.success(AppStrings.jobChat.saveImageSuccess);
        } else {
          AppSnackbar.destructive(AppStrings.jobChat.saveDirectoryNotFound);
        }
      } else {
        AppSnackbar.destructive(AppStrings.jobChat.saveImageFailed);
      }
    } catch (e) {
      AppSnackbar.destructive('${AppStrings.jobChat.saveError}$e');
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;
    final chatController = Get.find<JobChatController>();
    final isOverlayVisible = _showOverlays && !_isSliding;
    
    final senderName = message != null
        ? (message!.isMe ? 'You' : chatController.getSenderName(message!))
        : '';

    final captionText = message?.content
            .where((c) => c.type == 'text')
            .map((c) => c.content)
            .whereType<String>()
            .join('\n') ??
        '';

    final hasReadMore = captionText.length > 120;
    final displayCaption = hasReadMore 
        ? '${captionText.substring(0, 120)}...' 
        : captionText;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ExtendedImageSlidePage(
          slideAxis: SlideAxis.both,
          slideType: SlideType.onlyImage,
          slidePageBackgroundHandler: (Offset offset, Size pageSize) {
            return defaultSlidePageBackgroundHandler(
              offset: offset,
              pageSize: pageSize,
              color: context.theme.colorScheme.black,
              pageGestureAxis: SlideAxis.both,
            );
          },
          onSlidingPage: (state) {
            final sliding = state.isSliding;
            if (sliding != _isSliding) {
              setState(() {
                _isSliding = sliding;
              });
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image slider page view wrapped in a tap detector to toggle overlays
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _toggleOverlays,
                child: ExtendedImageGesturePageView.builder(
                  controller: _pageController,
                  itemCount: imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    // Reset timer on page swipe to keep overlays visible while browsing
                    if (_showOverlays) {
                      _startOverlayTimer();
                    }
                  },
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final url = AppImage.getFullUrl(imageUrls[index]);
                    final blurHash = index < blurHashes.length ? blurHashes[index] : null;
                    final decodedHashProvider = (blurHash != null && blurHash.isNotEmpty)
                        ? AppImage.getBlurHashProvider(blurHash)
                        : null;

                    return ExtendedImage(
                      image: CachedNetworkImageProvider(url),
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      enableSlideOutPage: true,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return decodedHashProvider != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image(
                                        image: decodedHashProvider,
                                        fit: BoxFit.contain,
                                      ),
                                      Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.onPrimary,
                                      ),
                                    ),
                                  );
                          case LoadState.completed:
                            return null;
                          case LoadState.failed:
                            return decodedHashProvider != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image(
                                        image: decodedHashProvider,
                                        fit: BoxFit.contain,
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            AppUIConstants.widgets.verticalBox$8,
                                            Text(
                                              AppStrings.jobChat.retry,
                                              style: textTheme.labelMedium?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  );
                        }
                      },
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 1.0,
                          animationMinScale: 0.7,
                          maxScale: 4.0,
                          animationMaxScale: 4.5,
                          speed: 1.0,
                          inertialSpeed: 100.0,
                          initialScale: 1.0,
                          inPageView: true,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                      heroBuilderForSlidingPage: (child) {
                        return Hero(
                          tag: 'image_${messageUid}_$index',
                          child: child,
                        );
                      },
                      onDoubleTap: (ExtendedImageGestureState state) {
                        final pointerDownPosition = state.pointerDownPosition;
                        final begin = state.gestureDetails?.totalScale ?? 1.0;
                        double end;

                        // Clean up previous listeners
                        if (_doubleTapAnimation != null && _doubleTapListener != null) {
                          _doubleTapAnimation!.removeListener(_doubleTapListener!);
                        }

                        _doubleTapAnimationController.stop();
                        _doubleTapAnimationController.reset();

                        if (begin == 1.0) {
                          end = 3.0;
                        } else {
                          end = 1.0;
                        }

                        _doubleTapListener = () {
                          state.handleDoubleTap(
                            scale: _doubleTapAnimation!.value,
                            doubleTapPosition: pointerDownPosition,
                          );
                        };
                        _doubleTapAnimation = _doubleTapAnimationController
                            .drive(Tween<double>(begin: begin, end: end));

                        _doubleTapAnimation!.addListener(_doubleTapListener!);
                        _doubleTapAnimationController.forward();
                        
                        // Keep overlays visible during interaction or hide them
                        _toggleOverlays();
                      },
                    );
                  },
                ),
              ),

              // Overlay Top Controls (Animated Slide & Fade)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: isOverlayVisible ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: isOverlayVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppUIConstants.spacing.space$16,
                          vertical: AppUIConstants.spacing.space$8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            ChatActionButton(
                              icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),

                            // Title/Page Counter
                            if (imageUrls.length > 1)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppUIConstants.spacing.space$16,
                                  vertical: AppUIConstants.spacing.space$6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(
                                    AppUIConstants.radius.radius$24,
                                  ),
                                ),
                                child: Text(
                                  '${_currentIndex + 1} / ${imageUrls.length}',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),

                            // Share / Action button
                            ChatActionButton(
                              icon: _isSharing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.share_outlined,
                                      size: 20,
                                    ),
                              onPressed: _isSharing
                                  ? null
                                  : () => _shareImage(imageUrls[_currentIndex]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Overlay Bottom Details and Actions (Animated Slide & Fade)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: isOverlayVisible ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: isOverlayVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        AppUIConstants.spacing.space$20,
                        AppUIConstants.spacing.space$24,
                        AppUIConstants.spacing.space$20,
                        MediaQuery.of(context).padding.bottom + AppUIConstants.spacing.space$20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.85),
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Sender & Time Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                senderName,
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                message != null
                                    ? DateFormat('hh:mm a').format(message!.timestamp)
                                    : '',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          
                          // Caption Text (if there is text message content)
                          if (captionText.isNotEmpty) ...[
                            AppUIConstants.widgets.verticalBox$8,
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: displayCaption),
                                  if (hasReadMore)
                                    TextSpan(
                                      text: ' Read more',
                                      style: TextStyle(
                                        color: context.theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.955),
                                height: 1.35,
                              ),
                            ),
                          ],
                          
                          AppUIConstants.widgets.verticalBox$16,
                          
                          // Action row (Reply & Save) using standard AppButton widgets
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Reply button
                              AppButton.filled(
                                text: AppStrings.jobChat.reply,
                                leading: const Icon(Icons.reply_rounded),
                                onPressed: () {
                                  if (message != null) {
                                    final chatController = Get.find<JobChatController>();
                                    chatController.replyingToMessage.value = message;
                                    Navigator.of(context).pop();
                                  }
                                },
                                width: null,
                                height: 38,
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: AppButtonShape.capsule,
                              ),
                              AppUIConstants.widgets.horizontalBox$12,
                              // Download/Save button
                              AppButton.filled(
                                text: AppStrings.common.save,
                                leading: const Icon(Icons.download_rounded),
                                isLoading: _isDownloading,
                                onPressed: () => _downloadImage(imageUrls[_currentIndex]),
                                width: null,
                                height: 38,
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: AppButtonShape.capsule,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
