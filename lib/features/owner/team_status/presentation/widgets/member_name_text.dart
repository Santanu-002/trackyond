import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/text/app_highlighted_text.dart';

class MemberNameText extends StatelessWidget {
  final String name;
  final String? highlight;

  const MemberNameText({
    super.key,
    required this.name,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return AppHighlightedText(
      text: name,
      highlight: highlight,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
