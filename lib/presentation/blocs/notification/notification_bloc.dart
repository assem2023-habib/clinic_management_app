import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationLoadAll>(_onLoadAll);
    on<NotificationMarkRead>(_onMarkRead);
    on<NotificationMarkAllRead>(_onMarkAllRead);
    on<NotificationDelete>(_onDelete);
    on<NotificationFilterCategory>(_onFilterCategory);
  }

  List<NotificationEntity> _allNotifications = _mockNotifications;
  String _currentCategory = 'all';

  Future<void> _onLoadAll(NotificationLoadAll event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    _allNotifications = _mockNotifications;
    emit(_buildLoaded());
  }

  void _onMarkRead(NotificationMarkRead event, Emitter<NotificationState> emit) {
    final index = _allNotifications.indexWhere((n) => n.id == event.notificationId);
    if (index != -1) {
      _allNotifications[index] = _allNotifications[index].copyWith(isRead: true);
    }
    if (state is NotificationLoaded) {
      emit(_buildLoaded());
    }
  }

  void _onMarkAllRead(NotificationMarkAllRead event, Emitter<NotificationState> emit) {
    _allNotifications = _allNotifications.map((n) => n.copyWith(isRead: true)).toList();
    if (state is NotificationLoaded) {
      emit(_buildLoaded());
    }
  }

  void _onDelete(NotificationDelete event, Emitter<NotificationState> emit) {
    _allNotifications.removeWhere((n) => n.id == event.notificationId);
    if (state is NotificationLoaded) {
      emit(_buildLoaded());
    }
  }

  void _onFilterCategory(NotificationFilterCategory event, Emitter<NotificationState> emit) {
    _currentCategory = event.category;
    if (state is NotificationLoaded) {
      emit(_buildLoaded());
    }
  }

  NotificationLoaded _buildLoaded() {
    final filtered = _filtered();
    final unread = _allNotifications.where((n) => !n.isRead).length;
    return NotificationLoaded(filtered, activeCategory: _currentCategory, unreadCount: unread);
  }

  List<NotificationEntity> _filtered() {
    if (_currentCategory == 'all') return List.from(_allNotifications);
    if (_currentCategory == 'unread') return _allNotifications.where((n) => !n.isRead).toList();
    final typeMap = <String, NotificationType>{
      'medical': NotificationType.medical,
      'appointment': NotificationType.appointment,
      'system': NotificationType.system,
    };
    final type = typeMap[_currentCategory];
    if (type != null) return _allNotifications.where((n) => n.type == type).toList();
    return List.from(_allNotifications);
  }

  static final List<NotificationEntity> _mockNotifications = [
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
