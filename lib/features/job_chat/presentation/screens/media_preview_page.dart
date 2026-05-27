import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_icon_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_input_field.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_send_button.dart';

class MediaPreviewPage extends StatefulWidget {
  const MediaPreviewPage({super.key});

  @override
  State<MediaPreviewPage> createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  late final List<String> mediaPaths;
  late final TextEditingController captionController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    if (args['imagePaths'] is List<String>) {
      mediaPaths = args['imagePaths'] as List<String>;
    } else if (args['imagePaths'] is List) {
      mediaPaths = List<String>.from(args['imagePaths'] as List);
    } else {
      final singlePath = args['imagePath'] as String? ?? '';
      mediaPaths = [singlePath];
    }
    captionController = TextEditingController();
  }

  @override
  void dispose() {
    captionController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    focusNode.unfocus();
    debugPrint('Send clicked with caption: ${captionController.text}');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final controller = Get.find<JobChatController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: colorScheme.black,
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Photo Background Content (PageView.builder with Image.file)
              PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: mediaPaths.length,
                itemBuilder: (context, index) {
                  final path = mediaPaths[index];
                  final file = File(path);
                  return _ZoomableImageItem(file: file, index: index);
                },
              ),

              // 2. Bottom Input Row (flat transparent background inside SafeArea)
              Positioned(
                bottom: context.mediaQueryViewInsets.bottom,
                left: 0,
                right: 0,
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppUIConstants.spacing.space$16,
                        ),
                        child: ChatInputField(
                          controller: captionController,
                          focusNode: focusNode,
                          hintText: AppStrings.jobChat.addCaptionHint,
                          backgroundColor: colorScheme.black,
                          borderColor: colorScheme.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          textColor: colorScheme.onPrimary,
                          hintColor: colorScheme.onPrimary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      AppUIConstants.widgets.verticalBox$12,
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          AppUIConstants.spacing.space$16,
                          AppUIConstants.spacing.space$16,
                          AppUIConstants.spacing.space$16,
                          AppUIConstants.spacing.space$24,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              AppUIConstants.radius.radius$32,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppUIConstants.spacing.space$16,
                                vertical: AppUIConstants.spacing.space$8,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppUIConstants.radius.radius$12,
                                ),
                              ),
                              child: Text(
                                '${AppStrings.jobChat.jobIdPrefix} ${controller.job.jobId}',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ChatSendButton(onPressed: _onSend),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Top Action Bar (flat transparent background overlay inside SafeArea)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppUIConstants.spacing.space$8,
                      vertical: AppUIConstants.spacing.space$4,
                    ),
                    child: Row(
                      children: [
                        AppIconButton(
                          icon: const Icon(Icons.close_rounded, size: 24),
                          onPressed: () => Get.back(),
                          size: 40,
                          backgroundColor: colorScheme.outlineVariant
                              .withValues(alpha: 0.2),
                          iconColor: colorScheme.onPrimary,
                        ),
                        const Spacer(),
                      ],
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

class _ZoomableImageItem extends StatefulWidget {
  final File file;
  final int index;

  const _ZoomableImageItem({required this.file, required this.index});

  @override
  State<_ZoomableImageItem> createState() => _ZoomableImageItemState();
}

class _ZoomableImageItemState extends State<_ZoomableImageItem>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;
  
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
        )..addListener(() {
          if (_animation != null) {
            _transformationController.value = _animation!.value;
          }
        });
        
    if (widget.file.existsSync()) {
      _resolveImageSize();
    }
  }

  void _resolveImageSize() {
    final imageProvider = FileImage(widget.file);
    final imageStream = imageProvider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((info, _) {
      if (mounted) {
        setState(() {
          _imageSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        });
      }
    });
    imageStream.addListener(listener);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails?.localPosition ?? Offset.zero;

    Matrix4 endMatrix;
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale <= 1.05) {
      endMatrix = Matrix4.translationValues(-position.dx, -position.dy, 0.0)
        ..multiply(Matrix4.diagonal3Values(2.0, 2.0, 1.0));
    } else {
      endMatrix = Matrix4.identity();
    }

    _animation =
        Matrix4Tween(
          begin: _transformationController.value.clone(),
          end: endMatrix,
        ).animate(
          CurveTween(curve: Curves.easeInOut).animate(_animationController),
        );

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsets boundaryMargin = EdgeInsets.zero;

        if (_imageSize != null) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Prevent division by zero
          if (screenHeight > 0 && _imageSize!.height > 0) {
            final screenAspect = screenWidth / screenHeight;
            final imageAspect = _imageSize!.width / _imageSize!.height;

            if (imageAspect > screenAspect) {
              // Image is wider than screen, constrained by width
              final fittedHeight = screenWidth / imageAspect;
              final gap = (screenHeight - fittedHeight) / 2;
              boundaryMargin = EdgeInsets.symmetric(vertical: -gap);
            } else {
              // Image is taller than screen, constrained by height
              final fittedWidth = screenHeight * imageAspect;
              final gap = (screenWidth - fittedWidth) / 2;
              boundaryMargin = EdgeInsets.symmetric(horizontal: -gap);
            }
          }
        }

        return GestureDetector(
          onDoubleTapDown: _handleDoubleTapDown,
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 1.0,
            maxScale: 4.0,
            boundaryMargin: boundaryMargin,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Hero(
                tag: 'media_preview_hero_${widget.index}',
                child: widget.file.existsSync()
                    ? Image.file(
                        widget.file,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image_rounded,
                            color: colorScheme.error,
                            size: 48,
                          );
                        },
                      )
                    : Icon(
                        Icons.broken_image_rounded,
                        color: colorScheme.error,
                        size: 48,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
