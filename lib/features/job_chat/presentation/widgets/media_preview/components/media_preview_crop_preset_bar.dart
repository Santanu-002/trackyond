import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/aspect_preset_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/edit_action_button.dart';

class MediaPreviewCropPresetBar extends StatelessWidget {
  final int currentIndex;
  final List<String> aspectRatioLabels;
  final Function(String, double?) onUpdateCropAspectRatio;
  final VoidCallback onFlip;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;

  const MediaPreviewCropPresetBar({
    super.key,
    required this.currentIndex,
    required this.aspectRatioLabels,
    required this.onUpdateCropAspectRatio,
    required this.onFlip,
    required this.onRotateLeft,
    required this.onRotateRight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final currentLabel = aspectRatioLabels[currentIndex];

    return Positioned(
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
                      ratioLabel: AppStrings.jobChat.cropPresetOriginal,
                      isActive: currentLabel == AppStrings.jobChat.cropPresetOriginal,
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio(
                        AppStrings.jobChat.cropPresetOriginal,
                        0.0,
                      ),
                    ),
                    AspectPresetButton(
                      ratioLabel: AppStrings.jobChat.cropPresetFree,
                      isActive: currentLabel == AppStrings.jobChat.cropPresetFree,
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio(
                        AppStrings.jobChat.cropPresetFree,
                        null,
                      ),
                    ),
                    AspectPresetButton(
                      ratioLabel: '1:1',
                      isActive: currentLabel == '1:1',
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio('1:1', 1.0),
                    ),
                    AspectPresetButton(
                      ratioLabel: '4:3',
                      isActive: currentLabel == '4:3',
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio('4:3', 4.0 / 3.0),
                    ),
                    AspectPresetButton(
                      ratioLabel: '3:2',
                      isActive: currentLabel == '3:2',
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio('3:2', 3.0 / 2.0),
                    ),
                    AspectPresetButton(
                      ratioLabel: '16:9',
                      isActive: currentLabel == '16:9',
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio('16:9', 16.0 / 9.0),
                    ),
                    AspectPresetButton(
                      ratioLabel: '5:4',
                      isActive: currentLabel == '5:4',
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio('5:4', 5.0 / 4.0),
                    ),
                    AspectPresetButton(
                      ratioLabel: '7:5',
                      isActive: currentLabel == '7:5',
                      colorScheme: colorScheme,
                      onTap: () => onUpdateCropAspectRatio('7:5', 7.0 / 5.0),
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
                    onPressed: onFlip,
                    colorScheme: colorScheme,
                  ),
                  EditActionButton(
                    icon: Icons.rotate_left_rounded,
                    label: AppStrings.jobChat.cropActionRotateLeft,
                    onPressed: onRotateLeft,
                    colorScheme: colorScheme,
                  ),
                  EditActionButton(
                    icon: Icons.rotate_right_rounded,
                    label: AppStrings.jobChat.cropActionRotateRight,
                    onPressed: onRotateRight,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
