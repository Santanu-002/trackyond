import 'dart:async';
import 'dart:io';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';

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
}
