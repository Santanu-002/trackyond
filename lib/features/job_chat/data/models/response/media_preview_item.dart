import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';

part 'media_preview_item.freezed.dart';
part 'media_preview_item.g.dart';

@freezed
sealed class MediaPreviewItem with _$MediaPreviewItem {
  const factory MediaPreviewItem({
    required String path,
    required JobChatMessageContentType type,
    required ChatMessageMetadataModel metadata,
  }) = _MediaPreviewItem;

  const MediaPreviewItem._();

  factory MediaPreviewItem.fromJson(Map<String, dynamic> json) =>
      _$MediaPreviewItemFromJson(json);
}
