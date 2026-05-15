import 'package:flutter/material.dart';

class AppStyledText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const AppStyledText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: _parseStyledText(text, baseStyle),
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  List<TextSpan> _parseStyledText(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    
    // Normalize line breaks: replace <br> and <br/> with \n
    final normalizedText = text
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Regex to match <b>...</b>, <i>...</i>, or plain text (including newlines)
    final regex = RegExp(r'<b>(.*?)</b>|<i>(.*?)</i>|([^<>]+)', dotAll: true);
    final matches = regex.allMatches(normalizedText);

    if (matches.isEmpty && normalizedText.isNotEmpty) {
      spans.add(TextSpan(text: normalizedText));
      return spans;
    }

    for (final match in matches) {
      if (match.group(1) != null) {
        // Bold
        spans.add(TextSpan(
          text: match.group(1),
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(2) != null) {
        // Italic
        spans.add(TextSpan(
          text: match.group(2),
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
      } else if (match.group(3) != null) {
        // Plain text
        spans.add(TextSpan(text: match.group(3)));
      }
    }
    
    return spans;
  }
}
