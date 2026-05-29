import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class AttachmentMenuItem {
  final IconData icon;
  final String label;
  final Color Function(ColorScheme) colorResolver;
  final VoidCallback Function(JobChatController) onTapResolver;

  const AttachmentMenuItem({
    required this.icon,
    required this.label,
    required this.colorResolver,
    required this.onTapResolver,
  });
}

class AttachmentMenu extends GetView<JobChatController> {
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

    return Container(
      margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
      padding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$12,
        vertical: AppUIConstants.spacing.space$12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: AppUIConstants.shadows.normal,
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: AppUIConstants.spacing.space$12,
        runSpacing: AppUIConstants.spacing.space$12,
        children: List.generate(
          _menuItems.length,
          (index) => _buildItem(context, _menuItems[index]),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, AttachmentMenuItem item) {
    final colorScheme = context.theme.colorScheme;
    final color = item.colorResolver(colorScheme);
    final textStyle = context.theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 11,
    );

    return InkWell(
      onTap: item.onTapResolver(controller),
      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$8,
          vertical: AppUIConstants.spacing.space$6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: color,
                size: 22,
              ),
            ),
            SizedBox(height: AppUIConstants.spacing.space$6),
            Text(
              item.label,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
