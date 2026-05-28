import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AspectPresetButton extends StatelessWidget {
  final String ratioLabel;
  final bool isActive;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const AspectPresetButton({
    super.key,
    required this.ratioLabel,
    required this.isActive,
    required this.colorScheme,
    required this.onTap,
  });

  Widget _buildAspectPresetIcon(ColorScheme colorScheme, bool isActive) {
    final activeColor = isActive ? colorScheme.onPrimary : colorScheme.onPrimary.withValues(alpha: 0.7);
    final borderPaint = Border.all(color: activeColor, width: 1.5);

    if (ratioLabel == 'Original') {
      return Icon(
        Icons.image_outlined,
        size: 16,
        color: activeColor,
      );
    } else if (ratioLabel == 'Free') {
      return Icon(
        Icons.crop_free_rounded,
        size: 16,
        color: activeColor,
      );
    }

    double width = 16.0;
    double height = 16.0;

    if (ratioLabel == '1:1') {
      width = 14.0;
      height = 14.0;
    } else if (ratioLabel == '4:3') {
      width = 18.0;
      height = 13.5;
    } else if (ratioLabel == '3:2') {
      width = 18.0;
      height = 12.0;
    } else if (ratioLabel == '16:9') {
      width = 20.0;
      height = 11.25;
    } else if (ratioLabel == '5:4') {
      width = 15.0;
      height = 12.0;
    } else if (ratioLabel == '7:5') {
      width = 17.5;
      height = 12.5;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: borderPaint,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: AppUIConstants.spacing.space$8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$12,
          vertical: AppUIConstants.spacing.space$6,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary
              : colorScheme.onPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            AppUIConstants.radius.radius$12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAspectPresetIcon(colorScheme, isActive),
            AppUIConstants.widgets.horizontalBox$8,
            Text(
              ratioLabel,
              style: context.textTheme.labelMedium?.copyWith(
                color: isActive ? colorScheme.onPrimary : colorScheme.onPrimary.withValues(alpha: 0.7),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
