import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/utils/app_utils.dart';

class DocumentPreviewWidget extends StatelessWidget {
  final String path;
  final ColorScheme colorScheme;

  const DocumentPreviewWidget({
    super.key,
    required this.path,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = path.split('/').last;
    final file = File(path);
    final ext = path.split('.').last.toLowerCase();
    final isPdf = ext == 'pdf';
    final docIcon = isPdf ? Icons.picture_as_pdf : Icons.description;
    final docIconColor = isPdf
        ? colorScheme.attachmentPdf
        : colorScheme.attachmentDocs;

    return FutureBuilder<int>(
      future: file.exists().then(
        (exists) => exists ? file.length() : Future.value(0),
      ),
      builder: (context, snapshot) {
        final sizeBytes = snapshot.data ?? 0;
        final sizeText = sizeBytes > 0
            ? AppUtils.formatFileSize(sizeBytes)
            : 'Loading size...';

        return Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: docIconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(docIcon, color: docIconColor, size: 64),
                ),
                const SizedBox(height: 24),
                Text(
                  fileName,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  sizeText,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
