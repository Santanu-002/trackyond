import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';

class JobChatUploadController extends GetxController {
  final UploadFileUseCase _uploadFileUseCase;

  JobChatUploadController({
    required UploadFileUseCase uploadFileUseCase,
  }) : _uploadFileUseCase = uploadFileUseCase;

  final uploadProgress = 0.0.obs;
  final isActionCancelled = false.obs;
  CancelToken? _cancelToken;

  void cancelCurrentAction() {
    isActionCancelled.value = true;
    _cancelToken?.cancel('Action cancelled by user');
  }

  Future<Either<AppFailure, String>> uploadFile({
    required File file,
    required String path,
    required void Function(int sent, int total) onSendProgress,
  }) async {
    _cancelToken = CancelToken();
    isActionCancelled.value = false;
    
    return _uploadFileUseCase(
      UploadFileParams(
        file: file,
        path: path,
        cancelToken: _cancelToken,
        onSendProgress: onSendProgress,
      ),
    );
  }

  Future<String?> computeAndPrintBlurHash(String imagePath) async {
    try {
      final File file = File(imagePath);
      final bytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        final resized = img.copyResize(decodedImage, width: 100);
        final blurHashObj = BlurHash.encode(resized, numCompX: 4, numCompY: 3);
        final blurHash = blurHashObj.hash;
        debugPrint('\nBlurHash:\n$blurHash\nFor path: $imagePath\n');
        return blurHash;
      }
    } catch (e) {
      debugPrint('Error computing blurhash: $e');
    }
    return null;
  }

  Future<String?> computeVideoBlurHash(String videoPath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 100,
        quality: 50,
      );
      if (thumbPath != null) {
        final blurHash = await computeAndPrintBlurHash(thumbPath);
        final file = File(thumbPath);
        if (await file.exists()) {
          await file.delete();
        }
        return blurHash;
      }
    } catch (e) {
      debugPrint('Error computing video blurhash: $e');
    }
    return null;
  }

  Future<ChatMessageMetadataModel> extractMetadata(String path, JobChatMessageContentType type) async {
    final file = File(path);
    final fileSize = await file.length();
    final fileName = path.split('/').last;
    final ext = path.split('.').last.toLowerCase();
    final mimeType = lookupMimeType(path) ??
        (type == JobChatMessageContentType.video
            ? 'video/mp4'
            : (type == JobChatMessageContentType.image ? 'image/jpeg' : 'application/octet-stream'));

    VideoMetadataModel? videoMetadata;
    ImageMetadataModel? imageMetadata;
    PdfMetadataModel? pdfMetadata;
    DocumentMetadataModel? documentMetadata;

    if (type == JobChatMessageContentType.video) {
      final String? calculatedBlurHash = await computeVideoBlurHash(path);
      int durationSec = 0;
      double aspectRatio = 1.777;
      try {
        final videoPlayerController = VideoPlayerController.file(file);
        await videoPlayerController.initialize();
        durationSec = videoPlayerController.value.duration.inSeconds;
        if (videoPlayerController.value.aspectRatio > 0) {
          aspectRatio = videoPlayerController.value.aspectRatio;
        }
        await videoPlayerController.dispose();
      } catch (e) {
        debugPrint('Error getting video metadata: $e');
      }

      videoMetadata = VideoMetadataModel(
        aspectRatio: aspectRatio,
        duration: durationSec,
        thumbnailBlurHash: calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
      );
    } else if (type == JobChatMessageContentType.image) {
      final String? calculatedBlurHash = await computeAndPrintBlurHash(path);
      int imgWidth = 200;
      int imgHeight = 200;
      try {
        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        imgWidth = frame.image.width;
        imgHeight = frame.image.height;
      } catch (e) {
        debugPrint('Error getting image dimensions: $e');
      }

      imageMetadata = ImageMetadataModel(
        width: imgWidth,
        height: imgHeight,
        blurHash: calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
      );
    } else if (type == JobChatMessageContentType.pdf || ext == 'pdf') {
      int pdfPageCount = 1;
      try {
        final document = await PdfDocument.openFile(path);
        pdfPageCount = document.pagesCount;
        await document.close();
      } catch (e) {
        debugPrint('Error getting PDF page count: $e');
      }

      pdfMetadata = PdfMetadataModel(
        extension: 'pdf',
        pageCount: pdfPageCount,
      );
    } else if (type == JobChatMessageContentType.document) {
      documentMetadata = DocumentMetadataModel(
        extension: ext,
        pageCount: null,
      );
    }

    return ChatMessageMetadataModel(
      fileName: fileName,
      size: AppUtils.formatFileSize(fileSize),
      mimeType: mimeType,
      videoMetadata: videoMetadata,
      imageMetadata: imageMetadata,
      pdfMetadata: pdfMetadata,
      documentMetadata: documentMetadata,
    );
  }
}
