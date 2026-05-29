import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationLoadAll extends NotificationEvent {
  const NotificationLoadAll();
}

class NotificationMarkRead extends NotificationEvent {
  final String notificationId;
  const NotificationMarkRead(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class NotificationMarkAllRead extends NotificationEvent {
  const NotificationMarkAllRead();
}

class NotificationDelete extends NotificationEvent {
  final String notificationId;
  const NotificationDelete(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class NotificationFilterCategory extends NotificationEvent {
  final String category;
  const NotificationFilterCategory(this.category);
  @override
  List<Object?> get props => [category];
}
