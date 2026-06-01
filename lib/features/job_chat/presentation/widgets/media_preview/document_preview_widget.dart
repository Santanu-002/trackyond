import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_shimmer.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_text.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/core/utils/file_type_icon_resolver.dart';

class DocumentPreviewWidget extends StatelessWidget {
  final String path;
  final ColorScheme colorScheme;

  const DocumentPreviewWidget({
    super.key,
    required this.path,
    required this.colorScheme,
  });

  Future<(int, int?)> _loadDocumentData() async {
    final file = File(path);
    final exists = await file.exists();
    if (!exists) {
      return (0, null);
    }
    final sizeBytes = await file.length();

    final fullFileName = path.split('/').last;
    final int dotIndex = fullFileName.lastIndexOf('.');
    final String extWithDot = dotIndex != -1
        ? fullFileName.substring(dotIndex)
        : '';
    final isPdf = extWithDot.toLowerCase() == '.pdf';

    int? pageCount;
    if (isPdf) {
      try {
        final document = await PdfDocument.openFile(path);
        pageCount = document.pagesCount;
        await document.close();
      } catch (e) {
        debugPrint('Error getting PDF page count: $e');
      }
    }
    return (sizeBytes, pageCount);
  }

  @override
  Widget build(BuildContext context) {
    final fullFileName = path.split('/').last;
    final int dotIndex = fullFileName.lastIndexOf('.');
    final String nameWithoutExt = dotIndex != -1
        ? fullFileName.substring(0, dotIndex)
        : fullFileName;
    final String extWithDot = dotIndex != -1
        ? fullFileName.substring(dotIndex)
        : '';

    final String firstPart;
    final String secondPart;
    if (nameWithoutExt.length > 5) {
      firstPart = nameWithoutExt.substring(0, nameWithoutExt.length - 3);
      secondPart = nameWithoutExt.substring(nameWithoutExt.length - 3) + extWithDot;
    } else {
      firstPart = nameWithoutExt;
      secondPart = extWithDot;
    }

    final fileTypeInfo = FileTypeIconResolver.resolve(path, colorScheme);
    final docIcon = fileTypeInfo.icon;
    final docIconColor = fileTypeInfo.color;

    final isPdf = extWithDot.toLowerCase() == '.pdf';

    return FutureBuilder<(int, int?)>(
      future: _loadDocumentData(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final sizeBytes = data?.$1 ?? 0;
        final pageCount = data?.$2;

        return Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              docIcon is FaIconData
                  ? FaIcon(docIcon, color: docIconColor, size: isPdf ? 56 : 64)
                  : Icon(docIcon as IconData, color: docIconColor, size: isPdf ? 56 : 64),
              isPdf
                  ? AppUIConstants.widgets.verticalBox$16
                  : AppUIConstants.widgets.verticalBox$12,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppUIConstants.spacing.space$24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        firstPart,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      secondPart,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              AppUIConstants.widgets.verticalBox$4,
              snapshot.connectionState == ConnectionState.waiting
                  ? const AppShimmer(
                      child: AppSkeletonText(
                        width: 80,
                        variant: AppSkeletonTextVariant.body,
                      ),
                    )
                  : Text(
                      AppUtils.formatFileSize(sizeBytes),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
              if (isPdf &&
                  (snapshot.connectionState == ConnectionState.waiting ||
                      pageCount != null)) ...[
                AppUIConstants.widgets.verticalBox$4,
                snapshot.connectionState == ConnectionState.waiting
                    ? const AppShimmer(
                        child: AppSkeletonText(
                          width: 60,
                          variant: AppSkeletonTextVariant.caption,
                        ),
                      )
                    : Text(
                        AppStrings.jobChat.pdfPageCount(pageCount!),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary.withValues(alpha: 0.6),
                        ),
                      ),
              ],
            ],
          ),
        );
      },
    );
  }
}
