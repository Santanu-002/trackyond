import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/text/app_highlighted_text.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class MemberInfoRow extends StatelessWidget {
  final String? designation;
  final String? phone;
  final String? highlight;
  final String? accountUid;

  const MemberInfoRow({
    super.key,
    this.designation,
    this.phone,
    this.highlight,
    this.accountUid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: AppHighlightedText(
            text: designation ?? 'Employee',
            highlight: highlight,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.theme.colorScheme.primary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        if (phone != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppUIConstants.spacing.space$8,
            ),
            child: Icon(
              Icons.circle,
              size: 4,
              color: context.theme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.4),
            ),
          ),
          AppHighlightedText(
            text: phone!,
            highlight: highlight,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
