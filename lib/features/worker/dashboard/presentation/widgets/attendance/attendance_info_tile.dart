import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AttendanceInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const AttendanceInfoTile({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppUIConstants.spacing.space$8,
      children: [
        Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$12,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
