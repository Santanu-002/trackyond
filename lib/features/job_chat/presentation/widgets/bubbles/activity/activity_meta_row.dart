import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class ActivityMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final TextStyle? textStyle;

  const ActivityMetaRow({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        AppUIConstants.widgets.horizontalBox$8,
        Expanded(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
