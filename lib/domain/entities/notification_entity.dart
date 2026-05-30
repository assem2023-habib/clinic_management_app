import 'package:equatable/equatable.dart';

enum NotificationType { appointment, medical, system }

class NotificationEntity extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedId;
  final String? topic;
  final Map<String, dynamic>? body;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.relatedId,
    this.topic,
    this.body,
  });

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId,
      topic: topic,
      body: body,
    );
  }

  @override
  List<Object?> get props => [id, type, title, message, timestamp, isRead, relatedId, topic, body];
}
