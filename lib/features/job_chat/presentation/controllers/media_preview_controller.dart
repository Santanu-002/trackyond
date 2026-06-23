

import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_native_video_trimmer/flutter_native_video_trimmer.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/data/models/response/media_preview_item.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_upload_controller.dart';







  


class MediaPreviewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Map<int, VideoPlayerController> videoControllers = {};
  final Map<int, List<String>> videoThumbnails = {};
  final videoStartProgresses = <int, double>{}.obs;
  final videoEndProgresses = <int, double>{}.obs;
  final videoMutedStates = <int, bool>{}.obs;
  final Map<int, int> fileSizes = {};

  late final MediaPreviewType previewType;
  final mediaPaths = <String>[].obs;
  final originalPaths = <String>[].obs;
  
  late final List<ImageEditorController> editorControllers;
  late final List<GlobalKey<ExtendedImageEditorState>> editorKeys;
  late final List<double?> aspectRatios;
  late final List<String> aspectRatioLabels;
  late final List<int> savedHistoryIndices;

  late final TextEditingController captionController;
  late final ExtendedPageController pageController;
  final focusNode = FocusNode();
  
  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final isCropping = false.obs;
  final isAnimatingPage = false.obs;
  final isDraggingTrim = false.obs;

  final localLoadingPhase = RxnString(null);
  final localLoadingCount = RxnString(null);
  final localLoadingProgress = RxnDouble(null);

  late final AnimationController doubleTapAnimationController;
  Animation<double>? doubleTapAnimation;
  VoidCallback? doubleTapListener;

  @override
  void onInit() {
    super.onInit();
    final typeString = Get.parameters['type'];
    if (typeString == null) {
      throw AssertionError('type parameter is required in query params');
    }
    previewType = MediaPreviewType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () =>
          throw AssertionError('Invalid type query parameter: $typeString'),
    );

    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      throw AssertionError('Arguments are required for MediaPreviewPage');
    }
    
    if (args['items'] is List<MediaPreviewItem>) {
      final List<MediaPreviewItem> itemsList = List<MediaPreviewItem>.from(args['items'] as List);
      mediaPaths.assignAll(itemsList.map((item) => item.path));
    } else if (args['imagePaths'] is List<String>) {
      mediaPaths.assignAll(List<String>.from(args['imagePaths'] as List<String>));
    } else if (args['imagePaths'] is List) {
      mediaPaths.assignAll(List<String>.from(args['imagePaths'] as List));
    } else {
      final singlePath = args['imagePath'] as String? ?? '';
      mediaPaths.assignAll(singlePath.isNotEmpty ? [singlePath] : []);
    }
    
    originalPaths.assignAll(List<String>.from(mediaPaths));
    
    editorControllers = List<ImageEditorController>.generate(
      mediaPaths.length,
      (_) => ImageEditorController(),
    );
    editorKeys = List<GlobalKey<ExtendedImageEditorState>>.generate(
      mediaPaths.length,
      (_) => GlobalKey<ExtendedImageEditorState>(),
    );
    aspectRatios = List<double?>.generate(mediaPaths.length, (_) => null);
    aspectRatioLabels = List<String>.generate(
      mediaPaths.length,
      (_) => AppStrings.jobChat.cropPresetFree,
    );
    savedHistoryIndices = List<int>.generate(mediaPaths.length, (_) => 0);

    captionController = TextEditingController();
    pageController = ExtendedPageController();
    doubleTapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    if (mediaPaths.isNotEmpty) {
      if (previewType == MediaPreviewType.video) {
        initVideoController(currentIndex.value);
      }
    }
    loadFileSizes();
  }

  @override
  void onClose() {
    captionController.dispose();
    pageController.dispose();
    focusNode.dispose();
    for (final ctrl in editorControllers) {
      ctrl.dispose();
    }
    for (final ctrl in videoControllers.values) {
      ctrl.dispose();
    }
    doubleTapAnimationController.dispose();
    super.onClose();
  }



  Future<void> loadFileSizes() async {
    for (int i = 0; i < mediaPaths.length; i++) {
      try {
        final file = File(mediaPaths[i]);
        final size = await file.length();
        fileSizes[i] = size;
        update();
      } catch (e) {
        debugPrint('Error getting file size: $e');
      }
    }
  }

  void toggleMute(int index) {
    final controller = videoControllers[index];
    if (controller == null) return;
    final isCurrentlyMuted = videoMutedStates[index] ?? false;
    final newMuteState = !isCurrentlyMuted;

    videoMutedStates[index] = newMuteState;
    controller.setVolume(newMuteState ? 0.0 : 1.0);
    update();
  }

  Future<void> generateTrimbarThumbnails(int index) async {
    if (videoThumbnails.containsKey(index)) return;
    final controller = videoControllers[index];
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final durationMs = controller.value.duration.inMilliseconds;
      final tempDir = await getTemporaryDirectory();
      final path = mediaPaths[index];

      final List<Future<String?>> tasks = [];
      const int numThumbs = 8;
      final interval = durationMs ~/ numThumbs;

      for (int i = 0; i < numThumbs; i++) {
        final timeMs = i * interval;
        tasks.add(
          VideoThumbnail.thumbnailFile(
            video: path,
            thumbnailPath: tempDir.path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: 64,
            quality: 40,
            timeMs: timeMs,
          ),
        );
      }

      final List<String?> results = await Future.wait(tasks);
      final validPaths = results.whereType<String>().toList();

      videoThumbnails[index] = validPaths;
      update();
    } catch (e) {
      debugPrint('Error generating trimbar thumbnails: $e');
    }
  }

  void initVideoController(int index) {
    if (previewType != MediaPreviewType.video) return;
    if (videoControllers.containsKey(index)) return;

    final path = mediaPaths[index];
    final controller = VideoPlayerController.file(File(path));
    videoControllers[index] = controller;

    controller.initialize().then((_) {
      final isMuted = videoMutedStates[index] ?? false;
      controller.setVolume(isMuted ? 0.0 : 1.0);
      final startProgress = videoStartProgresses[index] ?? 0.0;
      if (startProgress > 0.0) {
        final duration = controller.value.duration;
        final startMs = (duration.inMilliseconds * startProgress).toInt();
        controller.seekTo(Duration(milliseconds: startMs));
      }
      update();
      generateTrimbarThumbnails(index);
    });

    controller.setLooping(false);
    controller.addListener(() {
      if (isDraggingTrim.value) return;
      if (controller.value.isInitialized) {
        final duration = controller.value.duration;
        final startProgress = videoStartProgresses[index] ?? 0.0;
        final endProgress = videoEndProgresses[index] ?? 1.0;

        final startMs = (duration.inMilliseconds * startProgress).toInt();
        final endMs = (duration.inMilliseconds * endProgress).toInt();

        final positionMs = controller.value.position.inMilliseconds;

        if (positionMs >= endMs) {
          controller.pause();
          controller.seekTo(Duration(milliseconds: startMs));
        }
      }
      update();
    });
  }

  Future<void> pickMoreMedia() async {
    final List<String> newPaths = [];
    final picker = ImagePicker();

    try {
      switch (previewType) {
        case MediaPreviewType.image:
          final List<XFile> images = await picker.pickMultiImage(
            imageQuality: 80,
          );
          newPaths.addAll(images.map((img) => img.path));
          break;
        case MediaPreviewType.video:
          final List<XFile> selectedFiles = await picker.pickMultiVideo();
          newPaths.addAll(selectedFiles.map((file) => file.path));
          break;
        case MediaPreviewType.document:
          final FilePickerResult? result = await FilePicker.pickFiles(
            type: FileType.any,
          );
          if (result != null) {
            newPaths.addAll(result.paths.whereType<String>());
          }
          break;
        case MediaPreviewType.pdf:
          final FilePickerResult? result = await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (result != null) {
            final selectedPaths = result.paths.whereType<String>().toList();
            final pdfPaths = selectedPaths
                .where((path) => path.toLowerCase().endsWith('.pdf'))
                .toList();
            if (pdfPaths.length < selectedPaths.length) {
              AppSnackbar.warn(AppStrings.jobChat.onlyPdfsAllowed);
            }
            newPaths.addAll(pdfPaths);
          }
          break;
      }
    } catch (e) {
      debugPrint('Error picking media: $e');
      AppSnackbar.destructive('Failed to pick files');
      return;
    }

    if (newPaths.isNotEmpty) {
      final oldLength = mediaPaths.length;
      mediaPaths.addAll(newPaths);
      originalPaths.addAll(newPaths);

      for (int i = 0; i < newPaths.length; i++) {
        editorControllers.add(ImageEditorController());
        editorKeys.add(GlobalKey<ExtendedImageEditorState>());
        aspectRatios.add(null);
        aspectRatioLabels.add(AppStrings.jobChat.cropPresetFree);
        savedHistoryIndices.add(0);
      }

      currentIndex.value = oldLength;
      loadFileSizes();
      update();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(oldLength);
        }
      });
    }
  }

  Future<void> onSend() async {
    if (mediaPaths.isEmpty || isLoading.value) return;

    focusNode.unfocus();

    // Collect videos that need physical trimming (non-trivial trim range) or physical muting
    final List<int> videoIndicesToTrim = [];
    if (previewType == MediaPreviewType.video) {
      for (int i = 0; i < mediaPaths.length; i++) {
        final start = videoStartProgresses[i] ?? 0.0;
        final end = videoEndProgresses[i] ?? 1.0;
        final isMuted = videoMutedStates[i] ?? false;
        final videoCtrl = videoControllers[i];
        if (videoCtrl == null || !videoCtrl.value.isInitialized) continue;
        final durationMs = videoCtrl.value.duration.inMilliseconds;
        final startMs = (durationMs * start).toInt();
        final endMs = (durationMs * end).toInt();
        final isFullVideo = startMs <= 50 && endMs >= durationMs - 50;
        if (!isFullVideo || isMuted) videoIndicesToTrim.add(i);
      }
    }

    // Pause all videos before processing
    for (final ctrl in videoControllers.values) {
      if (ctrl.value.isPlaying) ctrl.pause();
    }

    isLoading.value = true;
    localLoadingPhase.value = null;
    localLoadingCount.value = null;
    localLoadingProgress.value = null;

    // Trim videos that need it, updating the paths list in-place
    if (videoIndicesToTrim.isNotEmpty) {
      final total = videoIndicesToTrim.length;
      int completed = 0;

      localLoadingPhase.value = 'Processing';
      localLoadingCount.value = total > 1 ? '1/$total' : '';
      localLoadingProgress.value = 0.0;

      for (int i in videoIndicesToTrim) {
        final path = mediaPaths[i];
        final start = videoStartProgresses[i] ?? 0.0;
        final end = videoEndProgresses[i] ?? 1.0;
        final isMuted = videoMutedStates[i] ?? false;
        final videoCtrl = videoControllers[i]!;
        final durationMs = videoCtrl.value.duration.inMilliseconds;
        final startMs = (durationMs * start).toInt();
        final endMs = (durationMs * end).toInt();

        localLoadingCount.value = total > 1 ? '${completed + 1}/$total' : '';

        try {
          final trimmer = VideoTrimmer();
          await trimmer.loadVideo(path);
          final outputPath = await trimmer.trimVideo(
            startTimeMs: startMs,
            endTimeMs: endMs,
            includeAudio: !isMuted,
          );

          if (outputPath != null) {
            final trimmedFile = File(outputPath);
            if (await trimmedFile.exists() && await trimmedFile.length() > 0) {
              final tempDir = await getTemporaryDirectory();
              final safePath =
                  '${tempDir.path}/trimmed_${i}_${DateTime.now().millisecondsSinceEpoch}.mp4';
              await trimmedFile.copy(safePath);
              mediaPaths[i] = safePath;
            }
          }

          await trimmer.clearCache();
        } catch (e) {
          debugPrint('Trim error for index $i: $e');
        }

        completed++;
        localLoadingProgress.value = completed / total;
      }

      localLoadingPhase.value = 'Finalizing';
      localLoadingCount.value = '';
      await Future.delayed(const Duration(milliseconds: 300));

      localLoadingPhase.value = null;
      localLoadingCount.value = null;
      localLoadingProgress.value = null;
    }

    final args = Get.arguments as Map<String, dynamic>;
    final action = args['action'] as String?;
    final requestMessage = args['requestMessage'] as JobChatMessageEntity?;

    final uploadController = Get.find<JobChatUploadController>();
    final List<MediaPreviewItem> finalItems = [];

    localLoadingPhase.value = 'Analyzing';
    localLoadingProgress.value = 0.0;

    for (int i = 0; i < mediaPaths.length; i++) {
      final path = mediaPaths[i];
      localLoadingCount.value = mediaPaths.length > 1 ? '${i + 1}/${mediaPaths.length}' : '';
      
      JobChatMessageContentType contentType;
      if (previewType == MediaPreviewType.video) {
        contentType = JobChatMessageContentType.video;
      } else if (previewType == MediaPreviewType.image) {
        contentType = JobChatMessageContentType.image;
      } else {
        final isPdf = path.toLowerCase().endsWith('.pdf');
        contentType = isPdf ? JobChatMessageContentType.pdf : JobChatMessageContentType.document;
      }

      final metadata = await uploadController.extractMetadata(path, contentType);
      finalItems.add(
        MediaPreviewItem(
          path: path,
          type: contentType,
          metadata: metadata,
        ),
      );

      localLoadingProgress.value = (i + 1) / mediaPaths.length;
    }

    localLoadingPhase.value = null;
    localLoadingCount.value = null;
    localLoadingProgress.value = null;
    isLoading.value = false;

    Get.back(result: {
      'items': finalItems,
      'caption': captionController.text,
      'action': action,
      'requestMessage': requestMessage,
    });
  }

  Future<void> onCrop() async {
    isCropping.value = true;
  }

  void onUndo() {
    editorControllers[currentIndex.value].undo();
    update();
  }

  void onRedo() {
    editorControllers[currentIndex.value].redo();
    update();
  }

  Future<void> cancelCrop() async {
    final ctrl = editorControllers[currentIndex.value];
    final savedIndex = savedHistoryIndices[currentIndex.value];
    while (ctrl.currentIndex > savedIndex && ctrl.canUndo) {
      ctrl.undo();
    }
    while (ctrl.currentIndex < savedIndex && ctrl.canRedo) {
      ctrl.redo();
    }
    isCropping.value = false;
  }

  Future<void> onDoneCrop() async {
    isLoading.value = true;

    try {
      final activeIndex = currentIndex.value;
      final state = editorKeys[activeIndex].currentState;
      if (state == null) {
        isLoading.value = false;
        return;
      }

      final cropRect = state.getCropRect();
      final editAction = state.editAction;

      final originalPath = originalPaths[activeIndex];
      final file = File(originalPath);

      if (await file.exists()) {
        final bytes = await file.readAsBytes();

        final encodedBytes = await compute(
          _processImageCrop,
          _ImageCropParams(
            bytes: bytes,
            cropRect: cropRect,
            flipY: editAction?.flipY ?? false,
            rotateDegrees: editAction?.rotateDegrees ?? 0.0,
            hasRotateDegrees: editAction?.hasRotateDegrees ?? false,
            needCrop: editAction?.needCrop ?? false,
          ),
        );

        final originalDir = file.parent.path;
        final originalName = file.uri.pathSegments.last;
        final nameWithoutExt = originalName.substring(
          0,
          originalName.lastIndexOf('.'),
        );
        final ext = originalName.substring(originalName.lastIndexOf('.'));
        final newPath =
            '$originalDir/${nameWithoutExt}_edited_${DateTime.now().millisecondsSinceEpoch}$ext';

        final newFile = File(newPath);
        await newFile.writeAsBytes(encodedBytes);

        mediaPaths[activeIndex] = newPath;
        originalPaths[activeIndex] = newPath;
        savedHistoryIndices[activeIndex] = 0;
        isCropping.value = false;
        isLoading.value = false;
        update();

        AppSnackbar.success(AppStrings.jobChat.cropImageSuccess);
      } else {
        throw Exception(AppStrings.jobChat.cropOriginalFileNotFound);
      }
    } catch (e) {
      debugPrint('Error cropping image: $e');
      AppSnackbar.destructive(AppStrings.jobChat.cropImageFailed);
      isLoading.value = false;
    }
  }

  void updateCropAspectRatio(String label, double? ratio) {
    if (aspectRatioLabels[currentIndex.value] == label) return;
    aspectRatios[currentIndex.value] = ratio;
    aspectRatioLabels[currentIndex.value] = label;
    editorControllers[currentIndex.value].updateCropAspectRatio(ratio);
    update();
  }

  void deleteCurrentImage() {
    if (mediaPaths.isEmpty || isLoading.value) return;

    final activeIndex = currentIndex.value;
    editorControllers[activeIndex].dispose();

    if (videoControllers.containsKey(activeIndex)) {
      videoControllers[activeIndex]?.dispose();
      videoControllers.remove(activeIndex);
    }

    final Map<int, VideoPlayerController> shiftedControllers = {};
    videoControllers.forEach((key, ctrl) {
      if (key < activeIndex) {
        shiftedControllers[key] = ctrl;
      } else if (key > activeIndex) {
        shiftedControllers[key - 1] = ctrl;
      }
    });
    videoControllers.clear();
    videoControllers.addAll(shiftedControllers);

    mediaPaths.removeAt(activeIndex);
    originalPaths.removeAt(activeIndex);
    editorControllers.removeAt(activeIndex);
    editorKeys.removeAt(activeIndex);
    aspectRatios.removeAt(activeIndex);
    aspectRatioLabels.removeAt(activeIndex);
    savedHistoryIndices.removeAt(activeIndex);

    if (mediaPaths.isEmpty) {
      Get.back();
    } else {
      if (currentIndex.value >= mediaPaths.length) {
        currentIndex.value = mediaPaths.length - 1;
      }
    }
    update();

    if (mediaPaths.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(currentIndex.value);
        }
      });
    }

    AppSnackbar.success(AppStrings.jobChat.cropImageDeleted);
  }

  void handleDoubleTap(ExtendedImageGestureState state) {
    final pointerDownPosition = state.pointerDownPosition;
    final begin = state.gestureDetails?.totalScale ?? 1.0;
    double end;

    if (doubleTapAnimation != null && doubleTapListener != null) {
      doubleTapAnimation!.removeListener(doubleTapListener!);
    }

    doubleTapAnimationController.stop();
    doubleTapAnimationController.reset();

    if (begin == 1.0) {
      end = 3.0;
    } else {
      end = 1.0;
    }

    doubleTapListener = () {
      state.handleDoubleTap(
        scale: doubleTapAnimation!.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    doubleTapAnimation = doubleTapAnimationController
        .drive(Tween<double>(begin: begin, end: end));

    doubleTapAnimation!.addListener(doubleTapListener!);
    doubleTapAnimationController.forward();
  }
}

class _ImageCropParams {
  final Uint8List bytes;
  final Rect? cropRect;
  final bool flipY;
  final double rotateDegrees;
  final bool hasRotateDegrees;
  final bool needCrop;

  const _ImageCropParams({
    required this.bytes,
    this.cropRect,
    required this.flipY,
    required this.rotateDegrees,
    required this.hasRotateDegrees,
    required this.needCrop,
  });
}

Uint8List _processImageCrop(_ImageCropParams params) {
  final decodedImage = img.decodeImage(params.bytes);
  if (decodedImage == null) {
    throw Exception('Failed to decode image');
  }

  img.Image processedImage = decodedImage;

  processedImage = img.bakeOrientation(processedImage);

  if (params.flipY) {
    processedImage = img.flipHorizontal(processedImage);
  }

  if (params.hasRotateDegrees) {
    processedImage = img.copyRotate(
      processedImage,
      angle: params.rotateDegrees.toInt(),
    );
  }

  if (params.needCrop && params.cropRect != null) {
    processedImage = img.copyCrop(
      processedImage,
      x: params.cropRect!.left.toInt(),
      y: params.cropRect!.top.toInt(),
      width: params.cropRect!.width.toInt(),
      height: params.cropRect!.height.toInt(),
    );
  }

  return img.encodeJpg(processedImage, quality: 90);
}
