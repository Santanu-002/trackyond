import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/attachment_menu.dart';

class AttachmentMenuItemWidget extends GetView<JobChatAttachmentController> {
  final AttachmentMenuItem item;
  final double containerSize;
  final double iconSize;
  final double fontSize;
  final double horizontalPadding;

  const AttachmentMenuItemWidget({
    super.key,
    required this.item,
    required this.containerSize,
    required this.iconSize,
    required this.fontSize,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final color = item.colorResolver(colorScheme);
    final textStyle = context.theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
    );

    return InkWell(
      onTap: item.onTapResolver(controller),
      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: AppUIConstants.spacing.space$6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: color,
                size: iconSize,
              ),
            ),
            SizedBox(height: AppUIConstants.spacing.space$6),
            Text(
              item.label,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
