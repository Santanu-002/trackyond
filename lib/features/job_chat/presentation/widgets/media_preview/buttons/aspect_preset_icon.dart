import 'package:flutter/material.dart';

class AspectPresetIcon extends StatelessWidget {
  final String ratioLabel;
  final bool isActive;
  final ColorScheme colorScheme;

  const AspectPresetIcon({
    super.key,
    required this.ratioLabel,
    required this.isActive,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
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
}
