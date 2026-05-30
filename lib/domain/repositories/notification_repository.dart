import 'package:clinic_management_app/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Map<String, dynamic>> getNotifications({int page, int limit, String? category});
  Future<NotificationEntity?> getNotificationById(String id);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> deleteAll();
}
