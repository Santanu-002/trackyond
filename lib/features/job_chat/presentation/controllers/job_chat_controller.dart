import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:nanoid/nanoid.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/database/tables/queue_tasks_table.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/features/job_chat/domain/usecases/cancel_message_upload_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/retry_message_upload_usecase.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_status.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/job_chat/domain/usecases/clear_conversation_notifications_usecase.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/chat_item.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/listen_chat_events_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/mark_messages_seen_usecase.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_selection_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_upload_controller.dart';
import 'package:trackyond/features/job_chat/data/models/response/media_preview_item.dart';
import 'package:trackyond/features/job_chat/presentation/utils/reply_content_builder.dart';

import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';
import 'package:video_player/video_player.dart';

class JobChatController extends GetxController {
  final GetJobMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetJobChatMembersUseCase _getChatMembersUseCase;
  final ListenChatEventsUseCase _listenChatEventsUseCase;
  final MarkMessagesSeenUseCase _markMessagesSeenUseCase;
  final ClearConversationNotificationsUseCase _clearConversationNotificationsUseCase;
  final CancelMessageUploadUseCase _cancelMessageUploadUseCase;
  final RetryMessageUploadUseCase _retryMessageUploadUseCase;

  JobChatController({
    required GetJobMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required GetJobChatMembersUseCase getChatMembersUseCase,
    required ListenChatEventsUseCase listenChatEventsUseCase,
    required MarkMessagesSeenUseCase markMessagesSeenUseCase,
    required ClearConversationNotificationsUseCase clearConversationNotificationsUseCase,
    required CancelMessageUploadUseCase cancelMessageUploadUseCase,
    required RetryMessageUploadUseCase retryMessageUploadUseCase,
  }) : _getMessagesUseCase = getMessagesUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _getChatMembersUseCase = getChatMembersUseCase,
       _listenChatEventsUseCase = listenChatEventsUseCase,
       _markMessagesSeenUseCase = markMessagesSeenUseCase,
       _clearConversationNotificationsUseCase = clearConversationNotificationsUseCase,
       _cancelMessageUploadUseCase = cancelMessageUploadUseCase,
       _retryMessageUploadUseCase = retryMessageUploadUseCase;

  // Sub-controllers (lazy getters — resolved after all lazyPuts are registered)
  JobChatAttachmentController get attachmentController =>
      Get.find<JobChatAttachmentController>();

  JobChatUploadController get uploadController =>
      Get.find<JobChatUploadController>();

  JobChatSelectionController get selectionController =>
      Get.find<JobChatSelectionController>();

  JobChatActionController get actionController =>
      Get.find<JobChatActionController>();

  // Central state variables
  final RxList<JobChatMessageEntity> messages = <JobChatMessageEntity>[].obs;
  final RxList<JobChatMessageEntity> pendingMessages = <JobChatMessageEntity>[].obs;
  final RxList<MemberProfile> chatMembers = <MemberProfile>[].obs;
  final RxnString _currentUserProfileUid = RxnString(null);
  final RxnString _currentUserUid = RxnString(null);
  final RxnString _currentUserName = RxnString(null);
  StreamSubscription<ChatEvent>? _chatEventsSubscription;

  String? get currentUserId => _currentUserUid.value;

  String? get currentUserProfileUid => _currentUserProfileUid.value;

  String? get currentUserName => _currentUserName.value;

  final Rxn<JobChatMessageEntity> replyingToMessage =
      Rxn<JobChatMessageEntity>();
  final RxString highlightedMessageUid = ''.obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString(null);
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreMessages = true.obs;
  final RxSet<String> activeDownloads = <String>{}.obs;
  
  // Queue task status tracking sets
  final RxSet<String> pendingUploads = <String>{}.obs;
  final RxSet<String> uploadingMedia = <String>{}.obs;
  final RxSet<String> failedUploads = <String>{}.obs;
  
  // Background upload and progress maps
  final RxMap<String, double> uploadProgressMap = <String, double>{}.obs;
  final RxMap<String, String> uploadErrorMap = <String, String>{}.obs;


  static const int _messageLimit = 20;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final Rxn<DateTime> floatingDate = Rxn<DateTime>();
  final RxBool isFloatingDateVisible = false.obs;
  Timer? _floatingDateTimer;

  final RxBool isMessageSending = false.obs;
  final RxBool isNearBottom = true.obs;
  String? _initialFirstUnreadMessageUid;
  bool _hasCalculatedInitialUnread = false;

  int get unreadCount {
    final activeUnread = messages.where((m) => m.senderUid != _currentUserProfileUid.value && m.seenAt == null).length;
    return activeUnread + pendingMessages.length;
  }

  // Text inputs
  final messageController = TextEditingController();
  final focusNode = FocusNode();
  final RxBool hasFocus = false.obs;

  final Rx<UserRole?> _userRole = Rx<UserRole?>(null);

  UserRole? get userRole => _userRole.value;

  late final Rx<JobEntity> _job;

  JobEntity get job => _job.value;

  // ── Core functions ─────────────────────────────────────────────────

  void updateJob(JobEntity newJob) {
    _job.value = newJob;
  }

  int get initialScrollIndex {
    final index = flattenedItems.indexWhere((item) => item is ChatUnreadDividerItem);
    return index != -1 ? index : 0;
  }

  double get initialScrollAlignment {
    final index = flattenedItems.indexWhere((item) => item is ChatUnreadDividerItem);
    return index != -1 ? 0.3 : 0.0;
  }

  void _onPositionsChanged() {
    onScrollInteraction();
  }

  void _trackAndSendSeenMessages(Iterable<ItemPosition> positions) {
    final List<String> unreadUidsVisible = [];
    for (final position in positions) {
      if (position.itemLeadingEdge < 1.0 && position.itemTrailingEdge > 0.0) {
        if (position.index >= 0 && position.index < flattenedItems.length) {
          final item = flattenedItems[position.index];
          JobChatMessageEntity? msg;
          if (item is ChatMessageBubbleItem) {
            msg = item.message;
          } else if (item is ChatActivityBubble) {
            msg = item.message;
          }
          
          if (msg != null && 
              msg.senderUid != _currentUserProfileUid.value && 
              msg.seenAt == null) {
            unreadUidsVisible.add(msg.uid);
          }
        }
      }
    }

    if (unreadUidsVisible.isNotEmpty) {
      // Optimistically mark visible messages as seen locally
      for (final uid in unreadUidsVisible) {
        final idx = messages.indexWhere((m) => m.uid == uid);
        if (idx != -1) {
          messages[idx] = messages[idx].copyWith(seenAt: DateTime.now());
        }
      }
      messages.refresh();

      // Send the seen status updates to backend in batch via UseCase
      _markMessagesSeenUseCase(
        MarkMessagesSeenParams(
          jobId: job.jobId,
          messageUids: unreadUidsVisible,
        ),
      );
    }
  }

  void onScrollInteraction() {
    if (flattenedItems.isEmpty) return;

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final hasNearBottom = positions.any((p) {
        if (p.index == 0) {
          return p.itemLeadingEdge >= -0.15 && p.itemLeadingEdge <= 0.15;
        }
        return false;
      });
      isNearBottom.value = hasNearBottom;
      if (isNearBottom.value && pendingMessages.isNotEmpty) {
        messages.addAll(pendingMessages);
        pendingMessages.clear();
      }
      final topMostItemPosition = positions.reduce(
        (max, position) => position.index > max.index ? position : max,
      );
      final highestIndex = topMostItemPosition.index;

      if (highestIndex >= flattenedItems.length - 3 &&
          !isLoadingMore.value &&
          hasMoreMessages.value) {
        loadMoreMessages();
      }

      final isTopVisible = positions.any(
        (p) => p.index == flattenedItems.length - 1,
      );
      if (isTopVisible) {
        isFloatingDateVisible.value = false;
        _floatingDateTimer?.cancel();
      } else {
        isFloatingDateVisible.value = true;
        _floatingDateTimer?.cancel();
        _floatingDateTimer = Timer(const Duration(seconds: 3), () {
          isFloatingDateVisible.value = false;
        });
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

      // Track and mark visible messages as seen
      _trackAndSendSeenMessages(positions);
    }

    isFloatingDateVisible.value = true;
    _floatingDateTimer?.cancel();
    _floatingDateTimer = Timer(const Duration(seconds: 3), () {
      isFloatingDateVisible.value = false;
    });
  }

  void scrollToLast({bool animate = false}) {
    if (pendingMessages.isNotEmpty) {
      messages.addAll(pendingMessages);
      pendingMessages.clear();
    }
    _scrollToLastAfterLayout(animate: animate);
  }

  void _scrollToLastAfterLayout({required bool animate, int attempt = 0}) {
    if (flattenedItems.isEmpty || isClosed) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (flattenedItems.isEmpty || isClosed) return;

      if (!itemScrollController.isAttached) {
        if (attempt < 3) {
          _scrollToLastAfterLayout(animate: animate, attempt: attempt + 1);
        }
        return;
      }

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
    });
  }

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

      // If this is the initial first unread message, insert the unread divider
      if (message.uid == _initialFirstUnreadMessageUid) {
        items.add(const ChatUnreadDividerItem());
      }

      if (isNewDate) {
        items.add(ChatItem.dateHeader(date: messageDate));
        lastDate = messageDate;
        items.add(
          _mapMessageToChatItem(
            message,
            hasSameSenderAbove: false,
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
      (c) => c.type == JobChatMessageContentType.header,
    );

    if (hasHeaderContent) {
      return ChatItem.header(message: message);
    }

    final isActivity =
        message.type == JobChatMessageType.activity ||
        message.content.any(
          (c) => c.type == JobChatMessageContentType.activity,
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

  void addOrUpdateMessage(JobChatMessageEntity message) {
    final isMe = message.senderUid == _currentUserProfileUid.value;
    final finalMessage = message.copyWith(isMe: isMe);

    final existingIndex = messages.indexWhere((m) =>
        (finalMessage.serverUid != null && m.serverUid == finalMessage.serverUid) ||
        (m.uid == finalMessage.uid));

    if (existingIndex != -1) {
      final existingMsg = messages[existingIndex];
      if (existingMsg != finalMessage) {
        messages[existingIndex] = finalMessage;
        messages.refresh();
      }
    } else {
      final pendingIndex = pendingMessages.indexWhere((m) =>
          (finalMessage.serverUid != null && m.serverUid == finalMessage.serverUid) ||
          (m.uid == finalMessage.uid));
      if (pendingIndex != -1) {
        if (pendingMessages[pendingIndex] != finalMessage) {
          pendingMessages[pendingIndex] = finalMessage;
        }
      } else {
        if (isMe || isNearBottom.value) {
          if (pendingMessages.isNotEmpty) {
            messages.addAll(pendingMessages);
            pendingMessages.clear();
          }
          messages.add(finalMessage);
          messages.sort(
            (a, b) => a.createdByAuthorAt.compareTo(b.createdByAuthorAt),
          );
          scrollToLast(animate: true);
        } else {
          pendingMessages.add(finalMessage);
          pendingMessages.sort(
            (a, b) => a.createdByAuthorAt.compareTo(b.createdByAuthorAt),
          );
        }
      }
    }
  }

  void setReplyingTo(JobChatMessageEntity message) {
    if (message.status == JobChatMessageStatus.pending) return;
    replyingToMessage.value = message;
    focusNode.requestFocus();
  }

  void cancelReply() {
    replyingToMessage.value = null;
  }

  bool isAskLocationFulfilled(DateTime askTime) {
    return messages.any((m) {
      if (!m.timestamp.isAfter(askTime) ||
          !m.isMe ||
          m.type != JobChatMessageType.activity) {
        return false;
      }
      final type = JobActivityType.fromString(m.metadata?['activityType']);
      return type == JobActivityType.sendLocation ||
          type == JobActivityType.reachedLocation;
    });
  }

  bool isAskStatusFulfilled(JobChatMessageEntity requestMessage) {
    final reqType = JobActivityType.fromString(
      requestMessage.metadata?['activityType'],
    );

    return messages.any((m) {
      if (!m.timestamp.isAfter(requestMessage.timestamp) || !m.isMe) {
        return false;
      }

      final hasReply = m.content.any((c) {
        if (c.type != JobChatMessageContentType.reply) return false;
        final repliedMsgUid = c.metadata?['messageUid'] as String?;
        return repliedMsgUid == requestMessage.uid;
      });

      if (hasReply) {
        if (reqType == JobActivityType.askStatusProofs) {
          if (m.type == JobChatMessageType.activity) {
            final activityType = JobActivityType.fromString(
              m.metadata?['activityType'],
            );
            if (activityType == JobActivityType.sendStatus) {
              return true;
            }
          }
          return false;
        }
        return true;
      }

      if (m.type == JobChatMessageType.activity) {
        final activityType = JobActivityType.fromString(
          m.metadata?['activityType'],
        );
        final hasImage = m.content.any(
          (c) => c.type == JobChatMessageContentType.image,
        );
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
      if (item is ChatMessageBubbleItem && (item.message.uid == uid || item.message.serverUid == uid)) return true;
      if (item is ChatActivityBubble && (item.message.uid == uid || item.message.serverUid == uid)) return true;
      return false;
    });
    if (index != -1) {
      final targetItem = flattenedItems[index];
      final String localUid = targetItem is ChatMessageBubbleItem
          ? targetItem.message.uid
          : (targetItem is ChatActivityBubble ? targetItem.message.uid : uid);

      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        alignment: 0.4,
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(milliseconds: 350), () {
        _triggerHighlight(localUid);
      });
    }
  }

  void _triggerHighlight(String uid) {
    highlightedMessageUid.value = uid;
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (highlightedMessageUid.value == uid) {
        highlightedMessageUid.value = '';
      }
    });
  }

  String _resolveName(String uid) {
    if (uid == _currentUserProfileUid.value || uid == _currentUserUid.value) {
      return 'you';
    }

    final member = chatMembers.firstWhereOrNull((m) => m.uid == uid);
    if (member != null) {
      return member.name;
    }

    if (uid == job.workerProfileUid) {
      return job.workerName ?? 'Worker';
    }

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

  String resolveMemberName(String? senderUid, String fallbackName) {
    final profileUid = senderUid;
    if (profileUid != null) {
      final member = chatMembers.firstWhereOrNull((m) => m.uid == profileUid);
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

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    return spans;
  }

  JobChatMessageEntity? get headerMessage {
    try {
      return messages.firstWhere(
        (m) => m.content.any((c) => c.type == JobChatMessageContentType.header),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _job = Rx<JobEntity>(Get.arguments as JobEntity);

    _clearConversationNotificationsUseCase(_job.value.jobId);

    focusNode.addListener(() {
      hasFocus.value = focusNode.hasFocus;
      if (focusNode.hasFocus) {
        attachmentController.showAttachmentMenu.value = false;
        // Only scroll to last when the keyboard opens if the user is already
        // near the bottom. If they scrolled up to read history, don't yank
        // them back down.
        if (isNearBottom.value) {
          Future.delayed(const Duration(milliseconds: 150), () {
            scrollToLast(animate: true);
          });
        }
      }
    });

    // Register listener for viewport position changes to track message visibility
    itemPositionsListener.itemPositions.addListener(_onPositionsChanged);

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
              addOrUpdateMessage(message);
            }
          } else if (event is ChatMessageDeletedEvent) {
            if (event.jobId == job.jobId) {
              for (var i = 0; i < messages.length; i++) {
                final msg = messages[i];
                if (event.messageUids.contains(msg.uid)) {
                  messages[i] = msg.copyWith(
                    deleted: true,
                    content: [],
                  );
                }
              }
              messages.refresh();
            }
          } else if (event is ChatMessageDeliveredEvent) {
            if (event.jobId == job.jobId) {
              for (var i = 0; i < messages.length; i++) {
                if (event.messageUids.contains(messages[i].uid)) {
                  messages[i] = messages[i].copyWith(deliveredAt: event.deliveredAt);
                }
              }
              messages.refresh();
            }
          } else if (event is ChatMessageReadEvent) {
            if (event.jobId == job.jobId) {
              for (var i = 0; i < messages.length; i++) {
                if (event.messageUids.contains(messages[i].uid)) {
                  messages[i] = messages[i].copyWith(seenAt: event.seenAt);
                }
              }
              messages.refresh();
            }
          } else if (event is ChatUploadProgressEvent) {
            pendingUploads.remove(event.messageUid);
            uploadingMedia.add(event.messageUid);
            failedUploads.remove(event.messageUid);
            uploadProgressMap[event.messageUid] = event.progress;
          } else if (event is ChatUploadErrorEvent) {
            pendingUploads.remove(event.messageUid);
            uploadingMedia.remove(event.messageUid);
            failedUploads.add(event.messageUid);
            uploadErrorMap[event.messageUid] = event.error;
            uploadProgressMap.remove(event.messageUid);
          } else if (event is ChatUploadCompleteEvent) {
            uploadProgressMap.remove(event.messageUid);
            uploadErrorMap.remove(event.messageUid);
          } else if (event is ChatSendCompleteEvent) {
            pendingUploads.remove(event.messageUid);
            uploadingMedia.remove(event.messageUid);
            failedUploads.remove(event.messageUid);
            uploadProgressMap.remove(event.messageUid);
            uploadErrorMap.remove(event.messageUid);
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
      await _syncQueueTasksWithState();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _syncQueueTasksWithState() async {
    try {
      final db = Get.find<IDatabaseService>();
      
      // Query ALL tasks for debugging
      final allRows = await db.query(QueueTasksTable.tableName);
      debugPrint('SyncQueue: TOTAL tasks in DB: ${allRows.length}');
      for (final r in allRows) {
        debugPrint('SyncQueue DB Task: id=${r['id']}, type=${r['type']}, status=${r['status']}, payload=${r['payload']}');
      }

      final rows = await db.query(
        QueueTasksTable.tableName,
        where: 'payload LIKE ? AND (type = ? OR type = ?)',
        whereArgs: [
          '%"jobId":"${job.jobId}"%',
          QueueTaskType.uploadMedia.name,
          QueueTaskType.sendMessage.name,
        ],
      );

      pendingUploads.clear();
      uploadingMedia.clear();
      failedUploads.clear();

      for (final row in rows) {
        final taskId = row['id'] as String;
        final status = row['status'] as String;

        if (status == QueueTaskStatus.pending.name) {
          pendingUploads.add(taskId);
        } else if (status == QueueTaskStatus.processing.name) {
          uploadingMedia.add(taskId);
        } else if (status == QueueTaskStatus.failed.name) {
          failedUploads.add(taskId);
          uploadErrorMap[taskId] = 'Failed to send';
        }
      }
    } catch (e) {
      debugPrint('JobChatController: Error syncing queue tasks: $e');
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
    final role = await authController.userRole;
    if (role != null) {
      _userRole.value = role;
    }
  }

  Future<void> fetchMessages() async {
    isLoading.value = true;
    errorMessage.value = null;
    hasMoreMessages.value = true;
    messages.clear();
    pendingMessages.clear();
    _initialFirstUnreadMessageUid = null;
    _hasCalculatedInitialUnread = false;

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

          if (!_hasCalculatedInitialUnread) {
            _initialFirstUnreadMessageUid = null;
            for (int i = updatedMessages.length - 1; i >= 0; i--) {
              final m = updatedMessages[i];
              if (m.senderUid != _currentUserProfileUid.value && m.seenAt == null) {
                _initialFirstUnreadMessageUid = m.uid;
                break;
              }
            }
            _hasCalculatedInitialUnread = true;
          }

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

        // Deduplicate against already-loaded messages.
        final List<JobChatMessageEntity> uniqueNewMessages = [];
        for (final m in updatedMessages) {
          final exists = messages.any((existing) =>
              (m.serverUid != null && existing.serverUid == m.serverUid) ||
              (existing.uid == m.uid));
          if (!exists) {
            uniqueNewMessages.add(m);
          }
        }

        if (uniqueNewMessages.isNotEmpty) {
          messages.addAll(uniqueNewMessages);
          // Always keep the list in chronological order (oldest first).
          // Without this sort, out-of-order messages break flattenedItems
          // and produce duplicate date headers.
          messages.sort(
            (a, b) => a.createdByAuthorAt.compareTo(b.createdByAuthorAt),
          );
        }

        isLoadingMore.value = false;
      },
    );
  }

  Future<void> sendMediaMessagesBackground(
    List<MediaPreviewItem> items, {
    JobChatMessageEntity? replyingTo,
    String caption = '',
  }) async {
    if (_currentUserProfileUid.value == null) {
      AppSnackbar.destructive('User information not found. Please try again.');
      return;
    }

    if (userRole == UserRole.worker) {
      if (Get.isRegistered<AttendanceController>()) {
        final attendanceController = Get.find<AttendanceController>();
        if (attendanceController.attendanceStatus.value != AttendanceStatus.working) {
          AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
          return;
        }
      } else {
        AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
        return;
      }
    }

    final mediaItems = items
        .where((item) =>
            item.type == JobChatMessageContentType.image ||
            item.type == JobChatMessageContentType.video)
        .toList();
    final docItems = items
        .where((item) =>
            item.type == JobChatMessageContentType.document ||
            item.type == JobChatMessageContentType.pdf)
        .toList();

    if (mediaItems.isNotEmpty) {
      _composeAndSend(mediaItems, replyingTo: replyingTo, caption: caption);
    }

    for (int i = 0; i < docItems.length; i++) {
      final attachReply = (mediaItems.isEmpty && i == 0) ? replyingTo : null;
      final attachCaption = (mediaItems.isEmpty && i == 0) ? caption : '';
      _composeAndSend([docItems[i]], replyingTo: attachReply, caption: attachCaption);
    }
  }

  void _composeAndSend(
    List<MediaPreviewItem> items, {
    JobChatMessageEntity? replyingTo,
    String caption = '',
  }) {
    final localId = 'temp_${nanoid(10)}';
    pendingUploads.add(localId);
    final contentList = <JobChatMessageContentEntity>[
      if (replyingTo != null)
        buildReplyContent(replyingTo, senderName: getSenderName(replyingTo)),
      ...items.map((item) => JobChatMessageContentEntity(
            type: item.type,
            content: item.path,
            metadata: item.metadata.toJson(),
          )),
      if (caption.isNotEmpty)
        JobChatMessageContentEntity(
          type: JobChatMessageContentType.text,
          content: caption,
        ),
    ];

    _sendMessageUseCase(
      SendMessageParams(
        messages: [
          SendMessageEntity(
            localUid: localId,
            jobId: job.jobId,
            senderUid: _currentUserProfileUid.value,
            content: contentList,
            createdByAuthorAt: DateTime.now(),
            type: JobChatMessageType.message,
          ),
        ],
      ),
    );
  }

  void retryMessageUpload(String localId) {
    uploadErrorMap.remove(localId);
    uploadProgressMap[localId] = 0.0;
    failedUploads.remove(localId);
    pendingUploads.add(localId);
    _retryMessageUploadUseCase(RetryMessageUploadParams(messageUid: localId));
  }

  void cancelMessageUpload(String localId) {
    uploadProgressMap.remove(localId);
    uploadErrorMap.remove(localId);
    pendingUploads.remove(localId);
    uploadingMedia.remove(localId);
    failedUploads.remove(localId);
    _cancelMessageUploadUseCase(CancelMessageUploadParams(messageUid: localId));
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
        if (attendanceController.attendanceStatus.value != AttendanceStatus.working) {
          AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
          return;
        }
      } else {
        AppSnackbar.warn(AppStrings.jobChat.attendanceRequired);
        return;
      }
    }

    final repliedMsg = replyingToMessage.value;
    Map<String, dynamic> locationData = {};

    if (userRole == UserRole.worker &&
        repliedMsg != null &&
        repliedMsg.type == JobChatMessageType.activity) {
      final activityType = JobActivityType.fromString(repliedMsg.metadata?['activityType']);
      if (activityType == JobActivityType.askStatus) {
        try {
          locationData = await actionController.acquireLocationAndAddress();
        } catch (e) {
          debugPrint('Location fetch failed: $e');
        }
      }
    }

    final List<JobChatMessageContentEntity> contentList = [
      if (repliedMsg != null) buildReplyContent(repliedMsg, senderName: getSenderName(repliedMsg)),
      JobChatMessageContentEntity(
        type: JobChatMessageContentType.text,
        content: text,
      ),
    ];

    final isActivityReply = locationData.isNotEmpty;
    final metadata = {
      ...locationData,
      if (isActivityReply) 'activityType': JobActivityType.sendStatus.value,
    };

    // Clear input immediately so the user can keep typing.
    messageController.clear();
    replyingToMessage.value = null;
    _initialFirstUnreadMessageUid = null;

    final localUid = nanoid(10);
    pendingUploads.add(localUid);

    final result = await _sendMessageUseCase(
      SendMessageParams(
        messages: [
          SendMessageEntity(
            localUid: localUid,
            jobId: job.jobId,
            senderUid: _currentUserProfileUid.value,
            content: contentList,
            createdByAuthorAt: DateTime.now(),
            type: isActivityReply ? JobChatMessageType.activity : JobChatMessageType.message,
            metadata: metadata.isNotEmpty ? metadata : null,
          ),
        ],
      ),
    );

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (_) {},
    );
  }

  Future<void> sendCapturedVideo(String videoPath) async {
    try {
      isMessageSending.value = true;
      final file = File(videoPath);
      final fileSize = await file.length();
      final fileName = file.path.split('/').last;
      final mimeType = lookupMimeType(file.path) ?? 'video/mp4';

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

      final item = MediaPreviewItem(
        path: videoPath,
        type: JobChatMessageContentType.video,
        metadata: ChatMessageMetadataModel(
          fileName: fileName,
          size: AppUtils.formatFileSize(fileSize),
          mimeType: mimeType,
          videoMetadata: VideoMetadataModel(
            aspectRatio: aspectRatio,
            duration: durationSec,
            thumbnailBlurHash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
          ),
        ),
      );

      await sendMediaMessagesBackground([item]);
    } catch (e) {
      AppSnackbar.destructive('Error sending captured video: $e');
    } finally {
      isMessageSending.value = false;
    }
  }

  void onBack() => Get.back();

  @override
  void onClose() {
    itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    _chatEventsSubscription?.cancel();
    messageController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
