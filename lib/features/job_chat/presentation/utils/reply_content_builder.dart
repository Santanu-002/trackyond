import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

/// Builds a [JobChatMessageContentEntity] of type [JobChatMessageContentType.reply]
/// from a message being replied to.
///
/// [senderName] is the resolved display name for the sender (e.g. "You", "John Doe").
/// This is kept as a parameter so the builder stays decoupled from the controller.
JobChatMessageContentEntity buildReplyContent(
  JobChatMessageEntity repliedMsg, {
  required String senderName,
}) {
  String originalText = '';
  String contentType = 'text';
  String? mediaUrl;
  String? replyBlurHash;
  int? pageCount;

  final textContent = repliedMsg.content.firstWhereOrNull(
    (c) =>
        c.type == JobChatMessageContentType.text ||
        c.type == JobChatMessageContentType.activity,
  );
  originalText = textContent?.content ?? '';

  final mediaItems = repliedMsg.content
      .where((c) =>
          c.type == JobChatMessageContentType.image ||
          c.type == JobChatMessageContentType.video ||
          c.type == JobChatMessageContentType.document ||
          c.type == JobChatMessageContentType.pdf)
      .toList();

  if (mediaItems.isNotEmpty) {
    final firstMedia = mediaItems.first;
    contentType = firstMedia.type.value;
    mediaUrl = firstMedia.content;

    if (firstMedia.type == JobChatMessageContentType.image) {
      final imgMeta = firstMedia.metadata?['imageMetadata'];
      replyBlurHash =
          imgMeta?['blurHash'] ?? firstMedia.metadata?['blurHash'];
      if (originalText.isEmpty) originalText = 'Photo';
    } else if (firstMedia.type == JobChatMessageContentType.video) {
      final vidMeta = firstMedia.metadata?['videoMetadata'];
      replyBlurHash =
          vidMeta?['thumbnailBlurHash'] ?? firstMedia.metadata?['blurHash'];
      if (originalText.isEmpty) originalText = 'Video';
    } else if (firstMedia.type == JobChatMessageContentType.pdf) {
      final pdfMeta = firstMedia.metadata?['pdfMetadata'];
      pageCount = pdfMeta?['pageCount'];
      if (originalText.isEmpty) originalText = 'PDF';
    } else if (firstMedia.type == JobChatMessageContentType.document) {
      final docMeta = firstMedia.metadata?['documentMetadata'];
      pageCount = docMeta?['pageCount'];
      if (originalText.isEmpty) originalText = 'Document';
    }
  }

  final remainingMediaCount =
      mediaItems.length > 1 ? (mediaItems.length - 1) : 0;

  return JobChatMessageContentEntity(
    type: JobChatMessageContentType.reply,
    content: originalText,
    metadata: {
      'replyMetadata': {
        'messageUid': repliedMsg.uid,
        'senderName': senderName,
        'senderUid': repliedMsg.senderUid,
        'type': repliedMsg.type.value,
        'contentType': contentType,
        'mediaUrl': mediaUrl,
        'blurHash': replyBlurHash,
        'pageCount': pageCount,
        'remainingMediaCount': remainingMediaCount,
        'activityType': repliedMsg.metadata?['activityType'],
      }
    },
  );
}
