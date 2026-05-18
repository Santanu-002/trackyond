import 'package:equatable/equatable.dart';

class JobChatMessageContentEntity extends Equatable {
  final String type;
  final String? message;
  final Map<String, dynamic>? metadata;

  const JobChatMessageContentEntity({
    required this.type,
    this.message,
    this.metadata,
  });

  @override
  List<Object?> get props => [type, message, metadata];
}
