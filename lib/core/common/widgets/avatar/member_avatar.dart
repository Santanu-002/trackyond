import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/utils/avatar_utils.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar_placeholder.dart';

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

    String? imageUrl;
    File? localFile;

    if (image != null && image!.isNotEmpty) {
      if (File(image!).existsSync()) {
        localFile = File(image!);
      } else {
        imageUrl =
            '${ApiEndpoints.baseUrl}${ApiEndpoints.common.download(image!)}';
      }
    }

    Widget avatarChild;
    if (icon != null) {
      avatarChild = Icon(
        icon,
        color: context.theme.colorScheme.onPrimary,
        size: avatarRadius * 1.2,
      );
    } else if (localFile == null && imageUrl != null) {
      avatarChild = ClipRRect(
        borderRadius: BorderRadius.circular(avatarRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: avatarRadius * 2,
          height: avatarRadius * 2,
          placeholder: (context, url) =>
              MemberAvatarPlaceholder(name: name, radius: avatarRadius),
          errorWidget: (context, url, error) =>
              MemberAvatarPlaceholder(name: name, radius: avatarRadius),
        ),
      );
    } else if (localFile == null) {
      avatarChild = MemberAvatarPlaceholder(name: name, radius: avatarRadius);
    } else {
      avatarChild = const SizedBox.shrink();
    }

    Widget avatar = CircleAvatar(
      radius: avatarRadius,
      backgroundColor: avatarColor,
      backgroundImage: localFile != null ? FileImage(localFile) : null,
      child: avatarChild,
    );

    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: avatar,
      );
    }

    return avatar;
  }


}
