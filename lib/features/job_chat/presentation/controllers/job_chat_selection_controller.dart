import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/dialog/app_alert_dialog.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/usecases/delete_messages_usecase.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';

class JobChatSelectionController extends GetxController {
  final DeleteMessagesUseCase _deleteMessagesUseCase;

  JobChatSelectionController({
    required DeleteMessagesUseCase deleteMessagesUseCase,
  }) : _deleteMessagesUseCase = deleteMessagesUseCase;

  JobChatController get _chatController => Get.find<JobChatController>();

  final isSelectionMode = false.obs;
  final selectedMessageUids = <String>{}.obs;

  void enterSelectionMode(String messageUid) {
    isSelectionMode.value = true;
    selectedMessageUids.add(messageUid);
    HapticFeedback.mediumImpact();
  }

  void toggleSelection(String messageUid) {
    if (selectedMessageUids.contains(messageUid)) {
      selectedMessageUids.remove(messageUid);
      if (selectedMessageUids.isEmpty) {
        exitSelectionMode();
      }
    } else {
      selectedMessageUids.add(messageUid);
    }
  }

  void exitSelectionMode() {
    selectedMessageUids.clear();
    isSelectionMode.value = false;
  }

  bool get canCopySelected {
    if (selectedMessageUids.isEmpty) return false;
    final selectedMessages = _chatController.messages
        .where((msg) => selectedMessageUids.contains(msg.uid))
        .toList();

    for (final msg in selectedMessages) {
      if (msg.deleted) return false;

      final hasMedia = msg.content.any((c) =>
          c.type == JobChatMessageContentType.image ||
          c.type == JobChatMessageContentType.video ||
          c.type == JobChatMessageContentType.document ||
          c.type == JobChatMessageContentType.pdf);
      if (hasMedia) return false;

      final hasText = msg.content.any((c) =>
          c.type == JobChatMessageContentType.text &&
          c.content != null &&
          c.content!.trim().isNotEmpty);
      if (!hasText) return false;
    }
    return true;
  }

  bool get canDeleteSelected => selectedMessageUids.isNotEmpty;

  Future<void> copySelectedMessagesText() async {
    if (selectedMessageUids.isEmpty) return;

    final List<String> formattedMessages = [];
    for (final message in _chatController.messages) {
      if (selectedMessageUids.contains(message.uid)) {
        final senderName = _chatController.getSenderName(message);
        final year = message.timestamp.year.toString();
        final month = message.timestamp.month.toString().padLeft(2, '0');
        final day = message.timestamp.day.toString().padLeft(2, '0');
        final hour = message.timestamp.hour.toString().padLeft(2, '0');
        final minute = message.timestamp.minute.toString().padLeft(2, '0');
        final timeStr = '$day/$month/$year $hour:$minute';

        final List<String> contentParts = [];
        for (final c in message.content) {
          if (c.type == JobChatMessageContentType.text) {
            final textVal = c.content;
            if (textVal != null && textVal.isNotEmpty) {
              contentParts.add(_chatController.parseMentions(textVal));
            }
          }
        }
        final textContents = contentParts.join(' ');

        if (textContents.isNotEmpty) {
          formattedMessages.add('[$timeStr] [$senderName]: $textContents');
        }
      }
    }

    if (formattedMessages.isNotEmpty) {
      final copyText = formattedMessages.join('\n');
      await Clipboard.setData(ClipboardData(text: copyText));
      AppSnackbar.success(AppStrings.jobChat.messagesCopied);
    }

    exitSelectionMode();
  }

  bool canDeleteForEveryone(List<JobChatMessageEntity> selectedMessages) {
    for (final msg in selectedMessages) {
      if (msg.deleted) return false;
      if (msg.type == JobChatMessageType.activity) return false;
    }

    if (_chatController.userRole == UserRole.owner) return true;
    final now = DateTime.now();

    for (final msg in selectedMessages) {
      if (!msg.isMe) return false;
      final diff = now.difference(msg.createdByAuthorAt);
      if (diff.inMinutes >= 15) return false;
    }
    return true;
  }

  Future<void> deleteSelectedMessages(BuildContext context) async {
    if (selectedMessageUids.isEmpty) return;

    final selectedMessages = _chatController.messages
        .where((msg) => selectedMessageUids.contains(msg.uid))
        .toList();

    final showEveryoneOption = canDeleteForEveryone(selectedMessages);
    final colorScheme = context.theme.colorScheme;

    final result = await AppAlertDialog.show<String>(
      context: context,
      message: AppStrings.jobChat.deleteMessagesPrompt(selectedMessages.length),
      actionsVertical: showEveryoneOption,
      actions: showEveryoneOption
          ? [
              AppButton.ghost(
                text: AppStrings.jobChat.deleteForEveryone,
                height: null,
                width: null,
                color: colorScheme.error,
                onPressed: () => Get.back(result: 'forEveryone'),
              ),
              AppButton.ghost(
                text: AppStrings.jobChat.deleteForMe,
                height: null,
                width: null,
                color: colorScheme.primary,
                onPressed: () => Get.back(result: 'forMe'),
              ),
              AppButton.ghost(
                text: AppStrings.common.cancel,
                height: null,
                width: null,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                onPressed: () => Get.back(result: 'cancel'),
              ),
            ]
          : [
              AppButton.ghost(
                text: AppStrings.common.cancel,
                height: null,
                width: null,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                onPressed: () => Get.back(result: 'cancel'),
              ),
              AppButton.ghost(
                text: AppStrings.jobChat.deleteForMe,
                height: null,
                width: null,
                color: colorScheme.primary,
                onPressed: () => Get.back(result: 'forMe'),
              ),
            ],
    );

    if (result == null || result == 'cancel') return;

    final actionController = Get.find<JobChatActionController>();
    actionController.isActionLoading.value = true;
    actionController.actionLoadingMessage.value = 'Deleting messages...';

    try {
      final now = DateTime.now();
      final deleteParams = DeleteMessagesParams(
        jobId: _chatController.job.jobId,
        deleteType: result,
        messageUids: selectedMessages.map((m) => m.uid).toList(),
        deletedByUserAt: now,
      );

      final response = await _deleteMessagesUseCase.call(deleteParams);

      response.fold(
        (failure) {
          AppSnackbar.destructive('Failed to delete messages: ${failure.message}');
        },
        (_) {
          if (result == 'forMe') {
            _chatController.messages.removeWhere((msg) => selectedMessageUids.contains(msg.uid));
          } else if (result == 'forEveryone') {
            final currentUserIdVal = _chatController.currentUserId;
            for (var i = 0; i < _chatController.messages.length; i++) {
              final msg = _chatController.messages[i];
              if (selectedMessageUids.contains(msg.uid)) {
                _chatController.messages[i] = msg.copyWith(
                  deleted: true,
                  deletedByUid: currentUserIdVal,
                  deletedByUserType: _chatController.userRole?.value ?? 'worker',
                  deletedAt: now,
                  deletedByUserAt: now,
                  content: [],
                );
              }
            }
          }
          exitSelectionMode();
        },
      );
    } catch (e) {
      AppSnackbar.destructive('Error deleting messages: $e');
    } finally {
      final actionController = Get.find<JobChatActionController>();
      actionController.isActionLoading.value = false;
      actionController.actionLoadingMessage.value = null;
    }
  }
}
