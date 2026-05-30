import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class MediaPreviewLoadingOverlay extends StatelessWidget {
  final String? localLoadingPhase;
  final String? localLoadingCount;
  final double? localLoadingProgress;
  final bool isCropping;

  const MediaPreviewLoadingOverlay({
    super.key,
    this.localLoadingPhase,
    this.localLoadingCount,
    this.localLoadingProgress,
    required this.isCropping,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final controller = Get.find<JobChatController>();

    return Obx(() {
      // Access observable values so Obx registers dependencies
      controller.uploadProgress.value;
      controller.actionLoadingMessage.value;

      double? finalProgress;
      String finalPhase = 'Loading';
      String finalCount = '';

      if (localLoadingPhase != null) {
        finalProgress = localLoadingProgress;
        finalPhase = localLoadingPhase!;
        finalCount = localLoadingCount ?? '';
      } else {
        finalProgress = controller.uploadProgress.value;
        if (finalProgress <= 0) finalProgress = null;

        final message = controller.actionLoadingMessage.value ??
            AppStrings.jobChat.cropSending;

        // Parse out phase and count e.g., "Uploading Photo (1/4)" -> phase: "Uploading Photo", count: "1/4"
        final RegExp regex = RegExp(r'^(.*?)(?:\s+\(([\d\/]+)\))?$');
        final match = regex.firstMatch(message);
        finalPhase = match?.group(1) ?? message;
        finalCount = match?.group(2) ?? '';
      }

      if (isCropping) {
        finalPhase = AppStrings.jobChat.cropProcessing;
        finalCount = '';
        finalProgress = null;
      }

      return Positioned.fill(
        child: Container(
          color: colorScheme.black.withValues(alpha: 0.5),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Center(
              child: Container(
                constraints: BoxConstraints(minWidth: context.width * 0.4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
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
                      color: colorScheme.black.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        value: finalProgress,
                        backgroundColor: colorScheme.onSurface
                            .withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                    AppUIConstants.widgets.verticalBox$8,
                    Text(
                      finalPhase,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppUIConstants.widgets.verticalBox$4,
                    Text(
                      finalCount.isNotEmpty ? finalCount : ' ',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
