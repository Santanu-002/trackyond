import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';

part 'message_query_options_model.freezed.dart';
part 'message_query_options_model.g.dart';

@freezed
sealed class MessageQueryOptionsModel with _$MessageQueryOptionsModel {
  const factory MessageQueryOptionsModel({
    int? limit,
    int? offset,
    @JsonKey(name: 'search') String? searchQuery,
    @JsonKey(name: 'type') String? messageType,
  }) = _MessageQueryOptionsModel;

  const MessageQueryOptionsModel._();

  factory MessageQueryOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$MessageQueryOptionsModelFromJson(json);

  factory MessageQueryOptionsModel.fromEntity(MessageQueryOptions entity) =>
      MessageQueryOptionsModel(
        limit: entity.limit,
        offset: entity.offset,
        searchQuery: entity.searchQuery,
        messageType: entity.messageType,
      );

  Map<String, dynamic> toQueryParams() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (searchQuery != null && searchQuery!.isNotEmpty) 'search': searchQuery,
      if (messageType != null && messageType!.isNotEmpty) 'type': messageType,
    };
  }
}
