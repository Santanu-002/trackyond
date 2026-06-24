

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/features/job_chat/data/models/response/media_preview_item.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';

class JobChatAttachmentController extends GetxController {
  final showAttachmentMenu = false.obs;
  final LayerLink layerLink = LayerLink();

  void toggleAttachmentMenu() {
    showAttachmentMenu.value = !showAttachmentMenu.value;
  }

  void _handlePreviewResult(Map<String, dynamic> result) {
    final List<MediaPreviewItem>? items =
        result['items'] as List<MediaPreviewItem>?;
    if (items != null && items.isNotEmpty) {
      final caption = result['caption'] as String? ?? '';
      final reqMsg = result['requestMessage'] as JobChatMessageEntity?;
      final action = result['action'] as String?;

      if (action != null && action.isNotEmpty) {
        final mediaPaths = items.map((e) => e.path).toList();
        Get.find<JobChatActionController>().executeActionWithMedia(
          actionString: action,
          mediaPaths: mediaPaths,
          caption: caption,
        );
      } else if (reqMsg != null) {
        final mediaPaths = items.map((e) => e.path).toList();
        Get.find<JobChatActionController>().sendMediaStatusProof(
          imagePaths: mediaPaths,
          caption: caption,
          requestMessage: reqMsg,
        );
      } else {
        Get.find<JobChatController>().sendMediaMessagesBackground(
          items,
          replyingTo: reqMsg,
          caption: caption,
        );
      }
    }
  }

  Future<void> navigateToMediaPreview({
    String? imagePath,
    List<String>? imagePaths,
    JobChatMessageEntity? requestMessage,
    required MediaPreviewType type,
  }) async {
    final result = await Get.toNamed(
      '${AppRoutes.common.mediaPreview}?type=${type.name}',
      arguments: {
        'imagePath': imagePath,
        'imagePaths': imagePaths,
        'requestMessage': requestMessage,
      },
    ) as Map<String, dynamic>?;

    if (result != null) {
      _handlePreviewResult(result);
    }
  }

  Future<void> attachFromCamera() async {
    showAttachmentMenu.value = false;
    try {
      final result = await Get.toNamed(
        AppRoutes.common.camera,
        arguments: {'requestMessage': null, 'skipPreview': false},
      ) as Map<String, dynamic>?;
      if (result == null) return;

      if (result.containsKey('items')) {
        _handlePreviewResult(result);
      } else {
        final String? imagePath = result['path'] as String?;
        if (imagePath == null) return;

        navigateToMediaPreview(
          imagePath: imagePath,
          requestMessage: null,
          type: MediaPreviewType.image,
        );
      }
    } catch (e) {
      AppSnackbar.destructive('Error navigating to preview: $e');
    }
  }

  Future<void> attachFromGallery() async {
    showAttachmentMenu.value = false;
    final picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);
      if (images.isEmpty) return;

      final imagePaths = images.map((img) => img.path).toList();
      navigateToMediaPreview(
        imagePaths: imagePaths,
        requestMessage: null,
        type: MediaPreviewType.image,
      );
    } catch (e) {
      AppSnackbar.destructive('Error picking photo: $e');
    }
  }

  Future<void> attachVideo() async {
    showAttachmentMenu.value = false;
    final picker = ImagePicker();
    try {
      final List<XFile> selectedFiles = await picker.pickMultiVideo();
      final videoPaths = selectedFiles.map((file) => file.path).toList();
      if (videoPaths.isEmpty) return;

      navigateToMediaPreview(
        imagePaths: videoPaths,
        requestMessage: null,
        type: MediaPreviewType.video,
      );
    } catch (e) {
      AppSnackbar.destructive('Error picking video: $e');
    }
  }

  Future<void> attachDocument() async {
    showAttachmentMenu.value = false;
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.any,
      );
      if (result == null) return;
      final paths = result.paths.whereType<String>().toList();
      if (paths.isEmpty) return;

      navigateToMediaPreview(
        imagePaths: paths,
        requestMessage: null,
        type: MediaPreviewType.document,
      );
    } catch (e) {
      AppSnackbar.destructive('Error picking document: $e');
    }
  }

  Future<void> attachPdf() async {
    showAttachmentMenu.value = false;
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null) return;
      final selectedPaths = result.paths.whereType<String>().toList();
      final paths = selectedPaths
          .where((path) => path.toLowerCase().endsWith('.pdf'))
          .toList();
      if (paths.isEmpty) return;

      navigateToMediaPreview(
        imagePaths: paths,
        requestMessage: null,
        type: MediaPreviewType.pdf,
      );
    } catch (e) {
      AppSnackbar.destructive('Error picking PDF: $e');
    }
  }

  Future<void> openCameraForStatusProof(JobChatMessageEntity requestMessage) async {
    final chatController = Get.find<JobChatController>();
    if (chatController.userRole == UserRole.worker) {
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

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    navigateToMediaPreview(
      imagePath: image.path,
      requestMessage: requestMessage,
      type: MediaPreviewType.image,
    );
  }
}
