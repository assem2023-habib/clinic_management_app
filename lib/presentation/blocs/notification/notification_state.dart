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

  const NotificationLoaded(this.notifications, {this.activeCategory = 'all', this.unreadCount = 0});
  @override
  List<Object?> get props => [notifications, activeCategory, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
