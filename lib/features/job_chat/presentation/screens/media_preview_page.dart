import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:trackyond/core/common/widgets/button/app_icon_button.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_input_field.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_send_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/add_more_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/aspect_preset_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/edit_action_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/thumbnail_item.dart';

class MediaPreviewPage extends StatefulWidget {
  const MediaPreviewPage({super.key});

  @override
  State<MediaPreviewPage> createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage>
    with TickerProviderStateMixin {
  late final List<String> mediaPaths;
  late final List<String> _originalPaths;
  late final TextEditingController captionController;
  late final ExtendedPageController _pageController;
  final FocusNode focusNode = FocusNode();
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isCropping = false;
  bool _isAnimatingPage = false;

  late final List<ImageEditorController> _editorControllers;
  late final List<GlobalKey<ExtendedImageEditorState>> _editorKeys;
  late final List<double?> _aspectRatios;
  late final List<String> _aspectRatioLabels;
  late final List<int> _savedHistoryIndices;

  late final AnimationController _doubleTapAnimationController;
  Animation<double>? _doubleTapAnimation;
  VoidCallback? _doubleTapListener;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    if (args['imagePaths'] is List<String>) {
      mediaPaths = List<String>.from(args['imagePaths'] as List<String>);
    } else if (args['imagePaths'] is List) {
      mediaPaths = List<String>.from(args['imagePaths'] as List);
    } else {
      final singlePath = args['imagePath'] as String? ?? '';
      mediaPaths = [singlePath];
    }
    _originalPaths = List<String>.from(mediaPaths);
    _editorControllers = List<ImageEditorController>.generate(
      mediaPaths.length,
      (_) => ImageEditorController(),
    );
    _editorKeys = List<GlobalKey<ExtendedImageEditorState>>.generate(
      mediaPaths.length,
      (_) => GlobalKey<ExtendedImageEditorState>(),
    );
    _aspectRatios = List<double?>.generate(mediaPaths.length, (_) => null);
    _aspectRatioLabels = List<String>.generate(
      mediaPaths.length,
      (_) => AppStrings.jobChat.cropPresetFree,
    );
    _savedHistoryIndices = List<int>.generate(mediaPaths.length, (_) => 0);

    captionController = TextEditingController();
    _pageController = ExtendedPageController();
    _doubleTapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    captionController.dispose();
    _pageController.dispose();
    focusNode.dispose();
    for (final ctrl in _editorControllers) {
      ctrl.dispose();
    }
    _doubleTapAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickMoreImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null && mounted) {
      setState(() {
        mediaPaths.add(image.path);
        _originalPaths.add(image.path);
        _editorControllers.add(ImageEditorController());
        _editorKeys.add(GlobalKey<ExtendedImageEditorState>());
        _aspectRatios.add(null);
        _aspectRatioLabels.add(AppStrings.jobChat.cropPresetFree);
        _savedHistoryIndices.add(0);
        _currentIndex = mediaPaths.length - 1;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentIndex);
        }
      });
    }
  }

  Future<void> _onSend() async {
    if (mediaPaths.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    focusNode.unfocus();
    debugPrint(
      'Send clicked with ${mediaPaths.length} photos and caption: ${captionController.text}',
    );

    final args = Get.arguments as Map<String, dynamic>;
    final requestMessage = args['requestMessage'] as JobChatMessageEntity;
    final controller = Get.find<JobChatController>();

    final success = await controller.sendMediaStatusProof(
      imagePaths: mediaPaths,
      caption: captionController.text,
      requestMessage: requestMessage,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        Get.back();
      }
    }
  }

  Future<void> _onCrop() async {
    debugPrint('Crop clicked for active index: $_currentIndex');
    setState(() {
      _isCropping = true;
    });
  }

  void _onUndo() {
    _editorControllers[_currentIndex].undo();
    setState(() {});
  }

  void _onRedo() {
    _editorControllers[_currentIndex].redo();
    setState(() {});
  }

  Future<void> _cancelCrop() async {
    final ctrl = _editorControllers[_currentIndex];
    final savedIndex = _savedHistoryIndices[_currentIndex];
    while (ctrl.currentIndex > savedIndex && ctrl.canUndo) {
      ctrl.undo();
    }
    while (ctrl.currentIndex < savedIndex && ctrl.canRedo) {
      ctrl.redo();
    }
    setState(() {
      _isCropping = false;
    });
  }

  Future<void> _onDoneCrop() async {
    debugPrint('Done crop clicked');
    setState(() {
      _isLoading = true;
    });

    try {
      final activeIndex = _currentIndex;
      final state = _editorKeys[activeIndex].currentState;
      if (state == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final cropRect = state.getCropRect();
      final editAction = state.editAction;

      final originalPath = _originalPaths[activeIndex];
      final file = File(originalPath);

      if (await file.exists()) {
        final bytes = await file.readAsBytes();

        final encodedBytes = await compute(
          _processImageCrop,
          _ImageCropParams(
            bytes: bytes,
            cropRect: cropRect,
            flipY: editAction?.flipY ?? false,
            rotateDegrees: editAction?.rotateDegrees ?? 0.0,
            hasRotateDegrees: editAction?.hasRotateDegrees ?? false,
            needCrop: editAction?.needCrop ?? false,
          ),
        );

        final originalDir = file.parent.path;
        final originalName = file.uri.pathSegments.last;
        final nameWithoutExt = originalName.substring(
          0,
          originalName.lastIndexOf('.'),
        );
        final ext = originalName.substring(originalName.lastIndexOf('.'));
        final newPath =
            '$originalDir/${nameWithoutExt}_edited_${DateTime.now().millisecondsSinceEpoch}$ext';

        final newFile = File(newPath);
        await newFile.writeAsBytes(encodedBytes);

        // Evict old preview path from image cache
        await FileImage(File(mediaPaths[activeIndex])).evict();

        setState(() {
          _editorControllers[activeIndex].dispose();
          _editorControllers[activeIndex] = ImageEditorController();

          mediaPaths[activeIndex] = newPath;
          _originalPaths[activeIndex] = newPath;
          _savedHistoryIndices[activeIndex] = 0;
          _isCropping = false;
          _isLoading = false;
        });

        AppSnackbar.success(AppStrings.jobChat.cropImageSuccess);
      } else {
        throw Exception(AppStrings.jobChat.cropOriginalFileNotFound);
      }
    } catch (e) {
      debugPrint('Error cropping image: $e');
      AppSnackbar.destructive(AppStrings.jobChat.cropImageFailed);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateCropAspectRatio(String label, double? ratio) {
    if (_aspectRatioLabels[_currentIndex] == label) return;
    setState(() {
      _aspectRatios[_currentIndex] = ratio;
      _aspectRatioLabels[_currentIndex] = label;
      _editorControllers[_currentIndex].updateCropAspectRatio(ratio);
    });
  }

  void _deleteCurrentImage() {
    if (mediaPaths.isEmpty || _isLoading) return;

    final activeIndex = _currentIndex;
    _editorControllers[activeIndex].dispose();

    setState(() {
      mediaPaths.removeAt(activeIndex);
      _originalPaths.removeAt(activeIndex);
      _editorControllers.removeAt(activeIndex);
      _editorKeys.removeAt(activeIndex);
      _aspectRatios.removeAt(activeIndex);
      _aspectRatioLabels.removeAt(activeIndex);
      _savedHistoryIndices.removeAt(activeIndex);

      if (mediaPaths.isEmpty) {
        Get.back();
      } else {
        if (_currentIndex >= mediaPaths.length) {
          _currentIndex = mediaPaths.length - 1;
        }
      }
    });

    if (mediaPaths.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentIndex);
        }
      });
    }

    AppSnackbar.success(AppStrings.jobChat.cropImageDeleted);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final controller = Get.find<JobChatController>();
    final isKeyboardActive = context.mediaQueryViewInsets.bottom > 0;

    final idx = _currentIndex;
    final canUndo =
        idx < _editorControllers.length && _editorControllers[idx].canUndo;
    final canRedo =
        idx < _editorControllers.length && _editorControllers[idx].canRedo;

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
              ExtendedImageGesturePageView.builder(
                controller: _pageController,
                physics: _isCropping
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                itemCount: mediaPaths.length,
                onPageChanged: (index) {
                  if (_isAnimatingPage) return;
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final path = mediaPaths[index];
                  final file = File(path);

                  if (_isCropping && index == _currentIndex) {
                    return ExtendedImage.file(
                      File(_originalPaths[index]),
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.editor,
                      extendedImageEditorKey: _editorKeys[index],
                      clearMemoryCacheWhenDispose: true,
                      initEditorConfigHandler: (state) {
                        return EditorConfig(
                          maxScale: 4.0,
                          cropRectPadding: const EdgeInsets.all(20.0),
                          hitTestSize: 20.0,
                          initCropRectType: InitCropRectType.imageRect,
                          cropAspectRatio: _aspectRatios[index],
                          controller: _editorControllers[index],
                          lineColor: Colors.white.withValues(alpha: 0.5),
                          editorMaskColorHandler: (context, pointerDown) =>
                              Colors.black.withValues(
                                alpha: pointerDown ? 0.3 : 0.65,
                              ),
                        );
                      },
                    );
                  } else {
                    return ExtendedImage.file(
                      file,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      clearMemoryCacheWhenDispose: true,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 1.0,
                          maxScale: 4.0,
                          speed: 1.0,
                          inertialSpeed: 100.0,
                          initialScale: 1.0,
                          inPageView: true,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                      onDoubleTap: (ExtendedImageGestureState state) {
                        final pointerDownPosition = state.pointerDownPosition;
                        final begin = state.gestureDetails?.totalScale ?? 1.0;
                        double end;

                        // Remove previous listener
                        if (_doubleTapAnimation != null &&
                            _doubleTapListener != null) {
                          _doubleTapAnimation!.removeListener(
                            _doubleTapListener!,
                          );
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
                      },
                    );
                  }
                },
              ),

              if (!_isCropping)
                Positioned(
                  bottom: context.mediaQueryViewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 56,
                          margin: EdgeInsets.only(
                            bottom: AppUIConstants.spacing.space$12,
                          ),
                          child: AnimatedOpacity(
                            opacity: isKeyboardActive ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppUIConstants.spacing.space$16,
                              ),
                              itemCount: mediaPaths.length + 1,
                              itemBuilder: (context, index) {
                                if (index == mediaPaths.length) {
                                  return AddMoreButton(
                                    isLoading: _isLoading,
                                    colorScheme: colorScheme,
                                    onTap: _pickMoreImage,
                                  );
                                }
                                return ThumbnailItem(
                                  index: index,
                                  path: mediaPaths[index],
                                  isActive: index == _currentIndex,
                                  isLoading: _isLoading,
                                  colorScheme: colorScheme,
                                  onTap: () {
                                    if (_currentIndex == index) return;
                                    setState(() {
                                      _currentIndex = index;
                                      _isAnimatingPage = true;
                                    });
                                    _pageController
                                        .animateToPage(
                                          index,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        )
                                        .then((_) {
                                          if (mounted) {
                                            setState(() {
                                              _isAnimatingPage = false;
                                            });
                                          }
                                        });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
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
                                  '${AppStrings.jobChat.jobIdPrefix}${controller.job.jobId}',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              ChatSendButton(
                                onPressed: _onSend,
                                isLoading: _isLoading,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppIconButton(
                          icon: Icon(
                            _isCropping
                                ? Icons.arrow_back_ios_new_rounded
                                : Icons.close_rounded,
                            size: 24,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_isCropping) {
                                    _cancelCrop();
                                  } else {
                                    Get.back();
                                  }
                                },
                          size: 40,
                          backgroundColor: colorScheme.outlineVariant
                              .withValues(alpha: 0.2),
                          iconColor: colorScheme.onPrimary,
                        ),
                        if (_isCropping)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIconButton(
                                icon: const Icon(Icons.undo_rounded, size: 24),
                                onPressed: (_isLoading || !canUndo)
                                    ? null
                                    : _onUndo,
                                size: 40,
                                backgroundColor: colorScheme.outlineVariant
                                    .withValues(alpha: 0.2),
                                iconColor: canUndo
                                    ? colorScheme.onPrimary
                                    : colorScheme.onPrimary.withValues(
                                        alpha: 0.35,
                                      ),
                              ),
                              AppUIConstants.widgets.horizontalBox$8,
                              AppIconButton(
                                icon: const Icon(Icons.redo_rounded, size: 24),
                                onPressed: (_isLoading || !canRedo)
                                    ? null
                                    : _onRedo,
                                size: 40,
                                backgroundColor: colorScheme.outlineVariant
                                    .withValues(alpha: 0.2),
                                iconColor: canRedo
                                    ? colorScheme.onPrimary
                                    : colorScheme.onPrimary.withValues(
                                        alpha: 0.35,
                                      ),
                              ),
                              AppUIConstants.widgets.horizontalBox$8,
                              AppIconButton(
                                icon: const Icon(Icons.check_rounded, size: 24),
                                onPressed: _isLoading ? null : _onDoneCrop,
                                size: 40,
                                backgroundColor: Colors.green,
                                iconColor: Colors.white,
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 24,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : _deleteCurrentImage,
                                size: 40,
                                backgroundColor: colorScheme.error.withValues(
                                  alpha: 0.8,
                                ),
                                iconColor: colorScheme.onError,
                              ),
                              AppUIConstants.widgets.horizontalBox$8,
                              AppIconButton(
                                icon: const Icon(Icons.crop_rounded, size: 24),
                                onPressed: _isLoading ? null : _onCrop,
                                size: 40,
                                backgroundColor: colorScheme.outlineVariant
                                    .withValues(alpha: 0.2),
                                iconColor: colorScheme.onPrimary,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              if (_isCropping)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        AppUIConstants.spacing.space$16,
                        AppUIConstants.spacing.space$16,
                        AppUIConstants.spacing.space$16,
                        AppUIConstants.spacing.space$24,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppUIConstants.radius.radius$32),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 36,
                            margin: EdgeInsets.only(
                              bottom: AppUIConstants.spacing.space$16,
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppUIConstants.spacing.space$16,
                              ),
                              children: [
                                AspectPresetButton(
                                  ratioLabel:
                                      AppStrings.jobChat.cropPresetOriginal,
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      AppStrings.jobChat.cropPresetOriginal,
                                  colorScheme: colorScheme,
                                  onTap: () => _updateCropAspectRatio(
                                    AppStrings.jobChat.cropPresetOriginal,
                                    0.0,
                                  ),
                                ),
                                AspectPresetButton(
                                  ratioLabel: AppStrings.jobChat.cropPresetFree,
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      AppStrings.jobChat.cropPresetFree,
                                  colorScheme: colorScheme,
                                  onTap: () => _updateCropAspectRatio(
                                    AppStrings.jobChat.cropPresetFree,
                                    null,
                                  ),
                                ),
                                AspectPresetButton(
                                  ratioLabel: '1:1',
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      '1:1',
                                  colorScheme: colorScheme,
                                  onTap: () =>
                                      _updateCropAspectRatio('1:1', 1.0),
                                ),
                                AspectPresetButton(
                                  ratioLabel: '4:3',
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      '4:3',
                                  colorScheme: colorScheme,
                                  onTap: () =>
                                      _updateCropAspectRatio('4:3', 4.0 / 3.0),
                                ),
                                AspectPresetButton(
                                  ratioLabel: '3:2',
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      '3:2',
                                  colorScheme: colorScheme,
                                  onTap: () =>
                                      _updateCropAspectRatio('3:2', 3.0 / 2.0),
                                ),
                                AspectPresetButton(
                                  ratioLabel: '16:9',
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      '16:9',
                                  colorScheme: colorScheme,
                                  onTap: () => _updateCropAspectRatio(
                                    '16:9',
                                    16.0 / 9.0,
                                  ),
                                ),
                                AspectPresetButton(
                                  ratioLabel: '5:4',
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      '5:4',
                                  colorScheme: colorScheme,
                                  onTap: () =>
                                      _updateCropAspectRatio('5:4', 5.0 / 4.0),
                                ),
                                AspectPresetButton(
                                  ratioLabel: '7:5',
                                  isActive:
                                      _aspectRatioLabels[_currentIndex] ==
                                      '7:5',
                                  colorScheme: colorScheme,
                                  onTap: () =>
                                      _updateCropAspectRatio('7:5', 7.0 / 5.0),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: colorScheme.onPrimary.withValues(
                              alpha: 0.15,
                            ),
                            height: 1,
                          ),
                          AppUIConstants.widgets.verticalBox$16,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              EditActionButton(
                                icon: Icons.flip_rounded,
                                label: AppStrings.jobChat.cropActionFlip,
                                onPressed: () {
                                  _editorControllers[_currentIndex].flip();
                                  setState(() {});
                                },
                                colorScheme: colorScheme,
                              ),
                              EditActionButton(
                                icon: Icons.rotate_left_rounded,
                                label: AppStrings.jobChat.cropActionRotateLeft,
                                onPressed: () {
                                  _editorControllers[_currentIndex].rotate(
                                    degree: -90,
                                  );
                                  setState(() {});
                                },
                                colorScheme: colorScheme,
                              ),
                              EditActionButton(
                                icon: Icons.rotate_right_rounded,
                                label: AppStrings.jobChat.cropActionRotateRight,
                                onPressed: () {
                                  _editorControllers[_currentIndex].rotate(
                                    degree: 90,
                                  );
                                  setState(() {});
                                },
                                colorScheme: colorScheme,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(
                              AppUIConstants.radius.radius$16,
                            ),
                            border: Border.all(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary,
                                ),
                              ),
                              AppUIConstants.widgets.verticalBox$16,
                              Text(
                                _isCropping
                                    ? AppStrings.jobChat.cropProcessing
                                    : AppStrings.jobChat.cropSending,
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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

class _ImageCropParams {
  final Uint8List bytes;
  final Rect? cropRect;
  final bool flipY;
  final double rotateDegrees;
  final bool hasRotateDegrees;
  final bool needCrop;

  const _ImageCropParams({
    required this.bytes,
    this.cropRect,
    required this.flipY,
    required this.rotateDegrees,
    required this.hasRotateDegrees,
    required this.needCrop,
  });
}

Uint8List _processImageCrop(_ImageCropParams params) {
  final decodedImage = img.decodeImage(params.bytes);
  if (decodedImage == null) {
    throw Exception('Failed to decode image');
  }

  img.Image processedImage = decodedImage;

  // 1. Bake orientation first
  processedImage = img.bakeOrientation(processedImage);

  // 2. Apply Flip
  if (params.flipY) {
    processedImage = img.flipHorizontal(processedImage);
  }

  // 3. Apply Rotation
  if (params.hasRotateDegrees) {
    processedImage = img.copyRotate(
      processedImage,
      angle: params.rotateDegrees.toInt(),
    );
  }

  // 4. Apply Crop
  if (params.needCrop && params.cropRect != null) {
    processedImage = img.copyCrop(
      processedImage,
      x: params.cropRect!.left.toInt(),
      y: params.cropRect!.top.toInt(),
      width: params.cropRect!.width.toInt(),
      height: params.cropRect!.height.toInt(),
    );
  }

  // Save the cropped image
  return img.encodeJpg(processedImage, quality: 90);
}
