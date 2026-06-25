import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackyond/core/utils/file_type_icon_resolver.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class DocumentBubbleItem extends StatefulWidget {
  final JobChatMessageContentEntity doc;
  final bool isMe;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String? messageUid;
  final bool isPending;

  const DocumentBubbleItem({
    super.key,
    required this.doc,
    required this.isMe,
    required this.colorScheme,
    required this.textTheme,
    this.messageUid,
    this.isPending = false,
  });

  @override
  State<DocumentBubbleItem> createState() => _DocumentBubbleItemState();
}

class _DocumentBubbleItemState extends State<DocumentBubbleItem> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  CancelToken? _cancelToken;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfDownloaded();
  }

  Future<String> _getPublicDownloadPath(String fileName) async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
      dir ??= await getApplicationSupportDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    return '${dir.path}/$fileName';
  }

  Future<void> _checkIfDownloaded() async {
    final fileName = widget.doc.metadata?['fileName'] as String? ?? widget.doc.content?.split('/').last ?? 'Document';
    try {
      final filePath = await _getPublicDownloadPath(fileName);
      final file = File(filePath);
      final exists = await file.exists();
      if (mounted) {
        setState(() {
          _isDownloaded = exists;
        });
      }
    } catch (e) {
      debugPrint('Error checking if downloaded: $e');
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    if (_isDownloading) {
      try {
        final chatController = Get.find<JobChatController>();
        final downloadId = widget.doc.content ?? (widget.doc.metadata?['fileName'] as String? ?? 'Document');
        chatController.activeDownloads.remove(downloadId);
      } catch (_) {}
    }
    super.dispose();
  }

  Future<void> _openDocument() async {
    final fileName = widget.doc.metadata?['fileName'] as String? ?? widget.doc.content?.split('/').last ?? 'Document';
    final contentPath = widget.doc.content ?? '';
    final mimeType = widget.doc.metadata?['mimeType'] as String? ?? '';
    final typeParam = mimeType.isNotEmpty ? mimeType : null;

    // 1. If already downloaded, open the local download file path
    if (_isDownloaded) {
      try {
        final filePath = await _getPublicDownloadPath(fileName);
        final file = File(filePath);
        if (await file.exists()) {
          final result = await OpenFilex.open(
            filePath,
            type: typeParam,
          );
          if (result.type != ResultType.done) {
            AppSnackbar.destructive('Could not open file: ${result.message}');
          }
          return;
        }
      } catch (e) {
        debugPrint('Error opening local file: $e');
      }
    }

    // 2. If it's a local file path (not yet copied to Downloads), open it directly
    if (contentPath.isNotEmpty && !contentPath.startsWith('http') && !contentPath.startsWith('uploads/')) {
      try {
        final localFile = File(contentPath);
        if (await localFile.exists()) {
          final result = await OpenFilex.open(
            contentPath,
            type: typeParam,
          );
          if (result.type != ResultType.done) {
            AppSnackbar.destructive('Could not open file: ${result.message}');
          }
          return;
        }
      } catch (e) {
        debugPrint('Error opening local path: $e');
      }
    }

    // 3. If not downloaded or local path doesn't exist, prompt the user to download
    AppSnackbar.info('Please download the file first to open it.');
  }

  Future<void> _toggleDownload(String fileName) async {
    final chatController = Get.find<JobChatController>();
    final downloadId = widget.doc.content ?? fileName;

    if (_isDownloading) {
      // Cancel download
      _cancelToken?.cancel();
      chatController.activeDownloads.remove(downloadId);
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
      AppSnackbar.info('Download cancelled: $fileName');
    } else {
      // Check concurrency limit
      if (chatController.activeDownloads.length >= 3) {
        AppSnackbar.warn('Maximum of 3 simultaneous downloads allowed.');
        return;
      }

      // Start download
      chatController.activeDownloads.add(downloadId);
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      _cancelToken = CancelToken();

      try {
        final contentPath = widget.doc.content ?? '';
        Uint8List? data;

        // 1. Try to read local file if contentPath is a valid local file
        if (contentPath.isNotEmpty && !contentPath.startsWith('http') && !contentPath.startsWith('uploads/')) {
          final localFile = File(contentPath);
          if (await localFile.exists()) {
            data = await localFile.readAsBytes();
            setState(() {
              _downloadProgress = 1.0;
            });
          }
        }

        // 2. If not local, download from network
        if (data == null && contentPath.isNotEmpty) {
          final fullUrl = AppImage.getFullUrl(contentPath);
          final dio = Dio();
          final response = await dio.get<List<int>>(
            fullUrl,
            cancelToken: _cancelToken,
            options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (received, total) {
              if (total > 0) {
                setState(() {
                  _downloadProgress = received / total;
                });
              }
            },
          );
          if (response.data != null) {
            data = Uint8List.fromList(response.data!);
          }
        }

        if (data != null) {
          final savePath = await _getPublicDownloadPath(fileName);
          final file = File(savePath);
          await file.writeAsBytes(data);

          // Invoke media scanner on Android to register file in downloads/gallery
          if (Platform.isAndroid) {
            try {
              const mediaScannerChannel = MethodChannel('media_scanner_channel');
              await mediaScannerChannel.invokeMethod('scanFile', {'path': savePath});
            } catch (e) {
              debugPrint('Error invoking media scanner: $e');
            }
          }

          AppSnackbar.success('Downloaded: $fileName');
          if (mounted) {
            setState(() {
              _isDownloading = false;
              _downloadProgress = 0.0;
              _isDownloaded = true;
            });
          }
        } else {
          AppSnackbar.destructive('Failed to download file.');
          _resetDownloadState();
        }
      } catch (e) {
        if (e is DioException && CancelToken.isCancel(e)) {
          // Ignore cancel exception as it was handled
        } else {
          AppSnackbar.destructive('Download error: $e');
          _resetDownloadState();
        }
      } finally {
        chatController.activeDownloads.remove(downloadId);
      }
    }
  }

  void _resetDownloadState() {
    if (mounted) {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    final isMe = widget.isMe;
    final colorScheme = widget.colorScheme;
    final textTheme = widget.textTheme;

    final fileName = doc.metadata?['fileName'] as String? ?? doc.content?.split('/').last ?? 'Document';
    final int dotIndex = fileName.lastIndexOf('.');
    final String nameWithoutExt = dotIndex != -1 ? fileName.substring(0, dotIndex) : fileName;
    final String extWithDot = dotIndex != -1 ? fileName.substring(dotIndex) : '';

    final String firstPart;
    final String secondPart;
    if (nameWithoutExt.length > 5) {
      firstPart = nameWithoutExt.substring(0, nameWithoutExt.length - 3);
      secondPart = nameWithoutExt.substring(nameWithoutExt.length - 3) + extWithDot;
    } else {
      firstPart = nameWithoutExt;
      secondPart = extWithDot;
    }

    final fileSize = doc.metadata?['size'] as String? ?? 'Unknown size';
    final mimeType = doc.metadata?['mimeType'] as String? ?? '';
    final isPdf = doc.type == JobChatMessageContentType.pdf || mimeType.contains('pdf') || fileName.toLowerCase().endsWith('.pdf');

    final fileTypeInfo = FileTypeIconResolver.resolve(fileName, colorScheme);
    final docIcon = fileTypeInfo.icon;
    final docIconColor = fileTypeInfo.color;

    final pdfMeta = doc.metadata?['pdfMetadata'] as Map<String, dynamic>?;
    final docMeta = doc.metadata?['documentMetadata'] as Map<String, dynamic>?;
    final pageCount = (pdfMeta?['pageCount'] ?? docMeta?['pageCount']) as int?;
    final subtitleText = isPdf && pageCount != null
        ? '${AppStrings.jobChat.pdfPageCount(pageCount)} • $fileSize'
        : fileSize;
    final chatController = Get.find<JobChatController>();
    final isPending = widget.isPending;

    return Obx(() {
      final isUploading = widget.messageUid != null && chatController.uploadingMedia.contains(widget.messageUid!);
      final isPendingInQueue = widget.messageUid != null && chatController.pendingUploads.contains(widget.messageUid!);
      final isFailed = widget.messageUid != null && chatController.failedUploads.contains(widget.messageUid!);
      final uploadProgress = widget.messageUid != null ? chatController.uploadProgressMap[widget.messageUid!] : null;
      final uploadError = widget.messageUid != null ? chatController.uploadErrorMap[widget.messageUid!] : null;

      final shouldShowRetry = isFailed || uploadError != null || (!isUploading && !isPendingInQueue);

      final Widget rightWidget;
      if (isPending) {
        if (shouldShowRetry) {
          rightWidget = Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () => chatController.retryMessageUpload(widget.messageUid!),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => chatController.cancelMessageUpload(widget.messageUid!),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close_rounded,
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          );
        } else {
          rightWidget = Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    value: uploadProgress,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isMe ? colorScheme.onPrimary : colorScheme.primary,
                    ),
                    backgroundColor: isMe 
                        ? colorScheme.onPrimary.withValues(alpha: 0.2) 
                        : colorScheme.outlineVariant,
                  ),
                ),
                GestureDetector(
                  onTap: () => chatController.cancelMessageUpload(widget.messageUid!),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close_rounded,
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                    size: 14,
                  ),
                ),
              ],
            ),
          );
        }
      } else if (!_isDownloaded) {
        rightWidget = GestureDetector(
          onTap: () => _toggleDownload(fileName),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _isDownloading
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          value: _downloadProgress,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isMe ? colorScheme.onPrimary : colorScheme.primary,
                          ),
                          backgroundColor: isMe 
                              ? colorScheme.onPrimary.withValues(alpha: 0.2) 
                              : colorScheme.outlineVariant,
                        ),
                      ),
                      Icon(
                        CupertinoIcons.xmark,
                        size: 12,
                        color: isMe 
                            ? colorScheme.onPrimary.withValues(alpha: 0.8) 
                            : colorScheme.onSurfaceVariant,
                      ),
                    ],
                  )
                : Icon(
                    CupertinoIcons.arrow_down_to_line,
                    color: isMe 
                        ? colorScheme.onPrimary.withValues(alpha: 0.6) 
                        : colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
          ),
        );
      } else {
        rightWidget = const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: isPending ? null : _openDocument,
        child: Padding(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$4),
          child: Container(
            width: 240,
            padding: EdgeInsets.symmetric(
              horizontal: AppUIConstants.spacing.space$12,
              vertical: AppUIConstants.spacing.space$12,
            ),
            decoration: BoxDecoration(
              color: isMe 
                  ? colorScheme.onPrimary.withValues(alpha: 0.1) 
                  : colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
              border: Border.all(
                color: isMe 
                    ? colorScheme.onPrimary.withValues(alpha: 0.2) 
                    : colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                docIcon is FaIconData
                    ? FaIcon(docIcon, color: docIconColor, size: 28)
                    : Icon(docIcon as IconData, color: docIconColor, size: 28),
                AppUIConstants.widgets.horizontalBox$12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              firstPart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            secondPart,
                            maxLines: 1,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
                        style: textTheme.bodySmall?.copyWith(
                          color: isMe 
                              ? colorScheme.onPrimary.withValues(alpha: 0.7) 
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPending || !_isDownloaded) ...[
                  AppUIConstants.widgets.horizontalBox$8,
                  rightWidget,
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
