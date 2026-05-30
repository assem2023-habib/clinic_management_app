import 'package:clinic_management_app/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.message,
    required super.timestamp,
    super.isRead = false,
    super.relatedId,
    super.topic,
    super.body,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final topic = map['topic'] as String? ?? '';
    final type = _deriveType(topic);
    final bodyRaw = map['body'] as Map<String, dynamic>?;
    final message = _buildMessage(bodyRaw);
    final relatedId = _extractRelatedId(bodyRaw);

    return NotificationModel(
      id: map['id'] as String? ?? '',
      type: type,
      title: map['title'] as String? ?? '',
      message: message,
      timestamp: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
      isRead: map['is_read'] as bool? ?? (map['read_at'] != null),
      relatedId: relatedId,
      topic: topic,
      body: bodyRaw,
    );
  }

  static NotificationType _deriveType(String topic) {
    if (topic.startsWith('appointment.')) return NotificationType.appointment;
    if (topic.startsWith('medical.')) return NotificationType.medical;
    if (topic.startsWith('login.')) return NotificationType.system;
    return NotificationType.system;
  }

  static String _buildMessage(Map<String, dynamic>? body) {
    if (body == null || body.isEmpty) return '';
    final parts = <String>[];
    if (body['reason'] != null) parts.add('Reason: ${body['reason']}');
    if (body['message'] != null) parts.add('${body['message']}');
    return parts.isNotEmpty ? parts.join(' • ') : '';
  }

  static String? _extractRelatedId(Map<String, dynamic>? body) {
    if (body == null) return null;
    return body['appointment_id'] as String? ??
        body['doctor_id'] as String?;
  }
}
