import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:nanoid/nanoid.dart';
import 'package:pdfx/pdfx.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/job_chat/data/models/upload_files_dto.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_upload_controller.dart';

class JobChatActionController extends GetxController {
  final SendMessageUseCase _sendMessageUseCase;

  JobChatActionController({required SendMessageUseCase sendMessageUseCase})
    : _sendMessageUseCase = sendMessageUseCase;

  JobChatController get _chatController => Get.find<JobChatController>();

  JobChatUploadController get _uploadController =>
      Get.find<JobChatUploadController>();

  final isActionLoading = false.obs;
  final actionLoadingMessage = RxnString(null);
  final loadingActionLabel = RxnString(null);
  final loadingActionMessageUid = RxnString(null);

  Future<void> _setPhase(String message) async {
    actionLoadingMessage.value = message;
  }

  List<String> get availableActions {
    if (_chatController.userRole == null) return [];

    if (_chatController.userRole == UserRole.worker) {
      return _chatController.job.allowedActions;
    } else {
      return _getOwnerActions();
    }
  }

  List<String> _getOwnerActions() {
    switch (_chatController.job.status) {
      case JobStatus.pending:
      case JobStatus.assigned:
        return [JobAction.cancelJob.value];
      case JobStatus.inProgress:
        return [
          JobAction.askLocation.value,
          JobAction.askStatus.value,
          JobAction.statusWithProofs.value,
          JobAction.cancelJob.value,
        ];
      case JobStatus.completed:
        return [JobAction.reopenJob.value];
      case JobStatus.cancelled:
        return [JobAction.reopenJob.value];
    }
  }

  Future<Map<String, dynamic>> acquireLocationAndAddress() async {
    await _setPhase(AppStrings.jobChat.checkingPermissions);
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final requestedPermission = await Geolocator.requestPermission();
      if (requestedPermission == LocationPermission.denied ||
          requestedPermission == LocationPermission.deniedForever) {
        throw Exception('Location permission is required.');
      }
    }

    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      throw Exception('Please enable your GPS/location services.');
    }

    await _setPhase(AppStrings.jobChat.acquiringGPS);
    final position =
        await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              throw TimeoutException('Location request timed out.'),
        );

    await _setPhase(AppStrings.jobChat.resolvingAddress);
    String address = 'Unknown location';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        address =
            "${place.name ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}";
        address = address.replaceAll(RegExp(r',\s*,'), ',').trim();
      }
    } catch (e) {
      debugPrint('Error fetching address: $e');
    }

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    };
  }

  Future<void> openMap(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        AppSnackbar.destructive('Could not launch Google Maps');
      }
    } catch (e) {
      debugPrint('Error launching map: $e');
      AppSnackbar.destructive('Error opening maps application');
    }
  }

  Future<void> executeAction(String actionString, {String? messageUid}) async {
    if (_chatController.userRole == UserRole.worker) {
      if (Get.isRegistered<AttendanceController>()) {
        final attendanceController = Get.find<AttendanceController>();
        if (attendanceController.attendanceStatus.value !=
            AttendanceStatus.working) {
          AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
          return;
        }
      } else {
        AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
        return;
      }
    }

    if (_chatController.currentUserId == null ||
        _chatController.currentUserName == null) {
      AppSnackbar.destructive('User information not found. Please try again.');
      return;
    }

    try {
      _uploadController.isActionCancelled.value = false;
      _uploadController.uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = actionString;
      loadingActionMessageUid.value = messageUid;

      final jobAction = JobAction.fromString(actionString);

      if (jobAction == null) {
        AppSnackbar.info('Action: $actionString (Backend integration pending)');
        return;
      }

      final tempLocalId = nanoid(10);
      final List<JobChatMessageContentEntity> content = [];

      final isPhotoAction =
          jobAction == JobAction.startJobWithCapturePhoto ||
          jobAction == JobAction.completeJobWithCapturePhoto;

      if (isPhotoAction) {
        isActionLoading.value = false;
        loadingActionLabel.value = null;
        loadingActionMessageUid.value = null;
        Get.toNamed(
          AppRoutes.common.camera,
          arguments: {'skipPreview': false, 'action': actionString},
        );
        return;
      }

      Map<String, dynamic> locationData = {};
      final bool requiresLocation =
          jobAction != JobAction.askLocation &&
          jobAction != JobAction.askStatus &&
          jobAction != JobAction.statusWithProofs &&
          jobAction != JobAction.cancelJob &&
          jobAction != JobAction.reopenJob;

      if (requiresLocation) {
        locationData = await acquireLocationAndAddress();
      }

      if (_uploadController.isActionCancelled.value) return;

      switch (jobAction) {
        case JobAction.startJobWithCapturePhoto:
        case JobAction.completeJobWithCapturePhoto:
          continue handleActivity;

        handleActivity:
        case JobAction.startJob:
        case JobAction.completeJob:
        case JobAction.reached:
        case JobAction.takeBreak:
        case JobAction.breakOut:
        case JobAction.sendLocation:
        case JobAction.askLocation:
        case JobAction.askStatus:
        case JobAction.statusWithProofs:
          if (_uploadController.isActionCancelled.value) return;
          await _setPhase('Syncing with server...');

          String activityMessage = '';
          JobActivityType activityType = JobActivityType.unknown;

          switch (jobAction) {
            case JobAction.startJob:
            case JobAction.startJobWithCapturePhoto:
              activityMessage = "I have started the job";
              activityType = JobActivityType.startedJob;
              break;
            case JobAction.completeJob:
            case JobAction.completeJobWithCapturePhoto:
              activityMessage = "I have completed the job";
              activityType = JobActivityType.completedJob;
              break;
            case JobAction.reached:
              activityMessage = "I've reached the location";
              activityType = JobActivityType.reachedLocation;
              break;
            case JobAction.takeBreak:
              activityMessage = "I am taking a break";
              activityType = JobActivityType.takeBreak;
              break;
            case JobAction.breakOut:
              activityMessage = "I am resuming work";
              activityType = JobActivityType.breakOut;
              break;
            case JobAction.sendLocation:
              activityMessage = "Here is my current location";
              activityType = JobActivityType.sendLocation;
              break;
            case JobAction.askLocation:
              activityMessage = "Please share your current location.";
              activityType = JobActivityType.askLocation;
              break;
            case JobAction.askStatus:
              activityMessage =
                  "Please provide a status update on your current progress.";
              activityType = JobActivityType.askStatus;
              break;
            case JobAction.statusWithProofs:
              activityMessage =
                  "Please share a status update with photo proofs.";
              activityType = JobActivityType.askStatusProofs;
              break;
            case _:
              activityMessage = "Performed action";
              activityType = JobActivityType.unknown;
              break;
          }

          content.add(
            JobChatMessageContentEntity(
              type: JobChatMessageContentType.text,
              content: activityMessage,
            ),
          );

          final messageMetadata = {
            'activityType': activityType.value,
            'workerName': _chatController.currentUserName!,
            ...locationData,
          };

          final activityMsg = SendMessageEntity(
            localId: tempLocalId,
            jobId: _chatController.job.jobId,
            senderUid: _chatController.currentUserProfileUid,
            content: content,
            type: JobChatMessageType.activity,
            metadata: messageMetadata,
            actionPerformed: jobAction.value,
            createdByAuthorAt: DateTime.now(),
          );

          final result = await _sendMessageUseCase(
            SendMessageParams(messages: [activityMsg]),
          );

          result.fold((failure) => AppSnackbar.destructive(failure.message), (
            sendResult,
          ) {
            _chatController.messages.add(
              sendResult.message.copyWith(isMe: true),
            );
            _chatController.scrollToLast(animate: true);
            if (sendResult.job != null) {
              _chatController.updateJob(sendResult.job!);
            }
            AppSnackbar.success('Action: ${jobAction.label}');
          });
          break;
        case _:
          AppSnackbar.info('Action ${jobAction.label} not implemented yet.');
          break;
      }
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
      loadingActionLabel.value = null;
    }
  }

  Future<bool> executeActionWithMedia({
    required String actionString,
    required List<String> mediaPaths,
    required String caption,
  }) async {
    if (_chatController.userRole == UserRole.worker) {
      if (Get.isRegistered<AttendanceController>()) {
        final attendanceController = Get.find<AttendanceController>();
        if (attendanceController.attendanceStatus.value !=
            AttendanceStatus.working) {
          AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
          return false;
        }
      } else {
        AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
        return false;
      }
    }

    try {
      _uploadController.isActionCancelled.value = false;
      _uploadController.uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = actionString;

      final jobAction = JobAction.fromString(actionString);
      if (jobAction == null) return false;

      final activityType = jobAction == JobAction.startJobWithCapturePhoto
          ? JobActivityType.startedJob
          : JobActivityType.completedJob;

      final List<JobChatMessageContentEntity> content = [];
      if (caption.trim().isNotEmpty) {
        content.add(
          JobChatMessageContentEntity(
            type: JobChatMessageContentType.text,
            content: caption,
          ),
        );
      }

      for (int i = 0; i < mediaPaths.length; i++) {
        final mediaPath = mediaPaths[i];
        final isVideo = AppUtils.isVideoPath(mediaPath);
        final File file = File(mediaPath);
        final uploadPath = _chatController.job.jobId;
        final fileSize = await file.length();
        final fileName = file.path.split('/').last;
        final mimeType =
            lookupMimeType(file.path) ?? (isVideo ? 'video/mp4' : 'image/jpeg');

        if (isVideo) {
          actionLoadingMessage.value =
              'Processing video (${i + 1}/${mediaPaths.length})';
          final String? calculatedBlurHash = await _uploadController
              .computeVideoBlurHash(mediaPath);

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

          if (_uploadController.isActionCancelled.value) return false;
          actionLoadingMessage.value =
              'Uploading video (${i + 1}/${mediaPaths.length})';

          final uploadResult = await _uploadController.uploadFile(
            file: file,
            path: uploadPath,
            onSendProgress: (int sent, int total) {
              if (total > 0) {
                _uploadController.uploadProgress.value = sent / total;
              }
            },
          );

          if (_uploadController.isActionCancelled.value) return false;

          bool uploadSuccess = false;
          String uploadError = '';

          uploadResult.fold(
            (failure) {
              uploadError = failure.message;
            },
            (path) {
              uploadSuccess = true;
              final videoMetadata = {
                'fileName': fileName,
                'size': AppUtils.formatFileSize(fileSize),
                'mimeType': mimeType,
                'videoMetadata': {
                  'aspectRatio': aspectRatio,
                  'duration': durationSec,
                  'thumbnailBlurHash':
                      calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                },
              };
              content.add(
                JobChatMessageContentEntity(
                  type: JobChatMessageContentType.video,
                  content: path,
                  metadata: videoMetadata,
                ),
              );
            },
          );

          if (!uploadSuccess) {
            throw Exception(
              uploadError.isNotEmpty ? uploadError : 'Failed to upload video.',
            );
          }
        } else {
          actionLoadingMessage.value =
              'Processing photo (${i + 1}/${mediaPaths.length})';
          final bytes = await file.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          final imgWidth = frame.image.width;
          final imgHeight = frame.image.height;

          final String? calculatedBlurHash = await _uploadController
              .computeAndPrintBlurHash(mediaPath);

          if (_uploadController.isActionCancelled.value) return false;
          actionLoadingMessage.value =
              'Uploading photo (${i + 1}/${mediaPaths.length})';

          final uploadResult = await _uploadController.uploadFile(
            file: file,
            path: uploadPath,
            onSendProgress: (int sent, int total) {
              if (total > 0) {
                _uploadController.uploadProgress.value = sent / total;
              }
            },
          );

          if (_uploadController.isActionCancelled.value) return false;

          bool uploadSuccess = false;
          String uploadError = '';

          uploadResult.fold(
            (failure) {
              uploadError = failure.message;
            },
            (path) {
              uploadSuccess = true;
              final photoMetadata = {
                'fileName': fileName,
                'size': AppUtils.formatFileSize(fileSize),
                'mimeType': mimeType,
                'imageMetadata': {
                  'width': imgWidth,
                  'height': imgHeight,
                  'blurHash':
                      calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                },
              };
              content.add(
                JobChatMessageContentEntity(
                  type: JobChatMessageContentType.image,
                  content: path,
                  metadata: photoMetadata,
                ),
              );
            },
          );

          if (!uploadSuccess) {
            throw Exception(
              uploadError.isNotEmpty ? uploadError : 'Failed to upload photo.',
            );
          }
        }
      }

      Map<String, dynamic> locationData = await acquireLocationAndAddress();

      if (_uploadController.isActionCancelled.value) return false;
      await _setPhase('Syncing with server...');

      final messageMetadata = {
        'activityType': activityType.value,
        'workerName': _chatController.currentUserName!,
        ...locationData,
      };

      final tempLocalId = nanoid(10);
      final sendMessageEntity = SendMessageEntity(
        localId: tempLocalId,
        jobId: _chatController.job.jobId,
        senderUid: _chatController.currentUserProfileUid,
        content: content,
        type: JobChatMessageType.activity,
        metadata: messageMetadata,
        actionPerformed: jobAction.value,
        createdByAuthorAt: DateTime.now(),
      );

      final result = await _sendMessageUseCase(
        SendMessageParams(messages: [sendMessageEntity]),
      );

      bool sendSuccess = false;
      result.fold(
        (failure) {
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          sendSuccess = true;
          _chatController.messages.add(sendResult.message.copyWith(isMe: true));
          _chatController.scrollToLast(animate: true);
          if (sendResult.job != null) {
            _chatController.updateJob(sendResult.job!);
          }
          AppSnackbar.success('Action: ${jobAction.label}');
        },
      );

      return sendSuccess;
    } catch (e) {
      AppSnackbar.destructive(e.toString());
      return false;
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
      loadingActionLabel.value = null;
    }
  }

  Future<bool> sendMediaStatusProof({
    required List<String> imagePaths,
    required String caption,
    required JobChatMessageEntity requestMessage,
  }) async {
    try {
      _uploadController.isActionCancelled.value = false;
      _uploadController.uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = 'send_status_proof';

      final List<JobChatMessageContentEntity> content = [];

      content.add(
        JobChatMessageContentEntity(
          type: JobChatMessageContentType.text,
          content: caption.isNotEmpty
              ? caption
              : AppStrings.jobChat.statusProofDefaultCaption,
        ),
      );

      for (int i = 0; i < imagePaths.length; i++) {
        final imagePath = imagePaths[i];
        final isVideo = AppUtils.isVideoPath(imagePath);
        final File file = File(imagePath);
        final uploadPath = _chatController.job.jobId;

        final fileSize = await file.length();
        final fileName = file.path.split('/').last;
        final mimeType =
            lookupMimeType(file.path) ?? (isVideo ? 'video/mp4' : 'image/jpeg');

        if (isVideo) {
          actionLoadingMessage.value =
              'Processing video (${i + 1}/${imagePaths.length})';
          final String? calculatedBlurHash = await _uploadController
              .computeVideoBlurHash(imagePath);

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

          if (_uploadController.isActionCancelled.value) return false;
          actionLoadingMessage.value =
              'Uploading video (${i + 1}/${imagePaths.length})';

          final uploadResult = await _uploadController.uploadFile(
            file: file,
            path: uploadPath,
            onSendProgress: (int sent, int total) {
              if (total > 0) {
                _uploadController.uploadProgress.value = sent / total;
              }
            },
          );

          if (_uploadController.isActionCancelled.value) return false;

          bool uploadSuccess = false;
          String uploadError = '';

          uploadResult.fold(
            (failure) {
              uploadError = failure.message;
            },
            (path) {
              uploadSuccess = true;
              final videoMetadata = {
                'fileName': fileName,
                'size': AppUtils.formatFileSize(fileSize),
                'mimeType': mimeType,
                'videoMetadata': {
                  'aspectRatio': aspectRatio,
                  'duration': durationSec,
                  'thumbnailBlurHash':
                      calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                },
              };
              content.add(
                JobChatMessageContentEntity(
                  type: JobChatMessageContentType.video,
                  content: path,
                  metadata: videoMetadata,
                ),
              );
            },
          );

          if (!uploadSuccess) {
            throw Exception(
              uploadError.isNotEmpty ? uploadError : 'Failed to upload video.',
            );
          }
        } else {
          actionLoadingMessage.value =
              'Processing photo (${i + 1}/${imagePaths.length})';
          final bytes = await file.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          final imgWidth = frame.image.width;
          final imgHeight = frame.image.height;

          final String? calculatedBlurHash = await _uploadController
              .computeAndPrintBlurHash(imagePath);

          if (_uploadController.isActionCancelled.value) return false;
          actionLoadingMessage.value =
              'Uploading photo (${i + 1}/${imagePaths.length})';

          final uploadResult = await _uploadController.uploadFile(
            file: file,
            path: uploadPath,
            onSendProgress: (int sent, int total) {
              if (total > 0) {
                _uploadController.uploadProgress.value = sent / total;
              }
            },
          );

          if (_uploadController.isActionCancelled.value) return false;

          bool uploadSuccess = false;
          String uploadError = '';

          uploadResult.fold(
            (failure) {
              uploadError = failure.message;
            },
            (path) {
              uploadSuccess = true;
              final photoMetadata = {
                'fileName': fileName,
                'size': AppUtils.formatFileSize(fileSize),
                'mimeType': mimeType,
                'imageMetadata': {
                  'width': imgWidth,
                  'height': imgHeight,
                  'blurHash':
                      calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                },
              };
              content.add(
                JobChatMessageContentEntity(
                  type: JobChatMessageContentType.image,
                  content: path,
                  metadata: photoMetadata,
                ),
              );
            },
          );

          if (!uploadSuccess) {
            throw Exception(
              uploadError.isNotEmpty ? uploadError : 'Failed to upload photo.',
            );
          }
        }
      }

      if (_uploadController.isActionCancelled.value) return false;
      final locationData = await acquireLocationAndAddress();

      if (_uploadController.isActionCancelled.value) return false;
      actionLoadingMessage.value = AppStrings.jobChat.syncingWithServer;

      final messageMetadata = {
        'activityType': JobActivityType.sendStatus.value,
        'workerName': _chatController.currentUserName!,
        'requestMessageUid': requestMessage.uid,
        ...locationData,
      };

      final tempLocalId = nanoid(10);
      final sendMessageEntity = SendMessageEntity(
        localId: tempLocalId,
        jobId: _chatController.job.jobId,
        senderUid: _chatController.currentUserProfileUid,
        content: content,
        type: JobChatMessageType.activity,
        metadata: messageMetadata,
        createdByAuthorAt: DateTime.now(),
      );

      final result = await _sendMessageUseCase(
        SendMessageParams(messages: [sendMessageEntity]),
      );

      bool sendSuccess = false;
      result.fold(
        (failure) {
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          sendSuccess = true;
          _chatController.messages.add(sendResult.message.copyWith(isMe: true));
          _chatController.scrollToLast(animate: true);
          if (sendResult.job != null) {
            _chatController.updateJob(sendResult.job!);
          }
          AppSnackbar.success(AppStrings.jobChat.statusUpdateSuccess);
        },
      );

      return sendSuccess;
    } catch (e) {
      if (!_uploadController.isActionCancelled.value) {
        AppSnackbar.destructive(e.toString());
      }
      return false;
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
      loadingActionLabel.value = null;
      _uploadController.uploadProgress.value = 0.0;
    }
  }

  Future<bool> sendGeneralMedia({
    required UploadFiles uploadFiles,
    required String caption,
  }) async {
    final paths = uploadFiles.files.map((f) => f.path).toList();
    final previewType = uploadFiles.type;

    try {
      _uploadController.isActionCancelled.value = false;
      _uploadController.uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = 'send_general_media';

      final List<JobChatMessageContentEntity?> uploadedContents = List.filled(
        paths.length,
        null,
      );
      final List<String> uploadErrors = [];
      final Map<int, double> progressMap = {};
      int completedCount = 0;

      void updateOverallProgress() {
        if (paths.isEmpty) return;
        double sum = 0.0;
        for (int i = 0; i < paths.length; i++) {
          sum += progressMap[i] ?? 0.0;
        }
        _uploadController.uploadProgress.value = sum / paths.length;
        final displayCount = (completedCount + 1).clamp(1, paths.length);
        actionLoadingMessage.value =
            '${AppStrings.jobChat.cropSending} ($displayCount/${paths.length})';
      }

      Future<void> uploadFile(int index) async {
        final uploadFileDto = uploadFiles.files[index];
        final path = uploadFileDto.path;
        final isVideo = previewType == MediaPreviewType.video;
        final isDoc =
            previewType == MediaPreviewType.document ||
            previewType == MediaPreviewType.pdf;
        final File file = File(path);
        final uploadPath = _chatController.job.jobId;
        final fileSize = await file.length();
        final fileName = file.path.split('/').last;

        try {
          if (isDoc) {
            final mimeType = uploadFileDto.mimeType;
            final isPdf =
                previewType == MediaPreviewType.pdf ||
                path.toLowerCase().endsWith('.pdf') ||
                mimeType.contains('pdf');
            int? pdfPageCount;
            if (isPdf) {
              try {
                final document = await PdfDocument.openFile(path);
                pdfPageCount = document.pagesCount;
                await document.close();
              } catch (e) {
                debugPrint('Error getting PDF page count during upload: $e');
              }
            }

            final uploadResult = await _uploadController.uploadFile(
              file: file,
              path: uploadPath,
              onSendProgress: (int sent, int total) {
                if (total > 0 && !_uploadController.isActionCancelled.value) {
                  progressMap[index] = sent / total;
                  updateOverallProgress();
                }
              },
            );

            if (_uploadController.isActionCancelled.value) return;

            uploadResult.fold((failure) => uploadErrors.add(failure.message), (
              uploadedPath,
            ) {
              uploadedContents[index] = JobChatMessageContentEntity(
                type: isPdf
                    ? JobChatMessageContentType.pdf
                    : JobChatMessageContentType.document,
                content: uploadedPath,
                metadata: {
                  'fileName': fileName,
                  'size': AppUtils.formatFileSize(fileSize),
                  'mimeType': mimeType,
                  if (isPdf)
                    'pdfMetadata': {
                      'extension': 'pdf',
                      'pageCount': pdfPageCount ?? 1,
                    }
                  else
                    'documentMetadata': {
                      'extension': uploadFileDto.extension,
                      'pageCount': null,
                    },
                },
              );
            });
          } else if (isVideo) {
            final mimeType = lookupMimeType(path) ?? 'video/mp4';
            final String? calculatedBlurHash = await _uploadController
                .computeVideoBlurHash(path);

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

            if (_uploadController.isActionCancelled.value) return;

            final uploadResult = await _uploadController.uploadFile(
              file: file,
              path: uploadPath,
              onSendProgress: (int sent, int total) {
                if (total > 0 && !_uploadController.isActionCancelled.value) {
                  progressMap[index] = sent / total;
                  updateOverallProgress();
                }
              },
            );

            if (_uploadController.isActionCancelled.value) return;

            uploadResult.fold((failure) => uploadErrors.add(failure.message), (
              uploadedPath,
            ) {
              uploadedContents[index] = JobChatMessageContentEntity(
                type: JobChatMessageContentType.video,
                content: uploadedPath,
                metadata: {
                  'fileName': fileName,
                  'size': AppUtils.formatFileSize(fileSize),
                  'mimeType': mimeType,
                  'videoMetadata': {
                    'aspectRatio': aspectRatio,
                    'duration': durationSec,
                    'thumbnailBlurHash':
                        calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                  },
                },
              );
            });
          } else {
            final mimeType = lookupMimeType(path) ?? 'image/jpeg';
            final bytes = await file.readAsBytes();
            final codec = await ui.instantiateImageCodec(bytes);
            final frame = await codec.getNextFrame();
            final imgWidth = frame.image.width;
            final imgHeight = frame.image.height;
            final String? calculatedBlurHash = await _uploadController
                .computeAndPrintBlurHash(path);

            if (_uploadController.isActionCancelled.value) return;

            final uploadResult = await _uploadController.uploadFile(
              file: file,
              path: uploadPath,
              onSendProgress: (int sent, int total) {
                if (total > 0 && !_uploadController.isActionCancelled.value) {
                  progressMap[index] = sent / total;
                  updateOverallProgress();
                }
              },
            );

            if (_uploadController.isActionCancelled.value) return;

            uploadResult.fold((failure) => uploadErrors.add(failure.message), (
              uploadedPath,
            ) {
              uploadedContents[index] = JobChatMessageContentEntity(
                type: JobChatMessageContentType.image,
                content: uploadedPath,
                metadata: {
                  'fileName': fileName,
                  'size': AppUtils.formatFileSize(fileSize),
                  'mimeType': mimeType,
                  'imageMetadata': {
                    'width': imgWidth,
                    'height': imgHeight,
                    'blurHash':
                        calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                  },
                },
              );
            });
          }

          if (!_uploadController.isActionCancelled.value) {
            progressMap[index] = 1.0;
            completedCount++;
            updateOverallProgress();
          }
        } catch (e) {
          uploadErrors.add(e.toString());
        }
      }

      int nextIndex = 0;
      Future<void> worker() async {
        while (nextIndex < paths.length) {
          if (_uploadController.isActionCancelled.value) break;
          final index = nextIndex++;
          await uploadFile(index);
        }
      }

      final int concurrency = paths.length < 3 ? paths.length : 3;
      final List<Future<void>> workers = List.generate(
        concurrency,
        (_) => worker(),
      );
      await Future.wait(workers);

      if (_uploadController.isActionCancelled.value) return false;

      if (uploadErrors.isNotEmpty) {
        throw Exception(uploadErrors.first);
      }

      final List<JobChatMessageContentEntity> nonNullContents = uploadedContents
          .whereType<JobChatMessageContentEntity>()
          .toList();

      if (_chatController.currentUserProfileUid == null) {
        throw Exception('User authentication data missing.');
      }

      final List<SendMessageEntity> messageEntities = [];
      final List<String> tempLocalIds = [];

      for (int i = 0; i < nonNullContents.length; i++) {
        final tempLocalId = nanoid(10);
        tempLocalIds.add(tempLocalId);

        final List<JobChatMessageContentEntity> messageContent = [];

        if (i == 0 && caption.trim().isNotEmpty) {
          messageContent.add(
            JobChatMessageContentEntity(
              type: JobChatMessageContentType.text,
              content: caption.trim(),
            ),
          );
        }

        messageContent.add(nonNullContents[i]);

        messageEntities.add(
          SendMessageEntity(
            localId: tempLocalId,
            jobId: _chatController.job.jobId,
            senderUid: _chatController.currentUserProfileUid,
            content: messageContent,
            createdByAuthorAt: DateTime.now(),
            type: JobChatMessageType.message,
          ),
        );
      }

      if (messageEntities.isEmpty) {
        throw Exception('No media files uploaded successfully.');
      }

      final result = await _sendMessageUseCase(
        SendMessageParams(messages: messageEntities),
      );

      bool sendSuccess = false;
      result.fold(
        (failure) {
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          sendSuccess = true;
          if (sendResult.messages.isNotEmpty) {
            _chatController.messages.addAll(
              sendResult.messages.map((m) => m.copyWith(isMe: true)),
            );
          } else {
            _chatController.messages.add(
              sendResult.message.copyWith(isMe: true),
            );
          }
          _chatController.scrollToLast(animate: true);
          if (sendResult.job != null) {
            _chatController.updateJob(sendResult.job!);
          }
        },
      );

      return sendSuccess;
    } catch (e) {
      AppSnackbar.destructive(e.toString());
      return false;
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
      loadingActionLabel.value = null;
    }
  }
}
