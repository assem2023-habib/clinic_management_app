import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';
import 'package:clinic_management_app/domain/repositories/notification_repository.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  List<NotificationEntity> _allNotifications = [];
  String _currentCategory = 'all';
  int _currentPage = 1;
  bool _hasMore = true;

  NotificationBloc(this._repository) : super(NotificationInitial()) {
    on<NotificationLoadAll>(_onLoadAll);
    on<NotificationLoadMore>(_onLoadMore);
    on<NotificationMarkRead>(_onMarkRead);
    on<NotificationMarkAllRead>(_onMarkAllRead);
    on<NotificationDelete>(_onDelete);
    on<NotificationDeleteAll>(_onDeleteAll);
    on<NotificationFilterCategory>(_onFilterCategory);
  }

  Future<void> _onLoadAll(NotificationLoadAll event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      _currentPage = 1;
      _hasMore = true;
      final result = await _repository.getNotifications(
        page: event.page, limit: event.limit, category: _currentCategory == 'all' ? null : _currentCategory,
      );
      _allNotifications = result['notifications'] as List<NotificationEntity>;
      final unreadCount = result['unread_count'] as int? ?? 0;
      _currentPage = event.page;
      _hasMore = _allNotifications.length >= event.limit;
      emit(NotificationLoaded(_allNotifications, activeCategory: _currentCategory, unreadCount: unreadCount, currentPage: _currentPage, hasMore: _hasMore));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onLoadMore(NotificationLoadMore event, Emitter<NotificationState> emit) async {
    if (!_hasMore) return;
    try {
      final nextPage = _currentPage + 1;
      final result = await _repository.getNotifications(
        page: nextPage, limit: 20, category: _currentCategory == 'all' ? null : _currentCategory,
      );
      final newNotifications = result['notifications'] as List<NotificationEntity>;
      final unreadCount = result['unread_count'] as int? ?? 0;
      _allNotifications.addAll(newNotifications);
      _currentPage = nextPage;
      _hasMore = newNotifications.length >= 20;
      emit(NotificationLoaded(_allNotifications, activeCategory: _currentCategory, unreadCount: unreadCount, currentPage: _currentPage, hasMore: _hasMore));
    } catch (_) {}
  }

  Future<void> _onMarkRead(NotificationMarkRead event, Emitter<NotificationState> emit) async {
    try {
      await _repository.markAsRead(event.notificationId);
      final index = _allNotifications.indexWhere((n) => n.id == event.notificationId);
      if (index != -1) {
        _allNotifications[index] = _allNotifications[index].copyWith(isRead: true);
      }
      if (state is NotificationLoaded) {
        emit(_buildLoaded());
      }
    } catch (_) {}
  }

  Future<void> _onMarkAllRead(NotificationMarkAllRead event, Emitter<NotificationState> emit) async {
    try {
      await _repository.markAllAsRead();
      _allNotifications = _allNotifications.map((n) => n.copyWith(isRead: true)).toList();
      if (state is NotificationLoaded) {
        emit(_buildLoaded());
      }
    } catch (_) {}
  }

  Future<void> _onDelete(NotificationDelete event, Emitter<NotificationState> emit) async {
    try {
      await _repository.deleteNotification(event.notificationId);
      _allNotifications.removeWhere((n) => n.id == event.notificationId);
      if (state is NotificationLoaded) {
        emit(_buildLoaded());
      }
    } catch (_) {}
  }

  Future<void> _onDeleteAll(NotificationDeleteAll event, Emitter<NotificationState> emit) async {
    try {
      await _repository.deleteAll();
      _allNotifications.clear();
      if (state is NotificationLoaded) {
        emit(_buildLoaded());
      }
    } catch (_) {}
  }

  Future<void> _onFilterCategory(NotificationFilterCategory event, Emitter<NotificationState> emit) async {
    _currentCategory = event.category;
    emit(NotificationLoading());
    try {
      _currentPage = 1;
      _hasMore = true;
      final category = event.category == 'all' ? null : event.category;
      final result = await _repository.getNotifications(category: category);
      _allNotifications = result['notifications'] as List<NotificationEntity>;
      final unreadCount = result['unread_count'] as int? ?? 0;
      emit(NotificationLoaded(_allNotifications, activeCategory: _currentCategory, unreadCount: unreadCount, currentPage: 1, hasMore: _hasMore));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  NotificationLoaded _buildLoaded() {
    final unread = _allNotifications.where((n) => !n.isRead).length;
    return NotificationLoaded(_allNotifications, activeCategory: _currentCategory, unreadCount: unread, currentPage: _currentPage, hasMore: _hasMore);
  }
}
