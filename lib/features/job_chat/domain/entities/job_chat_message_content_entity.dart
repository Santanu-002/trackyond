import 'package:equatable/equatable.dart';

class JobChatMessageContentEntity extends Equatable {
  final String type;
  final String? message;
  final Map<String, dynamic>? metadata;
  final String? actionPerformed;

  const JobChatMessageContentEntity({
    required this.type,
    this.message,
    this.metadata,
    this.actionPerformed,
  });

  @override
  List<Object?> get props => [type, message, metadata, actionPerformed];
}
