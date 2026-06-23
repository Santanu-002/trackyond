import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/media_preview_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/components/media_preview_loading_overlay.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/components/media_preview_top_bar.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/components/media_preview_bottom_controls.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/components/media_preview_crop_preset_bar.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/previews/video_preview_widget.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/previews/video_trimmer_widget.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/previews/document_preview_widget.dart';


class MediaPreviewPage extends GetView<MediaPreviewController> {
  const MediaPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: colorScheme.black,
          resizeToAvoidBottomInset: false,
          body: GetBuilder<MediaPreviewController>(
            builder: (_) {
              return Obx(() {
                final activeIndex = controller.currentIndex.value;
                final isCropping = controller.isCropping.value;
                final isLoading = controller.isLoading.value;
                final mediaPaths = controller.mediaPaths;
                final isKeyboardActive = context.mediaQueryViewInsets.bottom > 0;

                final canUndo = activeIndex < controller.editorControllers.length &&
                    controller.editorControllers[activeIndex].canUndo;
                final canRedo = activeIndex < controller.editorControllers.length &&
                    controller.editorControllers[activeIndex].canRedo;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ExtendedImageGesturePageView.builder(
                      controller: controller.pageController,
                      physics: isCropping
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      itemCount: mediaPaths.length,
                      onPageChanged: (index) {
                        if (controller.isAnimatingPage.value) return;
                        controller.currentIndex.value = index;
                        controller.videoControllers.forEach((key, ctrl) {
                          if (key != index) {
                            ctrl.pause();
                          }
                        });
                        if (controller.previewType == MediaPreviewType.video) {
                          controller.initVideoController(index);
                        }
                      },
                      itemBuilder: (context, index) {
                        final path = mediaPaths[index];
                        final file = File(path);

                        if (controller.previewType == MediaPreviewType.video) {
                          controller.initVideoController(index);
                          final videoCtrl = controller.videoControllers[index];
                          if (videoCtrl == null) {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            );
                          }
                          return VideoPreviewWidget(controller: videoCtrl);
                        }

                        if (controller.previewType == MediaPreviewType.document ||
                            controller.previewType == MediaPreviewType.pdf) {
                          return DocumentPreviewWidget(
                            path: path,
                            colorScheme: colorScheme,
                          );
                        }

                        if (isCropping && index == activeIndex) {
                          return ExtendedImage.file(
                            File(controller.originalPaths[index]),
                            fit: BoxFit.contain,
                            mode: ExtendedImageMode.editor,
                            extendedImageEditorKey: controller.editorKeys[index],
                            clearMemoryCacheWhenDispose: false,
                            initEditorConfigHandler: (state) {
                              return EditorConfig(
                                maxScale: 4.0,
                                cropRectPadding: const EdgeInsets.all(20.0),
                                hitTestSize: 20.0,
                                initCropRectType: InitCropRectType.imageRect,
                                cropAspectRatio: controller.aspectRatios[index],
                                controller: controller.editorControllers[index],
                                lineColor: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                editorMaskColorHandler: (context, pointerDown) =>
                                    colorScheme.black.withValues(
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
                            clearMemoryCacheWhenDispose: false,
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
                              controller.handleDoubleTap(state);
                            },
                          );
                        }
                      },
                    ),

                    if (!isCropping)
                      MediaPreviewBottomControls(
                        captionController: controller.captionController,
                        focusNode: controller.focusNode,
                        isKeyboardActive: isKeyboardActive,
                        mediaPaths: mediaPaths,
                        currentIndex: activeIndex,
                        isLoading: isLoading,
                        previewType: controller.previewType,
                        onSend: controller.onSend,
                        onPickMoreMedia: controller.pickMoreMedia,
                        onThumbnailTap: (index) {
                          if (activeIndex == index) return;
                          controller.currentIndex.value = index;
                          controller.isAnimatingPage.value = true;
                          controller.pageController
                              .animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                              .then((_) {
                                controller.isAnimatingPage.value = false;
                              });
                        },
                      ),

                    if (!isCropping && controller.previewType == MediaPreviewType.video)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 60,
                        left: 16,
                        right: 16,
                        child: Builder(
                          builder: (context) {
                            final index = activeIndex;
                            final videoCtrl = controller.videoControllers[index];
                            if (videoCtrl == null || !videoCtrl.value.isInitialized) {
                              return const SizedBox.shrink();
                            }

                            final thumbs = controller.videoThumbnails[index] ?? [];
                            final start = controller.videoStartProgresses[index] ?? 0.0;
                            final end = controller.videoEndProgresses[index] ?? 1.0;
                            final isMuted = controller.videoMutedStates[index] ?? false;
                            final totalSize = controller.fileSizes[index] ?? 0;

                            return VideoTrimmerWidget(
                              controller: videoCtrl,
                              thumbnails: thumbs,
                              startProgress: start,
                              endProgress: end,
                              isMuted: isMuted,
                              totalSize: totalSize,
                              onTrimChanged: (newStart, newEnd) {
                                controller.videoStartProgresses[index] = newStart;
                                controller.videoEndProgresses[index] = newEnd;
                              },
                              onMuteToggled: () => controller.toggleMute(index),
                              onDraggingChanged: (isDragging) {
                                controller.isDraggingTrim.value = isDragging;
                              },
                            );
                          },
                        ),
                      ),

                    MediaPreviewTopBar(
                      isDraggingTrim: controller.isDraggingTrim.value,
                      isVideo: controller.previewType == MediaPreviewType.video,
                      videoController: controller.videoControllers[activeIndex],
                      startProgress: controller.videoStartProgresses[activeIndex] ?? 0.0,
                      endProgress: controller.videoEndProgresses[activeIndex] ?? 1.0,
                      isCropping: isCropping,
                      isLoading: isLoading,
                      canUndo: canUndo,
                      canRedo: canRedo,
                      showCropOption: mediaPaths.isNotEmpty &&
                          controller.previewType == MediaPreviewType.image,
                      onBack: () {
                        if (isCropping) {
                          controller.cancelCrop();
                        } else {
                          Get.back();
                        }
                      },
                      onUndo: controller.onUndo,
                      onRedo: controller.onRedo,
                      onDoneCrop: controller.onDoneCrop,
                      onDelete: controller.deleteCurrentImage,
                      onCrop: controller.onCrop,
                    ),

                    if (isCropping)
                      MediaPreviewCropPresetBar(
                        currentIndex: activeIndex,
                        aspectRatioLabels: controller.aspectRatioLabels,
                        onUpdateCropAspectRatio: controller.updateCropAspectRatio,
                        onFlip: () {
                          controller.editorControllers[activeIndex].flip();
                          controller.update();
                        },
                        onRotateLeft: () {
                          controller.editorControllers[activeIndex].rotate(degree: -90);
                          controller.update();
                        },
                        onRotateRight: () {
                          controller.editorControllers[activeIndex].rotate(degree: 90);
                          controller.update();
                        },
                      ),

                    if (isLoading)
                      MediaPreviewLoadingOverlay(
                        localLoadingPhase: controller.localLoadingPhase.value,
                        localLoadingCount: controller.localLoadingCount.value,
                        localLoadingProgress: controller.localLoadingProgress.value,
                        isCropping: isCropping,
                      ),
                  ],
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
