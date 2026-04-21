import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/chip/app_tag.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class MemberListTile extends StatelessWidget {
  final MemberProfile member;

  const MemberListTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    // Generate a random-ish but deterministic color based on name
    final colorIndex = member.name.length % AppUIConstants.colors.avatarColors.length;
    final avatarColor = AppUIConstants.colors.avatarColors[colorIndex];

    // Determine if image is local file or URL
    ImageProvider? imageProvider;
    if (member.image != null) {
      if (member.image!.startsWith('http')) {
        imageProvider = NetworkImage(member.image!);
      } else {
        imageProvider = FileImage(File(member.image!));
      }
    }

    final isOwner = member.designation.toLowerCase() == 'owner';

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: AppUIConstants.spacing.space$4,
      ),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: avatarColor.withValues(alpha: 0.2),
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? Text(
                member.name.substring(0, 1).toUpperCase(),
                style: context.textTheme.titleMedium?.copyWith(
                  color: avatarColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        member.name,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        member.phone,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: AppTag(
        label: member.designation,
        icon: isOwner ? Icons.verified_user_rounded : null,
        color: isOwner ? context.theme.colorScheme.primary : null,
      ),
    );
  }
}

