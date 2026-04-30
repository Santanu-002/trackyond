import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class AppHighlightedText extends StatelessWidget {
  final String text;
  final String? highlight;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const AppHighlightedText({
    super.key,
    required this.text,
    this.highlight,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final rawHighlight = highlight?.trim() ?? '';
    if (rawHighlight.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: style,
        textAlign: textAlign,
      );
    }

    // Split highlight query into individual words for cross-field matching
    final queries = rawHighlight
        .toLowerCase()
        .split(' ')
        .where((q) => q.isNotEmpty)
        .toList();

    if (queries.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: style,
        textAlign: textAlign,
      );
    }

    List<TextSpan> spans = [TextSpan(text: text)];

    for (final query in queries) {
      final List<TextSpan> nextSpans = [];
      for (final span in spans) {
        if (span.style != null) {
          // This span is already highlighted, skip it
          nextSpans.add(span);
          continue;
        }

        final spanText = span.text!;
        final lowerSpanText = spanText.toLowerCase();
        int start = 0;
        int indexOfMatch;

        while ((indexOfMatch = lowerSpanText.indexOf(query, start)) != -1) {
          if (indexOfMatch > start) {
            nextSpans.add(TextSpan(text: spanText.substring(start, indexOfMatch)));
          }
          nextSpans.add(TextSpan(
            text: spanText.substring(indexOfMatch, indexOfMatch + query.length),
            style: TextStyle(
              color: context.theme.colorScheme.pending,
              backgroundColor:
                  context.theme.colorScheme.pending.withValues(alpha: 0.1),
            ),
          ));
          start = indexOfMatch + query.length;
        }

        if (start < spanText.length) {
          nextSpans.add(TextSpan(text: spanText.substring(start)));
        }
      }
      spans = nextSpans;
    }

    return Text.rich(
      TextSpan(
        style: style ?? context.textTheme.bodyMedium,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
