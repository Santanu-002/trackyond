import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/avatar_utils.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';

class MemberAvatar extends StatelessWidget {
  final String name;
  final String? image;
  final double? radius;
  final IconData? icon;
  final VoidCallback? onPressed;

  const MemberAvatar({
    super.key,
    required this.name,
    this.image,
    this.radius,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final avatarRadius = radius ?? AppUIConstants.radius.radius$24;
    final avatarColor = avatarColorFromName(name);
    final fallbackText = Text(
      name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
      style: context.textTheme.titleMedium?.copyWith(
        color: context.theme.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: avatarRadius * .75,
      ),
    );

    Widget avatarChild;
    if (icon != null) {
      avatarChild = Container(
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatarColor,
        ),
        child: Center(
          child: Icon(
            icon,
            color: context.theme.colorScheme.onPrimary,
            size: avatarRadius * 1.2,
          ),
        ),
      );
    } else if (image != null && image!.isNotEmpty) {
      final ImageProvider imageProvider;
      if (image!.startsWith('assets/')) {
        imageProvider = AssetImage(image!);
      } else if (File(image!).existsSync()) {
        imageProvider = FileImage(File(image!));
      } else {
        final fullUrl = AppImage.getFullUrl(image!);
        imageProvider = CachedNetworkImageProvider(fullUrl);
      }

      avatarChild = SizedBox(
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        child: OctoImage.fromSet(
          fit: BoxFit.cover,
          image: imageProvider,
          octoSet: OctoSet.circleAvatar(
            backgroundColor: avatarColor,
            text: fallbackText,
          ),
        ),
      );
    } else {
      avatarChild = Container(
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatarColor,
        ),
        child: Center(child: fallbackText),
      );
    }

    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: avatarChild,
      );
    }

    return avatarChild;
  }
}
