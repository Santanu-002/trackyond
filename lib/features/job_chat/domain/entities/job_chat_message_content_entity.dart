import 'package:equatable/equatable.dart';

class JobChatMessageContentEntity extends Equatable {
  final String type;
  final String? content;
  final Map<String, dynamic>? metadata;

  const JobChatMessageContentEntity({
    required this.type,
    this.content,
    this.metadata,
  });

  @override
  List<Object?> get props => [type, content, metadata];
}

