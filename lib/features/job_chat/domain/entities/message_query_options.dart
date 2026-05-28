import 'package:equatable/equatable.dart';

class MessageQueryOptions extends Equatable {
  final int? limit;
  final int? offset;
  final String? searchQuery;
  final String? messageType;

  const MessageQueryOptions({
    this.limit,
    this.offset,
    this.searchQuery,
    this.messageType,
  });

  @override
  List<Object?> get props => [limit, offset, searchQuery, messageType];
}
