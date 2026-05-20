import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nanoid/nanoid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';

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
    DateTime? lastHeaderTime;

    // Messages are sorted by date from backend (asc)
    for (var message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      final isNewDate = lastDate == null || !messageDate.isAtSameMomentAs(lastDate);
      if (isNewDate) {
        items.add(messageDate);
        lastDate = messageDate;
        items.add(message);
        items.add(ChatTimeHeader(message.timestamp));
        lastHeaderTime = message.timestamp;
      } else {
        items.add(message);
        if (lastHeaderTime == null ||
            message.timestamp.difference(lastHeaderTime).abs() > const Duration(hours: 1)) {
          items.add(ChatTimeHeader(message.timestamp));
          lastHeaderTime = message.timestamp;
        }
      }
    }
    return items;
  }

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString(null);

  final RxBool isActionLoading = false.obs;
  final RxnString actionLoadingMessage = RxnString(null);
  final RxnString loadingActionLabel = RxnString(null);

  Future<void> _setPhase(String message) async {
    actionLoadingMessage.value = message;
    await Future.delayed(const Duration(milliseconds: 800));
  }

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
    errorMessage.value = null;
    final result = await _getMessagesUseCase(job.jobId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        AppSnackbar.destructive(failure.message);
      },
      (data) {
        messages.assignAll(data);
      },
    );
    isLoading.value = false;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    
    // Optimistic UI update
    final tempId = nanoid();
    final tempMsg = JobChatMessageEntity(
      uid: tempId,
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
        messages.removeWhere((m) => m.uid == tempId);
        AppSnackbar.destructive(failure.message);
      },
      (sendResult) {
        // Replace temp message with real one
        final index = messages.indexWhere((m) => m.uid == tempId);
        if (index != -1) {
          messages[index] = sendResult.message;
        }
      },
    );
  }

  void sendMockPhoto() {
    final photoMsg = JobChatMessageEntity(
      uid: nanoid(),
      localId: nanoid(),
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
      uid: nanoid(),
      localId: nanoid(),
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

  Future<void> executeAction(String actionLabel) async {
    isActionLoading.value = true;
    loadingActionLabel.value = actionLabel;

    try {
      if (actionLabel == 'Reached') {
        await _setPhase('Checking permissions...');
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          final requestedPermission = await Geolocator.requestPermission();
          if (requestedPermission == LocationPermission.denied ||
              requestedPermission == LocationPermission.deniedForever) {
            AppSnackbar.warn('Location permission is required to mark reached status.');
            return;
          }
        }

        final isEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isEnabled) {
          AppSnackbar.warn('Please enable your GPS/location services.');
          return;
        }

        await _setPhase('Acquiring GPS...');
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Location request timed out. Please check your GPS.');
          },
        );

        await _setPhase('Resolving Address...');
        String address = 'Unknown location';
        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            final place = placemarks[0];
            address =
                "${place.name ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}";
            address = address.replaceAll(RegExp(r',\s*,'), ',').trim();
          }
        } catch (e) {
          debugPrint('Error fetching address: $e');
        }

        await _setPhase('Syncing with server...');

        final author = Get.find<AuthController>();
        final profile = await author.profile;
        final tempLocalId = nanoid();

        final reachedMsg = JobChatMessageEntity(
          uid: tempLocalId,
          localId: tempLocalId,
          jobId: job.jobId,
          authorType: 'user',
          senderName: profile?.name ?? 'Worker',
          senderId: profile?.uid,
          senderProfileUid: profile?.uid,
          contents: [
            JobChatMessageContentEntity(
              type: JobChatMessageType.activity.value,
              message: "I'have reached at the location",
              metadata: {
                'activity_type': 'reached_location',
                'latitude': position.latitude,
                'longitude': position.longitude,
                'address': address,
                'workerName': profile?.name ?? 'Worker',
              },
            ),
          ],
          timestamp: DateTime.now(),
          isMe: true,
        );

        final result = await _sendMessageUseCase(SendMessageParams(message: reachedMsg));
        result.fold(
          (failure) {
            AppSnackbar.destructive(failure.message);
          },
          (sendResult) {
            messages.add(sendResult.message);

            // Update local state with updated allowed actions
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
              status: JobStatus.assigned,
              requirePhotoOnStart: job.requirePhotoOnStart,
              requirePhotoOnComplete: job.requirePhotoOnComplete,
              captureLocation: job.captureLocation,
              createdAt: job.createdAt,
              assignedAt: job.assignedAt,
              updatedAt: DateTime.now(),
              allowedActions: sendResult.allowedActions,
            );
            AppSnackbar.success('Action: Reached');
          },
        );

        return;
      }

      // Mock other actions execution
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
        List<String> newAllowedActions = [];
        if (newStatus == JobStatus.assigned) {
          newAllowedActions = [JobAction.startJob.value];
        } else if (newStatus == JobStatus.inProgress) {
          newAllowedActions = [
            JobAction.takeBreak.value,
            JobAction.sendLocation.value,
            JobAction.completeJob.value,
          ];
        }

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
          allowedActions: newAllowedActions,
        );
      }

      final timelineMsg = JobChatMessageEntity(
        uid: nanoid(),
        localId: nanoid(),
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
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
      loadingActionLabel.value = null;
    }
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
    if (job.status == JobStatus.inProgress && isOnBreak.value) {
      return [JobAction.resume.label];
    }

    return job.allowedActions
        .map((a) => JobAction.fromString(a)?.label)
        .whereType<String>()
        .toList();
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

class ChatTimeHeader {
  final DateTime timestamp;
  const ChatTimeHeader(this.timestamp);
}
