import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';

class MemberAvatar extends StatelessWidget {
  final String name;
  final String? image;
  final double? radius;
  final VoidCallback? onPressed;

  const MemberAvatar({
    super.key,
    required this.name,
    this.image,
    this.radius,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final avatarRadius = radius ?? AppUIConstants.radius.radius$24;
    final colorIndex =
        name.hashCode.abs() % AppUIConstants.colors.avatarColors.length;
    final avatarColor = AppUIConstants.colors.avatarColors[colorIndex];

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

    Widget avatar = CircleAvatar(
      radius: avatarRadius,
      backgroundColor: avatarColor,
      backgroundImage: localFile != null ? FileImage(localFile) : null,
      child: localFile == null && imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(avatarRadius),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                placeholder: (context, url) =>
                    _buildPlaceholder(context, avatarColor),
                errorWidget: (context, url, error) =>
                    _buildPlaceholder(context, avatarColor),
              ),
            )
          : (localFile == null
                ? _buildPlaceholder(context, avatarColor)
                : null),
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

  Widget _buildPlaceholder(BuildContext context, Color avatarColor) {
    return Center(
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
        style: context.textTheme.titleMedium?.copyWith(
          color: context.theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
