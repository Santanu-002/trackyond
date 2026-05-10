import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class MemberCallButton extends StatelessWidget {
  final String phoneNumber;

  const MemberCallButton({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: phoneNumber,
        );
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri);
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          AppIcons.auth.phoneOutlined,
          size: 18,
          color: context.theme.colorScheme.primary,
        ),
      ),
    );
  }
}
