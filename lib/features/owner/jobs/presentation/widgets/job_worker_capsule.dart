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
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isCompact 
            ? colorScheme.secondaryContainer.withValues(alpha: 0.7)
            : colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: (isCompact ? colorScheme.secondary : colorScheme.primary)
              .withValues(alpha: 0.2),
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
              color: isCompact 
                  ? colorScheme.onSecondaryContainer 
                  : colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: Icon(
              Icons.close_rounded,
              size: isCompact ? 14 : 16,
              color: isCompact 
                  ? colorScheme.onSecondaryContainer 
                  : colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
