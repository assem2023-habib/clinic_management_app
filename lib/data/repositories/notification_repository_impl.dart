import 'package:clinic_management_app/data/datasources/remote/notification_remote_datasource.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';
import 'package:clinic_management_app/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource? remoteDataSource;

  NotificationRepositoryImpl({this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 20, String? category}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getNotifications(page: page, limit: limit);
      } catch (_) {}
    }
    return _mockResult(category: category);
  }

  @override
  Future<NotificationEntity?> getNotificationById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getNotificationById(id);
      } catch (_) {}
    }
    try {
      return _mockNotifications.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.markAsRead(id);
        return;
      } catch (_) {}
    }
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.markAllAsRead();
        return;
      } catch (_) {}
    }
    _mockNotifications = _mockNotifications.map((n) => n.copyWith(isRead: true)).toList();
  }

  @override
  Future<void> deleteNotification(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteNotification(id);
        return;
      } catch (_) {}
    }
    _mockNotifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> deleteAll() async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteAll();
        return;
      } catch (_) {}
    }
    _mockNotifications.clear();
  }

  Map<String, dynamic> _mockResult({String? category}) {
    var list = List<NotificationEntity>.from(_mockNotifications);
    if (category != null && category != 'all') {
      if (category == 'unread') {
        list = list.where((n) => !n.isRead).toList();
      } else {
        final typeMap = <String, NotificationType>{
          'medical': NotificationType.medical,
          'appointment': NotificationType.appointment,
          'system': NotificationType.system,
        };
        final type = typeMap[category];
        if (type != null) list = list.where((n) => n.type == type).toList();
      }
    }
    return {
      'notifications': list,
      'unread_count': _mockNotifications.where((n) => !n.isRead).length,
    };
  }

  static List<NotificationEntity> _mockNotifications = [
    NotificationEntity(
      id: '1', type: NotificationType.appointment, title: 'موعد جديد', message: 'تم تأكيد موعدك مع د. أحمد السيد يوم الجمعة ٢٠٢٦-٠٦-٠١ الساعة ١٠:٠٠ صباحاً.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)), isRead: false,
    ),
    NotificationEntity(
      id: '2', type: NotificationType.medical, title: 'نتيجة تحليل', message: 'نتيجة تحليل الدم الشامل جاهزة. يمكنك الاطلاع عليها من صفحة الملفات.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)), isRead: false,
    ),
    NotificationEntity(
      id: '3', type: NotificationType.system, title: 'تحديث التطبيق', message: 'تتوفر نسخة جديدة من التطبيق (v3.2.0). يرجى التحديث للحصول على آخر الميزات.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)), isRead: true,
    ),
    NotificationEntity(
      id: '4', type: NotificationType.appointment, title: 'تذكير بالموعد', message: 'لديك موعد مع د. سارة محمد بعد غدٍ الساعة ٢:٣٠ عصراً. يرجى التأكيد.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)), isRead: false,
    ),
    NotificationEntity(
      id: '5', type: NotificationType.medical, title: 'وصفة طبية جديدة', message: 'تم إضافة وصفة طبية جديدة من قبل د. خالد عمر. يمكنك مراجعتها في صفحة الوصفات.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)), isRead: false,
    ),
    NotificationEntity(
      id: '6', type: NotificationType.system, title: 'أمان الحساب', message: 'تم تسجيل الدخول من جهاز جديد. إذا لم يكن هذا أنت، يرجى تغيير كلمة المرور فوراً.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)), isRead: true,
    ),
    NotificationEntity(
      id: '7', type: NotificationType.appointment, title: 'تم إلغاء الموعد', message: 'تم إلغاء موعدك مع د. ليلى أحمد ليوم ٢٠٢٦-٠٥-٢٨. يرجى حجز موعد جديد.',
      timestamp: DateTime.now().subtract(const Duration(days: 7)), isRead: true,
    ),
    NotificationEntity(
      id: '8', type: NotificationType.medical, title: 'تذكير بالدواء', message: 'حان وقت تناول دوائك (أملوديبين ٥مغ). يرجى الالتزام بالموعد المحدد.',
      timestamp: DateTime.now().subtract(const Duration(days: 10)), isRead: true,
    ),
  ];
}
