import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/widgets/button/chat_action_button.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/camera/presentation/controllers/camera_controller.dart';
import 'package:trackyond/features/camera/presentation/widgets/blinking_red_dot.dart';
import 'package:trackyond/features/camera/presentation/widgets/capture_button.dart';

class CameraPage extends GetView<AppCameraController> {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colorScheme.black,
        body: Obx(() {
          if (!controller.isInitialized) {
            return Center(
              child: CircularProgressIndicator(
                color: context.theme.colorScheme.onPrimary,
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // Full Screen Camera Preview
              Positioned.fill(
                child: ClipRect(
                  child: Transform.scale(
                    scale: _calculatePreviewScale(context, controller.controller!),
                    child: Center(
                      child: CameraPreview(controller.controller!),
                    ),
                  ),
                ),
              ),

              // Overlay controls
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top controls: Back button (left) and Flash button (right)
                    SafeArea(
                      bottom: false,
                      child: AnimatedOpacity(
                        opacity: controller.isRecordingVideo ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: controller.isRecordingVideo,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUIConstants.spacing.space$16,
                              vertical: AppUIConstants.spacing.space$8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ChatActionButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 24,
                                  ),
                                  onPressed: () => Get.back(),
                                  disabled: controller.isCapturing,
                                ),
                                ChatActionButton(
                                  icon: Icon(
                                    _getFlashIcon(controller.flashMode),
                                    size: 24,
                                  ),
                                  onPressed: () => controller.toggleFlash(),
                                  disabled: controller.isCapturing,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom controls: Capture button (center) and Flip button (right)
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: AppUIConstants.spacing.space$24,
                          right: AppUIConstants.spacing.space$24,
                          bottom: AppUIConstants.spacing.space$24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Invisible placeholder box to keep capture button centered
                            const SizedBox(
                              width: 48,
                              height: 110,
                            ),

                            // Capture button in the center
                            CaptureButton(
                              onTap: () async {
                                final path = await controller.capturePhoto();
                                if (path != null) {
                                  controller.handleMediaCaptured(path, false);
                                }
                              },
                              onLongPressStart: () {
                                controller.startVideoRecording();
                              },
                              onLongPressEnd: () async {
                                final path = await controller.stopVideoRecording();
                                if (path != null) {
                                  controller.handleMediaCaptured(path, true);
                                }
                              },
                              videoProgress: controller.videoProgress,
                              isRecording: controller.isRecordingVideo,
                              disabled: controller.isCapturing,
                            ),

                            // Flip camera button on the right
                            AnimatedOpacity(
                              opacity: controller.isRecordingVideo ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: IgnorePointer(
                                ignoring: controller.isRecordingVideo,
                                child: SizedBox(
                                  width: 48,
                                  height: 110,
                                  child: Center(
                                    child: ChatActionButton(
                                      size: 48,
                                      icon: const Icon(
                                        Icons.cameraswitch_rounded,
                                        size: 24,
                                      ),
                                      onPressed: () => controller.flipCamera(),
                                      disabled: controller.isCapturing,
                                    ),
                                  ),
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

              // Top recording timer overlay
              if (controller.isRecordingVideo)
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const BlinkingRedDot(),
                          AppUIConstants.widgets.horizontalBox$8,
                          Text(
                            controller.recordingTime,
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Capturing Overlay Spinner
              if (controller.isCapturing)
                Positioned.fill(
                  child: Container(
                    color: colorScheme.black.withValues(alpha: 0.4),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  double _calculatePreviewScale(BuildContext context, CameraController cameraController) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final cameraRatio = cameraController.value.aspectRatio;

    double scale = deviceRatio * cameraRatio;
    if (scale < 1) {
      scale = 1 / scale;
    }
    return scale;
  }

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.torch:
        return Icons.flashlight_on_rounded;
    }
  }
}
