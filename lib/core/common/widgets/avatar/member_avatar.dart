import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    Widget avatarChild;
    if (icon != null) {
      avatarChild = Icon(
        icon,
        color: context.theme.colorScheme.onPrimary,
        size: avatarRadius * 1.2,
      );
    } else if (image != null && image!.isNotEmpty) {
      avatarChild = AppImage(
        imageUrl: image!,
        fit: BoxFit.cover,
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        placeholder: (context, url) => _buildPlaceholder(context, avatarColor, avatarRadius),
        errorWidget: (context, url, error) => _buildPlaceholder(context, avatarColor, avatarRadius),
      );
    } else {
      avatarChild = _buildPlaceholder(context, avatarColor, avatarRadius);
    }

    Widget avatar = Container(
      width: avatarRadius * 2,
      height: avatarRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarColor,
      ),
      child: ClipOval(
        child: avatarChild,
      ),
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

  Widget _buildPlaceholder(
    BuildContext context,
    Color avatarColor,
    double radius,
  ) {
    return Center(
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
        style: context.textTheme.titleMedium?.copyWith(
          color: context.theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: radius * .75,
        ),
      ),
    );
  }
}
