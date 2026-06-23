import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';

class ChatSendButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final double size;

  const ChatSendButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return AppButton.icon(
      icon: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
              ),
            )
          : Icon(
              AppIcons.common.send,
              size: 22,
            ),
      onPressed: isLoading ? () {} : onPressed,
      size: size,
      borderRadius: 100,
      color: colorScheme.primary,
      iconColor: colorScheme.onPrimary,
    );
  }
}
