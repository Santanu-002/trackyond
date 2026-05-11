import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';

class JobWorkerCapsule extends StatelessWidget {
  final MemberProfile worker;
  final VoidCallback onRemove;
  final bool isCompact;

  const JobWorkerCapsule({
    super.key,
    required this.worker,
    required this.onRemove,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final primaryColor = colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MemberAvatar(
            name: worker.name,
            image: worker.image,
            radius: isCompact ? 10 : 12,
          ),
          const SizedBox(width: 6),
          Text(
            worker.name,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: Icon(
              Icons.close_rounded,
              size: isCompact ? 14 : 16,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
