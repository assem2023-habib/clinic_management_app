import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiService _api;

  NotificationRemoteDataSource(this._api);

  Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 20}) async {
    final response = await _api.get('/notifications', queryParameters: {
      'page': page,
      'limit': limit,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    final notifications = (data['notifications'] as List<dynamic>? ?? [])
        .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final unreadCount = data['unread_count'] as int? ?? 0;
    return {
      'notifications': notifications,
      'unread_count': unreadCount,
    };
  }

  Future<NotificationModel> getNotificationById(String id) async {
    final response = await _api.get('/notifications/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return NotificationModel.fromMap(data);
  }

  Future<void> markAsRead(String id) async {
    await _api.post('/notifications/$id/read');
  }

  Future<void> markMultipleAsRead(List<String> ids) async {
    await _api.post('/notifications/read', data: {'ids': ids});
  }

  Future<void> markAllAsRead() async {
    await _api.post('/notifications/read-all');
  }

  Future<void> deleteNotification(String id) async {
    await _api.delete('/notifications/$id');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    await _api.delete('/notifications', data: {'ids': ids});
  }

  Future<void> deleteAll() async {
    await _api.delete('/notifications/all');
  }
}
