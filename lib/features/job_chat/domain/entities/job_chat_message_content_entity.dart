import 'package:equatable/equatable.dart';

class JobChatMessageContentEntity extends Equatable {
  final String type;
  final String? content;
  final Map<String, dynamic>? metadata;
  final String? actionPerformed;

  const JobChatMessageContentEntity({
    required this.type,
    this.content,
    this.metadata,
    this.actionPerformed,
  });

  @override
  List<Object?> get props => [type, content, metadata, actionPerformed];
}

