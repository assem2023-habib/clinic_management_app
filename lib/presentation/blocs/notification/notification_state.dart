import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final String activeCategory;
  final int unreadCount;
  final int currentPage;
  final bool hasMore;

  const NotificationLoaded(this.notifications, {
    this.activeCategory = 'all',
    this.unreadCount = 0,
    this.currentPage = 1,
    this.hasMore = false,
  });
  @override
  List<Object?> get props => [notifications, activeCategory, unreadCount, currentPage, hasMore];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
