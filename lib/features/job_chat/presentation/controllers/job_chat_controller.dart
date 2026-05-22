import 'dart:async';

import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanoid/nanoid.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/chat_item.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/domain/usecases/emit_job_update_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';

class JobChatController extends GetxController {
  final GetJobMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetJobChatMembersUseCase _getChatMembersUseCase;
  final EmitJobUpdateUseCase _emitJobUpdateUseCase;
  final UploadFileUseCase _uploadFileUseCase;

  JobChatController({
    required GetJobMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required GetJobChatMembersUseCase getChatMembersUseCase,
    required EmitJobUpdateUseCase emitJobUpdateUseCase,
    required UploadFileUseCase uploadFileUseCase,
  }) : _getMessagesUseCase = getMessagesUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _getChatMembersUseCase = getChatMembersUseCase,
       _emitJobUpdateUseCase = emitJobUpdateUseCase,
       _uploadFileUseCase = uploadFileUseCase;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final RxList<JobChatMessageEntity> messages = <JobChatMessageEntity>[].obs;
  final RxList<MemberProfile> chatMembers = <MemberProfile>[].obs;
  final RxnString _currentUserProfileUid = RxnString(null);
  final RxnString _currentUserUid = RxnString(null);
  final RxnString _currentUserName = RxnString(null);

  List<ChatItem> get flattenedItems {
    final List<ChatItem> items = [];
    if (messages.isEmpty) return items;

    DateTime? lastDate;
    DateTime? lastMessageTime;

    bool isSameSender(JobChatMessageEntity? a, JobChatMessageEntity? b) {
      if (a == null || b == null) return false;
      if (a.authorType == 'system' || b.authorType == 'system') return false;
      return a.senderId == b.senderId;
    }

    // Messages are sorted by date from backend (asc)
    for (int i = 0; i < messages.length; i++) {
      var message = messages[i];
      var prevMessage = i > 0 ? messages[i - 1] : null;
      var nextMessage = i + 1 < messages.length ? messages[i + 1] : null;

      final isSystemActivity =
          message.authorType == 'system' &&
          (message.type == 'activity' ||
           message.content.any((c) {
             final type = JobChatMessageType.fromString(c.type);
             return type == JobChatMessageType.activity;
           }));

      if (isSystemActivity) {
        continue;
      }

      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      final isNewDate =
          lastDate == null || !messageDate.isAtSameMomentAs(lastDate);
      if (isNewDate) {
        items.add(ChatItem.dateHeader(date: messageDate));
        lastDate = messageDate;
        items.add(
          _mapMessageToChatItem(
            message,
            hasSameSenderAbove: false,
            // New date breaks consecutive grouping visually
            hasSameSenderBelow: isSameSender(message, nextMessage),
          ),
        );
        lastMessageTime = message.timestamp;
      } else {
        bool addedTimeHeader = false;
        if (lastMessageTime == null ||
            message.timestamp.difference(lastMessageTime).abs() >
                const Duration(hours: 1)) {
          items.add(ChatItem.timeHeader(time: message.timestamp));
          addedTimeHeader = true;
        }
        items.add(
          _mapMessageToChatItem(
            message,
            hasSameSenderAbove: addedTimeHeader
                ? false
                : isSameSender(prevMessage, message),
            hasSameSenderBelow: isSameSender(message, nextMessage),
          ),
        );
        lastMessageTime = message.timestamp;
      }
    }
    return items;
  }

  ChatItem _mapMessageToChatItem(
    JobChatMessageEntity message, {
    bool hasSameSenderAbove = false,
    bool hasSameSenderBelow = false,
  }) {
    final hasHeaderContent = message.content.any(
      (c) => JobChatMessageType.fromString(c.type) == JobChatMessageType.header,
    );

    if (hasHeaderContent) {
      return ChatItem.header(message: message);
    }

    final isActivity = message.type == 'activity' || message.content.any(
      (c) =>
          JobChatMessageType.fromString(c.type) == JobChatMessageType.activity,
    );

    if (isActivity) {
      return ChatItem.activityBubble(
        message: message,
        hasSameSenderAbove: hasSameSenderAbove,
        hasSameSenderBelow: hasSameSenderBelow,
      );
    }

    return ChatItem.messageBubble(
      message: message,
      hasSameSenderAbove: hasSameSenderAbove,
      hasSameSenderBelow: hasSameSenderBelow,
    );
  }

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString(null);

  final RxBool isActionLoading = false.obs;
  final RxnString actionLoadingMessage = RxnString(null);
  final RxnString loadingActionLabel = RxnString(null);

  CancelToken? _cancelToken;
  final RxBool isActionCancelled = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  void cancelCurrentAction() {
    isActionCancelled.value = true;
    _cancelToken?.cancel("User cancelled the operation");
    isActionLoading.value = false;
    actionLoadingMessage.value = null;
    loadingActionLabel.value = null;
    uploadProgress.value = 0.0;
  }

  Future<void> _setPhase(String message) async {
    actionLoadingMessage.value = message;
    await Future.delayed(const Duration(milliseconds: 800));
  }

  String _resolveName(String uid) {
    if (uid == _currentUserProfileUid.value || uid == _currentUserUid.value) {
      return 'you';
    }

    // Look up in chatMembers first
    final member = chatMembers.firstWhereOrNull((m) => m.uid == uid);
    if (member != null) {
      return member.name;
    }

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

  List<InlineSpan> parseMentionsToSpans(
    String? text,
    TextStyle? baseStyle,
    TextStyle? mentionStyle,
  ) {
    if (text == null) return [];

    final List<InlineSpan> spans = [];
    final regex = RegExp(r'@\s*\[\s*profileUid\s*#\s*([^\]]+)\s*\]');

    int lastMatchEnd = 0;
    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ),
        );
      }

      final uid = match.group(1);
      final name = _resolveName(uid ?? '');

      spans.add(
        TextSpan(
          text: '@$name',
          style:
              mentionStyle ?? baseStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    return spans;
  }

  JobChatMessageEntity? get headerMessage {
    try {
      return messages.firstWhere(
        (m) => m.content.any(
          (c) =>
              JobChatMessageType.fromString(c.type) ==
              JobChatMessageType.header,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  final Rx<UserRole?> _userRole = Rx<UserRole?>(null);

  UserRole? get userRole => _userRole.value;

  final messageController = TextEditingController();
  final focusNode = FocusNode();
  final RxBool hasFocus = false.obs;

  late final Rx<JobEntity> _job;

  JobEntity get job => _job.value;

  @override
  void onInit() {
    super.onInit();
    _job = Rx<JobEntity>(Get.arguments as JobEntity);

    debugPrint('');
    debugPrint('job: ${_job.value}');
    debugPrint('');

    focusNode.addListener(() {
      hasFocus.value = focusNode.hasFocus;
    });

    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      await _fetchUserRole();
      await _fetchProfileUid();
      await fetchMessages();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchProfileUid() async {
    final authController = Get.find<AuthController>();

    final profile = await authController.profile;
    _currentUserProfileUid.value = profile?.uid;
    _currentUserName.value = profile?.name;

    final user = await authController.user;
    _currentUserUid.value = user?.uid;
  }

  Future<void> _fetchUserRole() async {
    final authController = Get.find<AuthController>();
    _userRole.value = await authController.userRole;
  }

  @override
  void onClose() {
    messageController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  Future<void> fetchMessages() async {
    errorMessage.value = null;

    final membersResult = await _getChatMembersUseCase(job.jobId);
    membersResult.fold(
      (failure) =>
          debugPrint('Error fetching chat members: ${failure.message}'),
      (data) {
        chatMembers.assignAll(data);
      },
    );

    final result = await _getMessagesUseCase(job.jobId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        AppSnackbar.destructive(failure.message);
      },
      (data) {
        final updatedMessages = data.map((m) {
          final isMe = m.senderId == _currentUserUid.value;
          return m.copyWith(isMe: isMe);
        }).toList();
        messages.assignAll(updatedMessages);
      },
    );
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (_currentUserUid.value == null || _currentUserName.value == null) {
      AppSnackbar.destructive('User information not found. Please try again.');
      return;
    }

    if (userRole == UserRole.worker) {
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

    messageController.clear();

    // Optimistic UI update
    final tempId = nanoid();
    final tempMsg = JobChatMessageEntity(
      uid: tempId,
      localId: tempId,
      jobId: job.jobId,
      senderName: _currentUserName.value!,
      senderId: _currentUserUid.value!,
      senderProfileUid: _currentUserProfileUid.value,
      content: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.text.value,
          content: text,
        ),
      ],
      timestamp: DateTime.now(),
      isMe: true,
    );
    messages.add(tempMsg);

    final result = await _sendMessageUseCase(
      SendMessageParams(message: tempMsg),
    );

    result.fold(
      (failure) {
        messages.removeWhere((m) => m.uid == tempId);
        AppSnackbar.destructive(failure.message);
      },
      (sendResult) {
        // Replace temp message with real one
        final index = messages.indexWhere((m) => m.uid == tempId);
        if (index != -1) {
          messages[index] = sendResult.message.copyWith(isMe: true);
        }
        if (sendResult.job != null) {
          _job.value = sendResult.job!;
          _emitJobUpdateUseCase(sendResult.job!);
        }
      },
    );
  }

  void sendMockPhoto() {
    if (_currentUserUid.value == null || _currentUserName.value == null) return;

    final photoMsg = JobChatMessageEntity(
      uid: nanoid(),
      localId: nanoid(),
      jobId: job.jobId,
      senderName: _currentUserName.value!,
      senderId: _currentUserUid.value!,
      senderProfileUid: _currentUserProfileUid.value,
      content: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.image.value,
          content: '📸 Photo uploaded as proof of work',
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
      type: 'activity',
      content: [
        JobChatMessageContentEntity(
          type: JobChatMessageType.activity.value,
          content: '📸 Photo uploaded as proof of work',
        ),
      ],
      timestamp: DateTime.now(),
      isMe: false,
    );
    messages.add(timelineMsg);
  }

  Future<Map<String, dynamic>> _acquireLocationAndAddress() async {
    await _setPhase('Checking permissions...');
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

    await _setPhase('Acquiring GPS...');
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

    await _setPhase('Resolving Address...');
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

  Future<void> executeAction(String actionString) async {
    if (userRole == UserRole.worker) {
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

    if (_currentUserUid.value == null || _currentUserName.value == null) {
      AppSnackbar.destructive('User information not found. Please try again.');
      return;
    }

    try {
      _cancelToken = CancelToken();
      isActionCancelled.value = false;
      uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = actionString;

      final jobAction = JobAction.fromString(actionString);

      if (jobAction == null) {
        // Handle owner/admin specific actions or unknown actions
        AppSnackbar.info('Action: $actionString (Backend integration pending)');
        return;
      }

      // 1. Acquire location (Required for all worker activity actions)
      final locationData = await _acquireLocationAndAddress();
      if (isActionCancelled.value) return;

      String? uploadedPhotoPath;
      Map<String, dynamic>? photoMetadata;
      final tempLocalId = nanoid();
      final List<JobChatMessageContentEntity> content = [];

      switch (jobAction) {
        case JobAction.startJobWithCapturePhoto:
        case JobAction.completeJobWithCapturePhoto:
          final ImageSource? source = await Get.bottomSheet<ImageSource>(
            Container(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Photo Source',
                    style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppUIConstants.widgets.verticalBox$24,
                  ListTile(
                    leading: Icon(Icons.camera_alt_outlined, color: Get.theme.colorScheme.primary),
                    title: const Text('Camera'),
                    onTap: () => Get.back(result: ImageSource.camera),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library_outlined, color: Get.theme.colorScheme.primary),
                    title: const Text('Gallery'),
                    onTap: () => Get.back(result: ImageSource.gallery),
                  ),
                ],
              ),
            ),
          );

          if (source == null || isActionCancelled.value) {
            cancelCurrentAction();
            return;
          }

          await _setPhase('Waiting for photo...');
          final picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: source,
            imageQuality: 80,
          );

          if (image == null) {
            cancelCurrentAction();
            AppSnackbar.info('Photo is required for this action.');
            return;
          }

          if (isActionCancelled.value) return;
          await _setPhase('Processing photo...');
          final File file = File(image.path);
          final uploadPath = job.jobId;

          final fileSize = await file.length();
          final fileName = file.path.split('/').last;
          final extension = fileName.split('.').last.toLowerCase();
          final mimeType = image.mimeType ?? 'image/$extension';

          final bytes = await file.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          final imgWidth = frame.image.width;
          final imgHeight = frame.image.height;

          final uploadResult = await _uploadFileUseCase(
            UploadFileParams(
              file: file, 
              path: uploadPath,
              cancelToken: _cancelToken,
              onSendProgress: (int sent, int total) {
                if (total > 0) {
                  uploadProgress.value = sent / total;
                }
              },
            ),
          );

          if (isActionCancelled.value) return;

          uploadResult.fold(
            (failure) =>
                throw Exception('Failed to upload photo: ${failure.message}'),
            (path) {
              uploadedPhotoPath = path;
              photoMetadata = {
                'url': ApiEndpoints.common.download(path),
                'path': path,
                'fileMetadata': {
                  'name': fileName,
                  'extension': extension,
                  'mimeType': mimeType,
                  'size': fileSize,
                },
                'imageMetadata': {
                  'width': imgWidth,
                  'height': imgHeight,
                }
              };
            },
          );
          continue handleActivity;

        handleActivity:
        case JobAction.startJob:
        case JobAction.completeJob:
        case JobAction.reached:
        case JobAction.takeBreak:
        case JobAction.sendLocation:
          if (isActionCancelled.value) return;
          await _setPhase('Syncing with server...');

          String activityMessage = '';
          String activityType = '';

          switch (jobAction) {
            case JobAction.startJob:
            case JobAction.startJobWithCapturePhoto:
              activityMessage = "I have started the job";
              activityType = 'started_job';
              break;
            case JobAction.completeJob:
            case JobAction.completeJobWithCapturePhoto:
              activityMessage = "I have completed the job";
              activityType = 'completed_job';
              break;
            case JobAction.reached:
              activityMessage = "I've reached the location";
              activityType = 'reached_location';
              break;
            case JobAction.takeBreak:
              activityMessage = "I am taking a break";
              activityType = 'take_break';
              break;
            case JobAction.sendLocation:
              activityMessage = "Here is my current location";
              activityType = 'send_location';
              break;
            case _:
              activityMessage = "Performed action";
              activityType = 'unknown';
              break;
          }

          content.add(
            JobChatMessageContentEntity(
              type: JobChatMessageType.text.value,
              content: activityMessage,
            ),
          );

          if (uploadedPhotoPath != null) {
            content.add(
              JobChatMessageContentEntity(
                type: JobChatMessageType.image.value,
                content: uploadedPhotoPath,
                metadata: photoMetadata,
              ),
            );
          }

          final messageMetadata = {
            'activity_type': activityType,
            'workerName': _currentUserName.value!,
            ...locationData,
          };

          final activityMsg = JobChatMessageEntity(
            uid: tempLocalId,
            localId: tempLocalId,
            jobId: job.jobId,
            authorType: 'user',
            senderName: _currentUserName.value!,
            senderId: _currentUserUid.value!,
            senderProfileUid: _currentUserProfileUid.value,
            content: content,
            type: 'activity',
            metadata: messageMetadata,
            timestamp: DateTime.now(),
            isMe: true,
          );

          final result = await _sendMessageUseCase(
            SendMessageParams(message: activityMsg),
          );

          result.fold((failure) => AppSnackbar.destructive(failure.message), (
            sendResult,
          ) {
            messages.add(sendResult.message.copyWith(isMe: true));
            if (sendResult.job != null) {
              _job.value = sendResult.job!;
              _emitJobUpdateUseCase(sendResult.job!);
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

  void onBack() => Get.back();

  List<String> get availableActions {
    if (userRole == null) return [];

    if (userRole == UserRole.worker) {
      return job.allowedActions
          .map((a) => JobAction.fromString(a)?.label)
          .whereType<String>()
          .toList();
    } else {
      return _getOwnerActions();
    }
  }

  List<String> _getOwnerActions() {
    switch (job.status) {
      case JobStatus.pending:
      case JobStatus.assigned:
        return ['Cancel Job'];
      case JobStatus.inProgress:
        return [
          'Ask Location',
          'Ask Status',
          'Status with Proofs',
          'Cancel Job',
        ];
      case JobStatus.completed:
        return ['Reopen Job'];
      case JobStatus.cancelled:
        return ['Reopen Job'];
    }
  }
}
