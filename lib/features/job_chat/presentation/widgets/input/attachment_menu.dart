import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/attachment_menu_item_widget.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';

class AttachmentMenuItem {
  final IconData icon;
  final String label;
  final Color Function(ColorScheme) colorResolver;
  final VoidCallback Function(JobChatAttachmentController) onTapResolver;

  const AttachmentMenuItem({
    required this.icon,
    required this.label,
    required this.colorResolver,
    required this.onTapResolver,
  });
}

class AttachmentMenu extends GetView<JobChatAttachmentController> {
  const AttachmentMenu({super.key});

  static List<AttachmentMenuItem> get _menuItems => [
        AttachmentMenuItem(
          icon: Icons.camera_alt,
          label: 'Camera',
          colorResolver: (scheme) => scheme.attachmentCamera,
          onTapResolver: (ctrl) => ctrl.attachFromCamera,
        ),
        AttachmentMenuItem(
          icon: Icons.image,
          label: 'Image',
          colorResolver: (scheme) => scheme.attachmentImage,
          onTapResolver: (ctrl) => ctrl.attachFromGallery,
        ),
        AttachmentMenuItem(
          icon: Icons.videocam,
          label: 'Video',
          colorResolver: (scheme) => scheme.attachmentVideo,
          onTapResolver: (ctrl) => ctrl.attachVideo,
        ),
        AttachmentMenuItem(
          icon: Icons.description,
          label: 'Docs',
          colorResolver: (scheme) => scheme.attachmentDocs,
          onTapResolver: (ctrl) => ctrl.attachDocument,
        ),
        AttachmentMenuItem(
          icon: Icons.picture_as_pdf,
          label: 'PDF',
          colorResolver: (scheme) => scheme.attachmentPdf,
          onTapResolver: (ctrl) => ctrl.attachPdf,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final screenWidth = context.width;

    // Cap the menu width at 500 logical pixels and deduct horizontal margins (16 * 2)
    final menuWidth = screenWidth.clamp(0.0, 500.0) - (AppUIConstants.spacing.space$16 * 2);
    final contentWidth = menuWidth - (AppUIConstants.spacing.space$12 * 2); // Deduct container padding
    final itemWidth = contentWidth / _menuItems.length;

    // Dynamically calculate sizes to fit perfectly on any screen size
    final double scaleFactor = (itemWidth / 72.0).clamp(0.8, 1.0);
    final double containerSize = 46.0 * scaleFactor;
    final double iconSize = 22.0 * scaleFactor;
    final double fontSize = 11.0 * scaleFactor;
    final double horizontalPadding = 4.0 * scaleFactor;

    return SizedBox(
      width: menuWidth,
      child: Container(
        margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
          boxShadow: AppUIConstants.shadows.normal,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$12,
                vertical: AppUIConstants.spacing.space$12,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.75), // Translucent frosty color
                borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _menuItems
                    .map(
                      (item) => Expanded(
                        child: AttachmentMenuItemWidget(
                          item: item,
                          containerSize: containerSize,
                          iconSize: iconSize,
                          fontSize: fontSize,
                          horizontalPadding: horizontalPadding,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
