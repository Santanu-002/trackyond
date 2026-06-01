import 'dart:async';
import 'package:camera/camera.dart' as cam;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';

class AppCameraController extends GetxController {
  List<cam.CameraDescription> _cameras = [];
  cam.CameraController? _controller;
  
  final _isInitialized = false.obs;
  final _isCapturing = false.obs;
  final _flashMode = cam.FlashMode.off.obs;
  final _selectedCameraIndex = 0.obs;

  // Video recording states
  final _isRecordingVideo = false.obs;
  final _videoProgress = 0.0.obs;
  final _recordingTime = '00:00'.obs;
  Timer? _recordingTimer;
  DateTime? _recordingStartTime;

  bool get isInitialized => _isInitialized.value;
  bool get isCapturing => _isCapturing.value;
  cam.FlashMode get flashMode => _flashMode.value;
  cam.CameraController? get controller => _controller;

  bool get isRecordingVideo => _isRecordingVideo.value;
  double get videoProgress => _videoProgress.value;
  String get recordingTime => _recordingTime.value;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await cam.availableCameras();
      if (_cameras.isEmpty) {
        AppSnackbar.destructive(AppStrings.camera.noCameraFound);
        return;
      }
      await _setupCameraController();
    } catch (e) {
      debugPrint('Error initializing available cameras: $e');
      AppSnackbar.destructive(AppStrings.camera.failedToAccessCameras);
    }
  }

  Future<void> _setupCameraController() async {
    if (_cameras.isEmpty) return;

    final description = _cameras[_selectedCameraIndex.value];
    final cameraController = cam.CameraController(
      description,
      cam.ResolutionPreset.high,
      enableAudio: true, // Audio enabled for video recording
    );

    _controller = cameraController;

    try {
      await cameraController.initialize();
      await cameraController.setFlashMode(_flashMode.value);
      _isInitialized.value = true;
    } catch (e) {
      debugPrint('Error initializing camera controller: $e');
      AppSnackbar.destructive(AppStrings.camera.failedToStartCamera);
    }
  }

  Future<void> toggleFlash() async {
    if (_controller == null || !isInitialized) return;

    cam.FlashMode nextMode;
    switch (_flashMode.value) {
      case cam.FlashMode.off:
        nextMode = cam.FlashMode.auto;
        break;
      case cam.FlashMode.auto:
        nextMode = cam.FlashMode.always;
        break;
      case cam.FlashMode.always:
        nextMode = cam.FlashMode.torch;
        break;
      case cam.FlashMode.torch:
        nextMode = cam.FlashMode.off;
        break;
    }

    try {
      await _controller!.setFlashMode(nextMode);
      _flashMode.value = nextMode;
    } catch (e) {
      debugPrint('Error setting flash mode: $e');
      AppSnackbar.destructive(AppStrings.camera.failedToSetFlashMode);
    }
  }

  Future<void> flipCamera() async {
    if (_cameras.length < 2 || _controller == null || isRecordingVideo) return;

    _isInitialized.value = false;
    await _controller?.dispose();
    _controller = null;

    _selectedCameraIndex.value = (_selectedCameraIndex.value + 1) % _cameras.length;
    await _setupCameraController();
  }

  Future<String?> capturePhoto() async {
    if (_controller == null || !isInitialized || _isCapturing.value || isRecordingVideo) return null;

    try {
      _isCapturing.value = true;
      final imageFile = await _controller!.takePicture();
      return imageFile.path;
    } catch (e) {
      debugPrint('Error capturing picture: $e');
      AppSnackbar.destructive(AppStrings.camera.failedToCapturePhoto);
      return null;
    } finally {
      _isCapturing.value = false;
    }
  }

  Future<void> startVideoRecording() async {
    if (_controller == null || !isInitialized || _isCapturing.value || isRecordingVideo) return;

    try {
      _isRecordingVideo.value = true;
      _videoProgress.value = 0.0;
      _recordingTime.value = '00:00';
      _recordingStartTime = DateTime.now();

      await _controller!.startVideoRecording();

      _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        if (_recordingStartTime == null) return;
        final elapsed = DateTime.now().difference(_recordingStartTime!);
        final elapsedMs = elapsed.inMilliseconds;
        final progressVal = elapsedMs / 60000.0;

        final secondsTotal = elapsed.inSeconds;
        final minutes = (secondsTotal / 60).floor().toString().padLeft(2, '0');
        final seconds = (secondsTotal % 60).toString().padLeft(2, '0');
        _recordingTime.value = '$minutes:$seconds';

        if (progressVal >= 1.0) {
          _videoProgress.value = 1.0;
          timer.cancel();
          final path = await stopVideoRecording();
          if (path != null) {
            Get.back(result: {'path': path, 'mediaType': MediaPreviewType.video});
          }
        } else {
          _videoProgress.value = progressVal;
        }
      });
    } catch (e) {
      debugPrint('Error starting video recording: $e');
      AppSnackbar.destructive('Failed to start video recording');
      _cleanupRecording();
    }
  }

  Future<String?> stopVideoRecording() async {
    if (_controller == null || !isInitialized || !isRecordingVideo) return null;

    _recordingTimer?.cancel();
    _recordingTimer = null;

    try {
      final videoFile = await _controller!.stopVideoRecording();
      return videoFile.path;
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
      AppSnackbar.destructive('Failed to save video');
      return null;
    } finally {
      _cleanupRecording();
    }
  }

  void _cleanupRecording() {
    _isRecordingVideo.value = false;
    _videoProgress.value = 0.0;
    _recordingTime.value = '00:00';
    _recordingStartTime = null;
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  Future<void> pauseCamera() async {
    if (_controller == null || !isInitialized) return;
    try {
      await _controller!.pausePreview();
    } catch (e) {
      debugPrint('Error pausing camera preview: $e');
    }
  }

  Future<void> resumeCamera() async {
    if (_controller == null || !isInitialized) return;
    try {
      await _controller!.resumePreview();
    } catch (e) {
      debugPrint('Error resuming camera preview: $e');
    }
  }

  Future<void> handleMediaCaptured(String path, bool isVideo) async {
    final args = Get.arguments as Map<String, dynamic>?;
    final bool skipPreview = args?['skipPreview'] as bool? ?? false;
    final requestMessage = args?['requestMessage'];

    if (skipPreview) {
      Get.back(
        result: {
          'path': path,
          'mediaType': isVideo ? MediaPreviewType.video : MediaPreviewType.image,
        },
      );
      return;
    }

    await pauseCamera();

    final result = await Get.toNamed(
      '${AppRoutes.common.mediaPreview}?type=${isVideo ? 'video' : 'image'}',
      arguments: {
        'imagePath': path,
        'requestMessage': requestMessage,
      },
    );

    if (result == true) {
      Get.back();
    } else {
      await resumeCamera();
    }
  }

  @override
  void onClose() {
    _recordingTimer?.cancel();
    _controller?.dispose();
    super.onClose();
  }
}
