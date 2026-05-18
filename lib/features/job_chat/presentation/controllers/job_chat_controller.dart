import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/user_role.dart';

import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class JobChatController extends GetxController {
  final GetJobMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  JobChatController({
    required GetJobMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
  })  : _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final RxList<JobChatMessageEntity> messages = <JobChatMessageEntity>[].obs;
  
  List<dynamic> get flattenedItems {
    final List<dynamic> items = [];
    if (messages.isEmpty) return items;

    DateTime? lastDate;

    // Messages are sorted by date from backend (asc)
    for (var message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || !messageDate.isAtSameMomentAs(lastDate)) {
        items.add(messageDate);
        lastDate = messageDate;
      }
      items.add(message);
    }
    return items;
  }

  final RxBool isLoading = false.obs;

  String _resolveName(String uid) {
    // Check if it's the worker
    if (uid == job.workerProfileUid) {
      return job.workerName ?? 'Worker';
    }
    
    // Check if it's the creator (admin/owner)
    if (uid == job.createdByProfileUid) {
      return job.createdByName ?? 'Admin';
    }
    
    return 'User';
  }

  String parseMentions(String? text) {
    if (text == null) return '';
    
    final regex = RegExp(r'@\s*\[\s*profileUid\s*#\s*([^\]]+)\s*\]');
    
    return text.replaceAllMapped(regex, (match) {
      final uid = match.group(1);
      return '@${_resolveName(uid ?? '')}';
    });
  }

  List<InlineSpan> parseMentionsToSpans(String? text, TextStyle? baseStyle, TextStyle? mentionStyle) {
    if (text == null) return [];
    
    final List<InlineSpan> spans = [];
    final regex = RegExp(r'@\s*\[\s*profileUid\s*#\s*([^\]]+)\s*\]');
    
    int lastMatchEnd = 0;
    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: baseStyle,
        ));
      }
      
      final uid = match.group(1);
      final name = _resolveName(uid ?? '');
      
      spans.add(TextSpan(
        text: '@$name',
        style: mentionStyle ?? baseStyle?.copyWith(fontWeight: FontWeight.bold),
      ));
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: baseStyle,
      ));
    }
    
    return spans;
  }

  JobChatMessageEntity? get headerMessage {
    try {
      return messages.firstWhere((m) => m.contents.any((c) => JobChatMessageType.fromString(c.type) == JobChatMessageType.header));
    } catch (_) {
      return null;
    }
  }

  final RxBool isOnBreak = false.obs;
  final Rx<UserRole?> _userRole = Rx<UserRole?>(null);
  UserRole? get userRole => _userRole.value;

  final messageController = TextEditingController();
  
  late final Rx<JobEntity> _job;
  JobEntity get job => _job.value;

  @override
  void onInit() {
    super.onInit();
    _job = Rx<JobEntity>(Get.arguments as JobEntity);
    _fetchUserRole();
    fetchMessages();
  }

  Future<void> _fetchUserRole() async {
    final authController = Get.find<AuthController>();
    _userRole.value = await authController.userRole;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> fetchMessages() async {
    isLoading.value = true;
    final result = await _getMessagesUseCase(job.jobId);
    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (data) => messages.assignAll(data),
    );
    isLoading.value = false;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    
    // Optimistic UI update
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMsg = JobChatMessageEntity(
      id: tempId,
      localId: tempId,
      jobId: job.jobId,
      senderName: 'Me',
      senderId: 'me',
      contents: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.text.value,
          message: text,
        ),
      ],
      timestamp: DateTime.now(),
      isMe: true,
    );
    messages.add(tempMsg);

    final result = await _sendMessageUseCase(SendMessageParams(
      message: tempMsg,
    ));

    result.fold(
      (failure) {
        messages.removeWhere((m) => m.id == tempId);
        AppSnackbar.destructive(failure.message);
      },
      (sentMsg) {
        // Replace temp message with real one
        final index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messages[index] = sentMsg;
        }
      },
    );
  }

  void sendMockPhoto() {
    final photoMsg = JobChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: job.jobId,
      senderName: 'Me',
      senderId: 'me',
      contents: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.image.value,
          message: '📸 Photo uploaded as proof of work',
          metadata: {
            'url': 'https://picsum.photos/400/300',
            'width': 400,
            'height': 300,
            'mimeType': 'image/jpeg',
          },
        ),
      ],
      timestamp: DateTime.now(),
      isMe: true,
    );
    messages.add(photoMsg);

    // Activity entry
    final timelineMsg = JobChatMessageEntity(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      jobId: job.jobId,
      authorType: 'system',
      senderName: 'System',
      senderId: 'system',
      contents: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.activity.value,
          message: '📸 Photo uploaded as proof of work',
        ),
      ],
      timestamp: DateTime.now(),
      isMe: false,
    );
    messages.add(timelineMsg);
  }

  void executeAction(String actionLabel) {
    // Mock action execution
    JobStatus newStatus = job.status;
    String timelineText = 'Job status updated to: $actionLabel';
    bool shouldUpdateStatus = false;

    switch (actionLabel) {
      case 'Start Job':
        newStatus = JobStatus.inProgress;
        shouldUpdateStatus = true;
        timelineText = '🚀 Worker started the job';
        break;
      case 'Complete Job':
        newStatus = JobStatus.completed;
        shouldUpdateStatus = true;
        timelineText = '✅ Job completed by worker';
        break;
      case 'Cancel Job':
        newStatus = JobStatus.cancelled;
        shouldUpdateStatus = true;
        timelineText = '❌ Job cancelled';
        break;
      case 'Reopen Job':
        newStatus = JobStatus.pending;
        shouldUpdateStatus = true;
        timelineText = '🔄 Job reopened';
        break;
      case 'Reached':
        timelineText = '📍 Worker reached the location';
        break;
      case 'Take a Break':
        isOnBreak.value = true;
        timelineText = '☕ Worker is taking a break';
        break;
      case 'Resume':
        isOnBreak.value = false;
        timelineText = '🏃 Worker resumed work';
        break;
      case 'Send Location':
        timelineText = '🛰️ Worker shared current location: 23.8103° N, 90.4125° E';
        break;
      case 'Ask Location':
        timelineText = '❓ Owner requested current location';
        break;
      case 'Ask Status':
        timelineText = '❓ Owner requested status update';
        break;
      case 'Status with Proofs':
        timelineText = '📸 Owner requested status update with photo proofs';
        break;
    }

    if (shouldUpdateStatus) {
      _job.value = JobEntity(
        jobId: job.jobId,
        jobTitle: job.jobTitle,
        customerName: job.customerName,
        customerPhone: job.customerPhone,
        customerAddress: job.customerAddress,
        workerProfileUid: job.workerProfileUid,
        workerName: job.workerName,
        workerImage: job.workerImage,
        createdByProfileUid: job.createdByProfileUid,
        createdByName: job.createdByName,
        status: newStatus,
        requirePhotoOnStart: job.requirePhotoOnStart,
        requirePhotoOnComplete: job.requirePhotoOnComplete,
        captureLocation: job.captureLocation,
        createdAt: job.createdAt,
        assignedAt: job.assignedAt,
        updatedAt: DateTime.now(),
      );
    }

    final timelineMsg = JobChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: job.jobId,
      authorType: 'system',
      senderName: 'System',
      senderId: 'system',
      contents: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.activity.value,
          message: timelineText,
        ),
      ],
      timestamp: DateTime.now(),
      isMe: false,
    );
    messages.add(timelineMsg);
    
    AppSnackbar.success('Action: $actionLabel');
  }

  void onBack() => Get.back();

  List<String> get availableActions {
    if (userRole == null) return [];

    if (userRole == UserRole.worker) {
      return _getWorkerActions();
    } else {
      return _getOwnerActions();
    }
  }

  List<String> _getWorkerActions() {
    switch (job.status) {
      case JobStatus.pending:
      case JobStatus.assigned:
        return ['Reached', 'Start Job'];
      case JobStatus.inProgress:
        if (isOnBreak.value) {
          return ['Resume'];
        }
        return ['Take a Break', 'Send Location', 'Complete Job'];
      case JobStatus.completed:
        return [];
      case JobStatus.cancelled:
        return [];
    }
  }

  List<String> _getOwnerActions() {
    switch (job.status) {
      case JobStatus.pending:
      case JobStatus.assigned:
        return ['Cancel Job'];
      case JobStatus.inProgress:
        return ['Ask Location', 'Ask Status', 'Status with Proofs', 'Cancel Job'];
      case JobStatus.completed:
        return ['Reopen Job'];
      case JobStatus.cancelled:
        return ['Reopen Job'];
    }
  }
}
