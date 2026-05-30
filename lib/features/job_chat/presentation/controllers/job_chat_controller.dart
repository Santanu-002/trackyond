import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as img;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:nanoid/nanoid.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/chat_item.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';
import 'package:trackyond/features/job_chat/domain/usecases/emit_job_update_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/listen_chat_events_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class JobChatController extends GetxController {
  final GetJobMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetJobChatMembersUseCase _getChatMembersUseCase;
  final EmitJobUpdateUseCase _emitJobUpdateUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final ListenChatEventsUseCase _listenChatEventsUseCase;

  JobChatController({
    required GetJobMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required GetJobChatMembersUseCase getChatMembersUseCase,
    required EmitJobUpdateUseCase emitJobUpdateUseCase,
    required UploadFileUseCase uploadFileUseCase,
    required ListenChatEventsUseCase listenChatEventsUseCase,
  }) : _getMessagesUseCase = getMessagesUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _getChatMembersUseCase = getChatMembersUseCase,
       _emitJobUpdateUseCase = emitJobUpdateUseCase,
       _uploadFileUseCase = uploadFileUseCase,
       _listenChatEventsUseCase = listenChatEventsUseCase;

  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreMessages = true.obs;
  static const int _messageLimit = 20;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final Rxn<DateTime> floatingDate = Rxn<DateTime>();
  final RxBool isFloatingDateVisible = false.obs;
  Timer? _floatingDateTimer;

  void onScrollInteraction() {
    if (flattenedItems.isEmpty) return;

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // items are reversed, so index 0 is bottom. The top-most visible item has the highest index among visible items
      final topMostItemPosition = positions.reduce(
        (max, position) => position.index > max.index ? position : max,
      );
      final highestIndex = topMostItemPosition.index;

      // Trigger lazy load if we are close to the top of the visible list (oldest messages)
      if (highestIndex >= flattenedItems.length - 3 &&
          !isLoadingMore.value &&
          hasMoreMessages.value) {
        loadMoreMessages();
      }

      // If the oldest item (top of chat) is visible, hide the floating header
      final isTopVisible = positions.any(
        (p) => p.index == flattenedItems.length - 1,
      );
      if (isTopVisible) {
        isFloatingDateVisible.value = false;
        _floatingDateTimer?.cancel();
        return;
      }

      final index = highestIndex;
      if (index >= 0 && index < flattenedItems.length) {
        final topItem = flattenedItems[index];
        DateTime? newDate;

        if (topItem is ChatDateHeader) {
          newDate = topItem.date;
        } else if (topItem is ChatMessageBubbleItem) {
          newDate = topItem.message.timestamp;
        } else if (topItem is ChatActivityBubble) {
          newDate = topItem.message.timestamp;
        } else if (topItem is ChatTimeHeaderItem) {
          newDate = topItem.time;
        } else if (topItem is ChatHeaderMessage) {
          newDate = topItem.message.timestamp;
        }

        if (newDate != null) {
          floatingDate.value = DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
          );
        }
      }
    }

    isFloatingDateVisible.value = true;
    _floatingDateTimer?.cancel();
    _floatingDateTimer = Timer(const Duration(seconds: 3), () {
      isFloatingDateVisible.value = false;
    });
  }

  void scrollToLast({bool animate = false}) {
    if (!itemScrollController.isAttached) return;
    if (flattenedItems.isEmpty) return;
    const index = 0;
    if (animate) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      itemScrollController.jumpTo(index: index);
    }
  }

  final RxList<JobChatMessageEntity> messages = <JobChatMessageEntity>[].obs;
  final RxList<MemberProfile> chatMembers = <MemberProfile>[].obs;
  final RxnString _currentUserProfileUid = RxnString(null);
  final RxnString _currentUserUid = RxnString(null);
  final RxnString _currentUserName = RxnString(null);
  StreamSubscription<ChatEvent>? _chatEventsSubscription;

  String? get currentUserId => _currentUserUid.value;
  String? get currentUserProfileUid => _currentUserProfileUid.value;

  final Rxn<JobChatMessageEntity> replyingToMessage =
      Rxn<JobChatMessageEntity>();
  final RxString highlightedMessageUid = ''.obs;
  final RxBool isSelectionMode = false.obs;
  final RxSet<String> selectedMessageUids = <String>{}.obs;

  List<ChatItem> get flattenedItems {
    final List<ChatItem> items = [];
    if (messages.isEmpty) return items;

    DateTime? lastDate;
    DateTime? lastMessageTime;

    bool isSameSender(JobChatMessageEntity? a, JobChatMessageEntity? b) {
      if (a == null || b == null) return false;
      if (a.senderUid == 'system' || b.senderUid == 'system') return false;
      return a.senderUid == b.senderUid;
    }

    // Messages are sorted by date from backend (asc)
    for (int i = 0; i < messages.length; i++) {
      var message = messages[i];
      var prevMessage = i > 0 ? messages[i - 1] : null;
      var nextMessage = i + 1 < messages.length ? messages[i + 1] : null;

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
    return items.reversed.toList();
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

    final isActivity =
        message.type == 'activity' ||
        message.content.any(
          (c) =>
              JobChatMessageType.fromString(c.type) ==
              JobChatMessageType.activity,
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

  final RxBool isMessageSending = false.obs;
  final RxBool isActionLoading = false.obs;
  final RxnString actionLoadingMessage = RxnString(null);
  final RxnString loadingActionLabel = RxnString(null);
  final RxnString loadingActionMessageUid = RxnString(null);

  CancelToken? _cancelToken;
  final RxBool isActionCancelled = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  void cancelCurrentAction() {
    isActionCancelled.value = true;
    _cancelToken?.cancel("User cancelled the operation");
    isActionLoading.value = false;
    actionLoadingMessage.value = null;
    loadingActionLabel.value = null;
    loadingActionMessageUid.value = null;
    uploadProgress.value = 0.0;
  }

  void setReplyingTo(JobChatMessageEntity message) {
    replyingToMessage.value = message;
    focusNode.requestFocus();
  }

  void cancelReply() {
    replyingToMessage.value = null;
  }

  bool isAskLocationFulfilled(DateTime askTime) {
    return messages.any((m) {
      if (!m.timestamp.isAfter(askTime) || !m.isMe || m.type != 'activity') {
        return false;
      }
      final type = JobActivityType.fromString(m.metadata?['activity_type']);
      return type == JobActivityType.sendLocation ||
          type == JobActivityType.reachedLocation;
    });
  }

  bool isAskStatusFulfilled(JobChatMessageEntity requestMessage) {
    final reqType = JobActivityType.fromString(
      requestMessage.metadata?['activity_type'],
    );

    return messages.any((m) {
      if (!m.timestamp.isAfter(requestMessage.timestamp) || !m.isMe) {
        return false;
      }

      final hasReply = m.content.any((c) {
        if (c.type != 'reply') return false;
        final repliedMsgUid = c.metadata?['messageUid'] as String?;
        return repliedMsgUid == requestMessage.uid;
      });

      if (hasReply) {
        if (reqType == JobActivityType.askStatusProofs) {
          // For status with proofs, the reply itself must be an activity message of type sendStatus
          if (m.type == 'activity') {
            final activityType = JobActivityType.fromString(
              m.metadata?['activity_type'],
            );
            if (activityType == JobActivityType.sendStatus) {
              return true;
            }
          }
          return false;
        }
        // For regular status requested, any reply counts as fulfilling it
        return true;
      }

      if (m.type == 'activity') {
        final activityType = JobActivityType.fromString(
          m.metadata?['activity_type'],
        );
        final hasImage = m.content.any((c) => c.type == 'image');
        if (activityType == JobActivityType.sendStatus) {
          if (reqType == JobActivityType.askStatusProofs) {
            return hasImage;
          } else if (reqType == JobActivityType.askStatus) {
            return true;
          }
        }
      }
      return false;
    });
  }

  void scrollToMessage(String uid) {
    final index = flattenedItems.indexWhere((item) {
      if (item is ChatMessageBubbleItem && item.message.uid == uid) return true;
      if (item is ChatActivityBubble && item.message.uid == uid) return true;
      return false;
    });
    if (index != -1) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        alignment: 0.4,
        curve: Curves.easeInOut,
      );
      // Trigger highlight after scroll completes
      Future.delayed(const Duration(milliseconds: 350), () {
        _triggerHighlight(uid);
      });
    }
  }

  void _triggerHighlight(String uid) {
    highlightedMessageUid.value = uid;
    // Clear after 2.0s (the widget fades over 1.5s; extra 0.5s buffer)
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (highlightedMessageUid.value == uid) {
        highlightedMessageUid.value = '';
      }
    });
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

  String getSenderName(JobChatMessageEntity message) {
    if (message.senderUid == 'system') {
      return 'System';
    }

    if (message.senderUid != null) {
      final member = chatMembers.firstWhereOrNull(
        (m) => m.uid == message.senderUid,
      );
      if (member != null) {
        return member.name;
      }

      if (message.senderUid == job.workerProfileUid) {
        return job.workerName ?? 'Worker';
      }
      if (message.senderUid == job.createdByProfileUid) {
        return job.createdByName ?? 'Admin';
      }
    }

    return 'User';
  }

  String? getSenderImage(JobChatMessageEntity message) {
    if (message.senderUid == 'system') {
      return null;
    }

    if (message.senderUid != null) {
      final member = chatMembers.firstWhereOrNull(
        (m) => m.uid == message.senderUid,
      );
      if (member != null) {
        return member.image;
      }

      if (message.senderUid == job.workerProfileUid) {
        return job.workerImage;
      }
    }

    return null;
  }

  String resolveMemberName(
    String? senderUid,
    String fallbackName,
  ) {
    final profileUid = senderUid;
    if (profileUid != null) {
      final member = chatMembers.firstWhereOrNull(
        (m) => m.uid == profileUid,
      );
      if (member != null) {
        return member.name;
      }
      if (profileUid == job.workerProfileUid) {
        return job.workerName ?? 'Worker';
      }
      if (profileUid == job.createdByProfileUid) {
        return job.createdByName ?? 'Admin';
      }
    }
    return fallbackName;
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
  final RxBool showAttachmentMenu = false.obs;
  final layerLink = LayerLink();

  void toggleAttachmentMenu() {
    showAttachmentMenu.value = !showAttachmentMenu.value;
    if (showAttachmentMenu.value) {
      focusNode.unfocus();
    }
  }

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
      if (focusNode.hasFocus) {
        showAttachmentMenu.value = false;
        Future.delayed(const Duration(milliseconds: 150), () {
          scrollToLast(animate: true);
        });
      }
    });

    _initializeData();
    _listenToEvents();
  }

  Future<void> _listenToEvents() async {
    final result = await _listenChatEventsUseCase(const NoParams());
    result.fold(
      (failure) =>
          debugPrint('Error listening to chat events: ${failure.message}'),
      (stream) {
        _chatEventsSubscription = stream.listen((event) {
          if (event is ChatMessageReceivedEvent) {
            final message = event.message;
            if (message.jobId == job.jobId) {
              final exists = messages.any((m) => m.uid == message.uid);
              if (!exists) {
                messages.add(
                  message.copyWith(
                    isMe: message.senderUid == _currentUserProfileUid.value,
                  ),
                );
                scrollToLast(animate: true);
              }
            }
          }
        });
      },
    );
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
    _chatEventsSubscription?.cancel();
    messageController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  Future<void> fetchMessages() async {
    isLoading.value = true;
    errorMessage.value = null;
    hasMoreMessages.value = true;
    messages.clear();

    try {
      final membersResult = await _getChatMembersUseCase(job.jobId);
      membersResult.fold(
        (failure) =>
            debugPrint('Error fetching chat members: ${failure.message}'),
        (data) {
          chatMembers.assignAll(data);
        },
      );

      final result = await _getMessagesUseCase(
        GetJobMessagesParams(
          jobId: job.jobId,
          options: const MessageQueryOptions(limit: _messageLimit, offset: 0),
        ),
      );
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          AppSnackbar.destructive(failure.message);
        },
        (data) {
          if (data.length < _messageLimit) {
            hasMoreMessages.value = false;
          }
          final updatedMessages = data.map((m) {
            final isMe = m.senderUid == _currentUserProfileUid.value;
            return m.copyWith(isMe: isMe);
          }).toList();
          messages.assignAll(updatedMessages);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (isLoadingMore.value || !hasMoreMessages.value) return;

    isLoadingMore.value = true;
    final currentOffset = messages.length;

    final result = await _getMessagesUseCase(
      GetJobMessagesParams(
        jobId: job.jobId,
        options: MessageQueryOptions(
          limit: _messageLimit,
          offset: currentOffset,
        ),
      ),
    );

    result.fold(
      (failure) {
        debugPrint('Error loading more messages: ${failure.message}');
        isLoadingMore.value = false;
      },
      (data) {
        if (data.length < _messageLimit) {
          hasMoreMessages.value = false;
        }

        final updatedMessages = data.map((m) {
          final isMe = m.senderUid == _currentUserProfileUid.value;
          return m.copyWith(isMe: isMe);
        }).toList();

        messages.insertAll(0, updatedMessages);
        isLoadingMore.value = false;
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

    final repliedMsg = replyingToMessage.value;

    isMessageSending.value = true;
    Map<String, dynamic> locationData = {};

    try {
      if (userRole == UserRole.worker &&
          repliedMsg != null &&
          repliedMsg.type == 'activity') {
        final activityType = JobActivityType.fromString(
          repliedMsg.metadata?['activity_type'],
        );
        if (activityType == JobActivityType.askStatus) {
          // For status requests, attach location silently in background
          try {
            // We reuse the same acquire logic but without specific phase UI messages for the bar
            // (The user just sees the send button spinner)
            locationData = await _acquireLocationAndAddress();
          } catch (e) {
            debugPrint('Background location fetch failed: $e');
            // We continue sending the message even if location fails,
            // but we might want to warn the user if it was strictly required.
          }
        }
      }

      // Optimistic UI update
      final tempLocalId = nanoid(10);
      final List<JobChatMessageContentEntity> contentList = [];

      if (repliedMsg != null) {
        String originalText = '';
        String mediaType = 'text';
        String? mediaUrl;
        String? replyBlurHash;
        int? pageCount;

        final textContent = repliedMsg.content.firstWhereOrNull(
          (c) => c.type == 'text' || c.type == 'activity',
        );
        originalText = textContent?.content ?? '';

        final mediaItems = repliedMsg.content.where(
          (c) => c.type == 'image' || c.type == 'video' || c.type == 'document' || c.type == 'pdf'
        ).toList();

        if (mediaItems.isNotEmpty) {
          final firstMedia = mediaItems.first;
          mediaType = firstMedia.type;
          mediaUrl = firstMedia.content;
          
          if (firstMedia.type == 'image') {
            final imgMeta = firstMedia.metadata?['imageMetadata'];
            replyBlurHash = imgMeta?['blurHash'] ?? firstMedia.metadata?['blurHash'];
            if (originalText.isEmpty) originalText = 'Photo';
          } else if (firstMedia.type == 'video') {
            final vidMeta = firstMedia.metadata?['videoMetadata'];
            replyBlurHash = vidMeta?['thumbnailBlurHash'] ?? firstMedia.metadata?['blurHash'];
            if (originalText.isEmpty) originalText = 'Video';
          } else if (firstMedia.type == 'pdf') {
            final pdfMeta = firstMedia.metadata?['pdfMetadata'];
            pageCount = pdfMeta?['pageCount'];
            if (originalText.isEmpty) originalText = 'PDF';
          } else if (firstMedia.type == 'document') {
            final docMeta = firstMedia.metadata?['documentMetadata'];
            pageCount = docMeta?['pageCount'];
            if (originalText.isEmpty) originalText = 'Document';
          }
        }

        final remainingMediaCount = mediaItems.length > 1 ? (mediaItems.length - 1) : 0;

        contentList.add(
          JobChatMessageContentEntity(
            type: 'reply',
            content: originalText,
            metadata: {
              'messageUid': repliedMsg.uid,
              'senderName': getSenderName(repliedMsg),
              'senderUid': repliedMsg.senderUid,
              'type': repliedMsg.type,
              'mediaType': mediaType,
              'mediaUrl': mediaUrl,
              'blurHash': replyBlurHash,
              'pageCount': pageCount,
              'remainingMediaCount': remainingMediaCount,
            },
          ),
        );
      }

      contentList.add(
        JobChatMessageContentEntity(
          type: 'text',
          content: text,
        ),
      );

      final isActivityReply = locationData.isNotEmpty;
      final finalMetadata = {
        ...locationData,
        if (isActivityReply) 'activity_type': JobActivityType.sendStatus.value,
      };

      final tempMsg = JobChatMessageEntity(
        uid: '',
        localId: tempLocalId,
        jobId: job.jobId,
        senderUid: _currentUserProfileUid.value,
        content: contentList,
        createdByAuthorAt: DateTime.now(),
        type: isActivityReply ? 'activity' : 'message',
        metadata: finalMetadata.isNotEmpty ? finalMetadata : null,
        isMe: true,
      );
      messages.add(tempMsg);
      scrollToLast(animate: true);

      final result = await _sendMessageUseCase(
        SendMessageParams(message: tempMsg),
      );

      result.fold(
        (failure) {
          messages.removeWhere((m) => m.localId == tempLocalId);
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          messageController.clear();
          replyingToMessage.value = null;
          // Replace temp message with real one
          final index = messages.indexWhere((m) => m.localId == tempLocalId);
          if (index != -1) {
            messages[index] = sendResult.message.copyWith(isMe: true);
          }
          if (sendResult.job != null) {
            _job.value = sendResult.job!;
            _emitJobUpdateUseCase(sendResult.job!);
          }
        },
      );
    } finally {
      isMessageSending.value = false;
    }
  }

  void sendMockPhoto() {
    if (_currentUserProfileUid.value == null) return;

    final photoMsg = JobChatMessageEntity(
      uid: '',
      localId: nanoid(10),
      jobId: job.jobId,
      senderUid: _currentUserProfileUid.value,
      content: [
        JobChatMessageContentEntity(
          type: 'image',
          content: 'uploads/chat/mock_workspace.jpg',
          metadata: {
            'fileName': 'mock_workspace.jpg',
            'size': '1.1 MB',
            'mimeType': 'image/jpeg',
            'imageMetadata': {
              'width': 400,
              'height': 300,
              'blurHash': 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
            },
          },
        ),
      ],
      createdByAuthorAt: DateTime.now(),
      isMe: true,
    );
    messages.add(photoMsg);

    // Activity entry
    final timelineId = nanoid(10);
    final timelineMsg = JobChatMessageEntity(
      uid: timelineId,
      localId: timelineId,
      jobId: job.jobId,
      senderUid: 'system',
      type: 'activity',
      content: const [
        JobChatMessageContentEntity(
          type: 'text',
          content: '📸 Photo uploaded as proof of work',
        ),
      ],
      createdByAuthorAt: DateTime.now(),
      isMe: false,
    );
    messages.add(timelineMsg);
    scrollToLast(animate: true);
  }

  Future<String?> _computeAndPrintBlurHash(String imagePath) async {
    try {
      final File file = File(imagePath);
      final bytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        // Resize to 100px width to speed up encoding significantly and save memory/CPU
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

  Future<String?> _computeVideoBlurHash(String videoPath) async {
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
        final blurHash = await _computeAndPrintBlurHash(thumbPath);
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

  Future<Map<String, dynamic>> _acquireLocationAndAddress() async {
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

  Future<void> executeAction(String actionString, {String? messageUid}) async {
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
      loadingActionMessageUid.value = messageUid;

      final jobAction = JobAction.fromString(actionString);

      if (jobAction == null) {
        // Handle owner/admin specific actions or unknown actions
        AppSnackbar.info('Action: $actionString (Backend integration pending)');
        return;
      }

      String? uploadedPhotoPath;
      Map<String, dynamic>? photoMetadata;
      final tempLocalId = nanoid(10);
      final List<JobChatMessageContentEntity> content = [];

      final isPhotoAction =
          jobAction == JobAction.startJobWithCapturePhoto ||
          jobAction == JobAction.completeJobWithCapturePhoto;

      // 1. If it is a photo action, perform capture and upload first!
      if (isPhotoAction) {
        await _setPhase(AppStrings.jobChat.waitingForPhoto);
        final result =
            await Get.toNamed(
                  AppRoutes.common.camera,
                  arguments: {'skipPreview': true},
                )
                as Map<String, dynamic>?;
        if (result == null) {
          cancelCurrentAction();
          AppSnackbar.info(AppStrings.jobChat.photoRequired);
          return;
        }
        final String? imagePath = result['path'] as String?;
        if (imagePath == null) {
          cancelCurrentAction();
          AppSnackbar.info(AppStrings.jobChat.photoRequired);
          return;
        }

        if (isActionCancelled.value) return;
        await _setPhase(AppStrings.jobChat.processingPhoto);
        final File file = File(imagePath);
        final uploadPath = job.jobId;

        final fileSize = await file.length();
        final fileName = file.path.split('/').last;
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        final imgWidth = frame.image.width;
        final imgHeight = frame.image.height;

        final String? calculatedBlurHash = await _computeAndPrintBlurHash(
          imagePath,
        );

        if (isActionCancelled.value) return;
        await _setPhase(AppStrings.jobChat.uploadingPhoto);

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
              'fileName': fileName,
              'size': AppUtils.formatFileSize(fileSize),
              'mimeType': mimeType,
              'imageMetadata': {
                'width': imgWidth,
                'height': imgHeight,
                'blurHash': calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
              },
            };
          },
        );
        uploadProgress.value = 0.0;
      }

      // 2. Now acquire location (either after successful photo upload, or directly if it's a normal action)
      Map<String, dynamic> locationData = {};
      final bool requiresLocation =
          jobAction != JobAction.askLocation &&
          jobAction != JobAction.askStatus &&
          jobAction != JobAction.statusWithProofs &&
          jobAction != JobAction.cancelJob &&
          jobAction != JobAction.reopenJob;

      if (requiresLocation) {
        locationData = await _acquireLocationAndAddress();
      }

      if (isActionCancelled.value) return;

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
          if (isActionCancelled.value) return;
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
              type: 'text',
              content: activityMessage,
            ),
          );

          if (uploadedPhotoPath != null) {
            content.add(
              JobChatMessageContentEntity(
                type: 'image',
                content: uploadedPhotoPath,
                metadata: photoMetadata,
              ),
            );
          }

          final messageMetadata = {
            'activity_type': activityType.value,
            'workerName': _currentUserName.value!,
            ...locationData,
          };

          final activityMsg = JobChatMessageEntity(
            uid: '',
            localId: tempLocalId,
            jobId: job.jobId,
            senderUid: _currentUserProfileUid.value,
            content: content,
            type: 'activity',
            metadata: messageMetadata,
            actionPerformed: jobAction.value,
            createdByAuthorAt: DateTime.now(),
            isMe: true,
          );

          final result = await _sendMessageUseCase(
            SendMessageParams(message: activityMsg),
          );

          result.fold((failure) => AppSnackbar.destructive(failure.message), (
            sendResult,
          ) {
            messages.add(sendResult.message.copyWith(isMe: true));
            scrollToLast(animate: true);
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

  Future<void> openCameraForStatusProof(
    JobChatMessageEntity requestMessage,
  ) async {
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

    final result =
        await Get.toNamed(
              AppRoutes.common.camera,
              arguments: {
                'requestMessage': requestMessage,
                'skipPreview': false,
              },
            )
            as Map<String, dynamic>?;
    if (result == null) return;

    final String? imagePath = result['path'] as String?;
    if (imagePath == null) return;

    navigateToMediaPreview(
      imagePath: imagePath,
      requestMessage: requestMessage,
      type: MediaPreviewType.image,
    );
  }

  void navigateToMediaPreview({
    String? imagePath,
    List<String>? imagePaths,
    JobChatMessageEntity? requestMessage,
    required MediaPreviewType type,
  }) {
    Get.toNamed(
      '${AppRoutes.common.mediaPreview}?type=${type.name}',
      arguments: {
        'imagePath': imagePath,
        'imagePaths': imagePaths,
        'requestMessage': requestMessage,
      },
    );
  }

  Future<bool> sendMediaStatusProof({
    required List<String> imagePaths,
    required String caption,
    required JobChatMessageEntity requestMessage,
  }) async {
    try {
      _cancelToken = CancelToken();
      isActionCancelled.value = false;
      uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = 'send_status_proof';

      // 1. Process photos & upload
      final List<JobChatMessageContentEntity> content = [];

      content.add(
        JobChatMessageContentEntity(
          type: 'text',
          content: caption.isNotEmpty
              ? caption
              : AppStrings.jobChat.statusProofDefaultCaption,
        ),
      );

      for (int i = 0; i < imagePaths.length; i++) {
        final imagePath = imagePaths[i];
        actionLoadingMessage.value =
            '${AppStrings.jobChat.processingPhoto} (${i + 1}/${imagePaths.length})';
        final File file = File(imagePath);
        final uploadPath = job.jobId;

        final fileSize = await file.length();
        final fileName = file.path.split('/').last;
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        final imgWidth = frame.image.width;
        final imgHeight = frame.image.height;

        final String? calculatedBlurHash = await _computeAndPrintBlurHash(
          imagePath,
        );

        if (isActionCancelled.value) return false;
        actionLoadingMessage.value =
            '${AppStrings.jobChat.uploadingPhoto} (${i + 1}/${imagePaths.length})';

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

        if (isActionCancelled.value) return false;

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
                'blurHash': calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
              },
            };
            content.add(
              JobChatMessageContentEntity(
                type: 'image',
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

      // 2. Acquire Location
      if (isActionCancelled.value) return false;
      final locationData = await _acquireLocationAndAddress();

      if (isActionCancelled.value) return false;
      actionLoadingMessage.value = AppStrings.jobChat.syncingWithServer;

      final messageMetadata = {
        'activity_type': JobActivityType.sendStatus.value,
        'workerName': _currentUserName.value!,
        'requestMessageUid': requestMessage.uid,
        ...locationData,
      };

      final tempLocalId = nanoid(10);
      final activityMsg = JobChatMessageEntity(
        uid: '',
        localId: tempLocalId,
        jobId: job.jobId,
        senderUid: _currentUserProfileUid.value,
        content: content,
        type: 'activity',
        metadata: messageMetadata,
        createdByAuthorAt: DateTime.now(),
        isMe: true,
      );

      final result = await _sendMessageUseCase(
        SendMessageParams(message: activityMsg),
      );

      bool sendSuccess = false;
      result.fold(
        (failure) {
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          sendSuccess = true;
          messages.add(sendResult.message.copyWith(isMe: true));
          scrollToLast(animate: true);
          if (sendResult.job != null) {
            _job.value = sendResult.job!;
            _emitJobUpdateUseCase(sendResult.job!);
          }
          AppSnackbar.success(AppStrings.jobChat.statusUpdateSuccess);
        },
      );

      return sendSuccess;
    } catch (e) {
      if (!isActionCancelled.value) {
        AppSnackbar.destructive(e.toString());
      }
      return false;
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
      loadingActionLabel.value = null;
      uploadProgress.value = 0.0;
    }
  }

  bool _isVideoPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ext == 'mp4' ||
        ext == 'mov' ||
        ext == 'avi' ||
        ext == 'mkv' ||
        ext == 'webm' ||
        ext == '3gp';
  }

  bool _isDocPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ext == 'pdf' ||
        ext == 'doc' ||
        ext == 'docx' ||
        ext == 'xls' ||
        ext == 'xlsx' ||
        ext == 'ppt' ||
        ext == 'pptx' ||
        ext == 'txt';
  }

  Future<bool> sendGeneralMedia({
    required List<String> paths,
    required String caption,
    Map<String, Map<String, dynamic>>? extraMetadata,
  }) async {
    try {
      _cancelToken = CancelToken();
      isActionCancelled.value = false;
      uploadProgress.value = 0.0;
      isActionLoading.value = true;
      loadingActionLabel.value = 'send_general_media';

      final List<JobChatMessageContentEntity> content = [];

      // If there is a caption, add it as a text content item first
      if (caption.trim().isNotEmpty) {
        content.add(
          JobChatMessageContentEntity(
            type: 'text',
            content: caption.trim(),
          ),
        );
      }

      final List<JobChatMessageContentEntity?> uploadedContents =
          List.filled(paths.length, null);
      final List<String> uploadErrors = [];
      final Map<int, double> progressMap = {};
      int completedCount = 0;

      void updateOverallProgress() {
        if (paths.isEmpty) return;
        double sum = 0.0;
        for (int i = 0; i < paths.length; i++) {
          sum += progressMap[i] ?? 0.0;
        }
        uploadProgress.value = sum / paths.length;
        final displayCount = (completedCount + 1).clamp(1, paths.length);
        actionLoadingMessage.value =
            '${AppStrings.jobChat.cropSending} ($displayCount/${paths.length})';
      }

      Future<void> uploadFile(int index) async {
        final path = paths[index];
        final isVideo = _isVideoPath(path);
        final isDoc = _isDocPath(path);
        final File file = File(path);
        final uploadPath = job.jobId;
        final fileSize = await file.length();
        final fileName = file.path.split('/').last;

        try {
          if (isDoc) {
            final mimeType = lookupMimeType(path) ?? 'application/octet-stream';
            final uploadResult = await _uploadFileUseCase(
              UploadFileParams(
                file: file,
                path: uploadPath,
                cancelToken: _cancelToken,
                onSendProgress: (int sent, int total) {
                  if (total > 0 && !isActionCancelled.value) {
                    progressMap[index] = sent / total;
                    updateOverallProgress();
                  }
                },
              ),
            );

            if (isActionCancelled.value) return;

            uploadResult.fold(
              (failure) => uploadErrors.add(failure.message),
              (uploadedPath) {
                final isPdf = path.toLowerCase().endsWith('.pdf') || mimeType.contains('pdf');
                uploadedContents[index] = JobChatMessageContentEntity(
                  type: isPdf ? 'pdf' : 'document',
                  content: uploadedPath,
                  metadata: {
                    'fileName': fileName,
                    'size': AppUtils.formatFileSize(fileSize),
                    'mimeType': mimeType,
                    if (isPdf)
                      'pdfMetadata': const {
                        'extension': 'pdf',
                        'pageCount': 1,
                      }
                    else
                      'documentMetadata': {
                        'extension': file.path.split('.').last.toLowerCase(),
                        'pageCount': null,
                      },
                  },
                );
              },
            );
          } else if (isVideo) {
            final mimeType = lookupMimeType(path) ?? 'video/mp4';
            final String? calculatedBlurHash = await _computeVideoBlurHash(path);

            if (isActionCancelled.value) return;

            final uploadResult = await _uploadFileUseCase(
              UploadFileParams(
                file: file,
                path: uploadPath,
                cancelToken: _cancelToken,
                onSendProgress: (int sent, int total) {
                  if (total > 0 && !isActionCancelled.value) {
                    progressMap[index] = sent / total;
                    updateOverallProgress();
                  }
                },
              ),
            );

            if (isActionCancelled.value) return;

            uploadResult.fold(
              (failure) => uploadErrors.add(failure.message),
              (uploadedPath) {
                final extra = extraMetadata?[path];
                final startMs = extra?['trimStart'];
                final endMs = extra?['trimEnd'];
                final isMuted = extra?['isMuted'];

                uploadedContents[index] = JobChatMessageContentEntity(
                  type: 'video',
                  content: uploadedPath,
                  metadata: {
                    'fileName': fileName,
                    'size': AppUtils.formatFileSize(fileSize),
                    'mimeType': mimeType,
                    'videoMetadata': {
                      'aspectRatio': 1.777,
                      'duration': 0,
                      'thumbnailBlurHash': calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                      'trimStart': ?startMs,
                      'trimEnd': ?endMs,
                      'isMuted': ?isMuted,
                    },
                  },
                );
              },
            );
          } else {
            final mimeType = lookupMimeType(path) ?? 'image/jpeg';
            final bytes = await file.readAsBytes();
            final codec = await ui.instantiateImageCodec(bytes);
            final frame = await codec.getNextFrame();
            final imgWidth = frame.image.width;
            final imgHeight = frame.image.height;
            final String? calculatedBlurHash =
                await _computeAndPrintBlurHash(path);

            if (isActionCancelled.value) return;

            final uploadResult = await _uploadFileUseCase(
              UploadFileParams(
                file: file,
                path: uploadPath,
                cancelToken: _cancelToken,
                onSendProgress: (int sent, int total) {
                  if (total > 0 && !isActionCancelled.value) {
                    progressMap[index] = sent / total;
                    updateOverallProgress();
                  }
                },
              ),
            );

            if (isActionCancelled.value) return;

            uploadResult.fold(
              (failure) => uploadErrors.add(failure.message),
              (uploadedPath) {
                uploadedContents[index] = JobChatMessageContentEntity(
                  type: 'image',
                  content: uploadedPath,
                  metadata: {
                    'fileName': fileName,
                    'size': AppUtils.formatFileSize(fileSize),
                    'mimeType': mimeType,
                    'imageMetadata': {
                      'width': imgWidth,
                      'height': imgHeight,
                      'blurHash': calculatedBlurHash ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                    },
                  },
                );
              },
            );
          }

          if (!isActionCancelled.value) {
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
          if (isActionCancelled.value) break;
          final index = nextIndex++;
          await uploadFile(index);
        }
      }

      // Limit concurrency to 3
      final int concurrency = paths.length < 3 ? paths.length : 3;
      final List<Future<void>> workers =
          List.generate(concurrency, (_) => worker());
      await Future.wait(workers);

      if (isActionCancelled.value) return false;

      if (uploadErrors.isNotEmpty) {
        throw Exception(uploadErrors.first);
      }

      final List<JobChatMessageContentEntity> nonNullContents =
          uploadedContents.whereType<JobChatMessageContentEntity>().toList();
      content.addAll(nonNullContents);

      if (_currentUserProfileUid.value == null) {
        throw Exception('User authentication data missing.');
      }

      final tempLocalId = nanoid(10);
      final tempMsg = JobChatMessageEntity(
        uid: '',
        localId: tempLocalId,
        jobId: job.jobId,
        senderUid: _currentUserProfileUid.value,
        content: content,
        createdByAuthorAt: DateTime.now(),
        type: 'message',
        isMe: true,
      );

      messages.add(tempMsg);
      scrollToLast(animate: true);

      final result = await _sendMessageUseCase(
        SendMessageParams(message: tempMsg),
      );

      bool sendSuccess = false;
      result.fold(
        (failure) {
          messages.removeWhere((m) => m.localId == tempLocalId);
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          sendSuccess = true;
          final index = messages.indexWhere((m) => m.localId == tempLocalId);
          if (index != -1) {
            messages[index] = sendResult.message.copyWith(isMe: true);
          }
          if (sendResult.job != null) {
            _job.value = sendResult.job!;
            _emitJobUpdateUseCase(sendResult.job!);
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

  void onBack() => Get.back();

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

  Future<void> copySelectedMessagesText() async {
    if (selectedMessageUids.isEmpty) return;

    final List<String> formattedMessages = [];
    for (final message in messages) {
      if (selectedMessageUids.contains(message.uid)) {
        final senderName = getSenderName(message);
        final year = message.timestamp.year.toString();
        final month = message.timestamp.month.toString().padLeft(2, '0');
        final day = message.timestamp.day.toString().padLeft(2, '0');
        final hour = message.timestamp.hour.toString().padLeft(2, '0');
        final minute = message.timestamp.minute.toString().padLeft(2, '0');
        final timeStr = '$day/$month/$year $hour:$minute';

        final List<String> contentParts = [];
        for (final c in message.content) {
          if (c.type == 'text') {
            final textVal = c.content;
            if (textVal != null && textVal.isNotEmpty) {
              contentParts.add(parseMentions(textVal));
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



  List<String> get availableActions {
    if (userRole == null) return [];

    if (userRole == UserRole.worker) {
      return job.allowedActions;
    } else {
      return _getOwnerActions();
    }
  }

  List<String> _getOwnerActions() {
    switch (job.status) {
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

  Future<void> sendAttachmentMessage({
    required JobChatMessageType type,
    required String contentText,
    required String mediaUrl,
    required Map<String, dynamic> metadata,
  }) async {
    if (_currentUserProfileUid.value == null) return;

    isMessageSending.value = true;
    final tempLocalId = nanoid(10);
    try {
      final List<JobChatMessageContentEntity> contentList = [
        JobChatMessageContentEntity(
          type: type.value,
          content: contentText,
          metadata: metadata,
        ),
      ];

      final tempMsg = JobChatMessageEntity(
        uid: '',
        localId: tempLocalId,
        jobId: job.jobId,
        senderUid: _currentUserProfileUid.value,
        content: contentList,
        createdByAuthorAt: DateTime.now(),
        type: 'message',
        isMe: true,
      );

      messages.add(tempMsg);
      scrollToLast(animate: true);

      final result = await _sendMessageUseCase(
        SendMessageParams(message: tempMsg),
      );

      result.fold(
        (failure) {
          messages.removeWhere((m) => m.localId == tempLocalId);
          AppSnackbar.destructive(failure.message);
        },
        (sendResult) {
          final index = messages.indexWhere((m) => m.localId == tempLocalId);
          if (index != -1) {
            messages[index] = sendResult.message.copyWith(isMe: true);
          }
          if (sendResult.job != null) {
            _job.value = sendResult.job!;
            _emitJobUpdateUseCase(sendResult.job!);
          }
        },
      );
    } catch (e) {
      messages.removeWhere((m) => m.localId == tempLocalId);
      AppSnackbar.destructive(e.toString());
    } finally {
      isMessageSending.value = false;
    }
  }

  Future<void> sendCapturedVideo(String videoPath) async {
    try {
      isMessageSending.value = true;
      final file = File(videoPath);
      final fileSize = await file.length();
      final fileName = file.path.split('/').last;
      final mimeType = lookupMimeType(file.path) ?? 'video/mp4';

      final uploadResult = await _uploadFileUseCase(
        UploadFileParams(file: file, path: job.jobId),
      );

      await uploadResult.fold(
        (failure) async {
          debugPrint(
            'Upload failed, falling back to mock video: ${failure.message}',
          );
          await sendAttachmentMessage(
            type: JobChatMessageType.video,
            contentText: fileName,
            mediaUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            metadata: {
              'fileName': fileName,
              'size': AppUtils.formatFileSize(fileSize),
              'mimeType': mimeType,
              'videoMetadata': {
                'aspectRatio': 1.777,
                'duration': 0,
                'thumbnailBlurHash': 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
              },
            },
          );
        },
        (path) async {
          await sendAttachmentMessage(
            type: JobChatMessageType.video,
            contentText: path,
            mediaUrl: ApiEndpoints.common.download(path),
            metadata: {
              'fileName': fileName,
              'size': AppUtils.formatFileSize(fileSize),
              'mimeType': mimeType,
              'videoMetadata': {
                'aspectRatio': 1.777,
                'duration': 0,
                'thumbnailBlurHash': 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
              },
            },
          );
        },
      );
    } catch (e) {
      AppSnackbar.destructive('Error sending captured video: $e');
    } finally {
      isMessageSending.value = false;
    }
  }

  Future<void> attachFromCamera() async {
    showAttachmentMenu.value = false;
    try {
      final result =
          await Get.toNamed(
                AppRoutes.common.camera,
                arguments: {'requestMessage': null, 'skipPreview': false},
              )
              as Map<String, dynamic>?;
      if (result == null) return;

      final String? imagePath = result['path'] as String?;
      if (imagePath == null) return;

      navigateToMediaPreview(
        imagePath: imagePath,
        requestMessage: null,
        type: MediaPreviewType.image,
      );
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
      final videoPaths = selectedFiles
          .map((file) => file.path)
          .toList();
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
      final paths = result.paths.whereType<String>().toList();
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
}
