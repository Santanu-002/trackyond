import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class ThumbnailItem extends StatelessWidget {
  final int index;
  final String path;
  final bool isActive;
  final bool isLoading;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const ThumbnailItem({
    super.key,
    required this.index,
    required this.path,
    required this.isActive,
    required this.isLoading,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: EdgeInsets.only(
          right: AppUIConstants.spacing.space$8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppUIConstants.radius.radius$12,
          ),
          border: Border.all(
            color: isActive ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppUIConstants.radius.radius$12 - 2,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
              if (!isActive)
                Container(
                  color: colorScheme.black.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
