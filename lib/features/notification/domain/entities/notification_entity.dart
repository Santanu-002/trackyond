import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final Map<String, dynamic>? data;
  final bool isRead;
  final bool isSeen;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.data,
    this.isRead = false,
    this.isSeen = false,
  });

  @override
  List<Object?> get props => [id, title, body, createdAt, data, isRead, isSeen];

  NotificationEntity copyWithEntity({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    Map<String, dynamic>? data,
    bool? isRead,
    bool? isSeen,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}
