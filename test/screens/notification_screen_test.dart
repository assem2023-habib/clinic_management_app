import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';
import 'package:clinic_management_app/domain/repositories/notification_repository.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';
import 'package:clinic_management_app/presentation/screens/notification/notification_screen.dart';

class _MockNotificationRepository implements NotificationRepository {
  final List<NotificationEntity> _items = [
    NotificationEntity(id: '1', type: NotificationType.appointment, title: 't1', message: 'm1', timestamp: DateTime.now(), isRead: false),
    NotificationEntity(id: '2', type: NotificationType.medical, title: 't2', message: 'm2', timestamp: DateTime.now(), isRead: false),
    NotificationEntity(id: '3', type: NotificationType.system, title: 't3', message: 'm3', timestamp: DateTime.now(), isRead: true),
    NotificationEntity(id: '4', type: NotificationType.appointment, title: 't4', message: 'm4', timestamp: DateTime.now(), isRead: false),
    NotificationEntity(id: '5', type: NotificationType.medical, title: 't5', message: 'm5', timestamp: DateTime.now(), isRead: false),
    NotificationEntity(id: '6', type: NotificationType.system, title: 't6', message: 'm6', timestamp: DateTime.now(), isRead: true),
    NotificationEntity(id: '7', type: NotificationType.appointment, title: 't7', message: 'm7', timestamp: DateTime.now(), isRead: true),
    NotificationEntity(id: '8', type: NotificationType.medical, title: 't8', message: 'm8', timestamp: DateTime.now(), isRead: true),
  ];

  @override
  Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 20, String? category}) async {
    var list = List<NotificationEntity>.from(_items);
    if (category != null && category != 'all') {
      if (category == 'unread') {
        list = list.where((n) => !n.isRead).toList();
      } else {
        final typeMap = <String, NotificationType>{
          'medical': NotificationType.medical, 'appointment': NotificationType.appointment, 'system': NotificationType.system,
        };
        final type = typeMap[category];
        if (type != null) list = list.where((n) => n.type == type).toList();
      }
    }
    return {'notifications': list, 'unread_count': _items.where((n) => !n.isRead).length};
  }

  @override
  Future<NotificationEntity?> getNotificationById(String id) async {
    try { return _items.firstWhere((n) => n.id == id); } catch (_) { return null; }
  }

  @override
  Future<void> markAsRead(String id) async {
    final i = _items.indexWhere((n) => n.id == id);
    if (i != -1) _items[i] = _items[i].copyWith(isRead: true);
  }

  @override
  Future<void> markAllAsRead() async {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }
  }

  @override
  Future<void> deleteNotification(String id) async => _items.removeWhere((n) => n.id == id);

  @override
  Future<void> deleteAll() async => _items.clear();
}

NotificationBloc createBloc() => NotificationBloc(_MockNotificationRepository());

Widget buildTestWidget(NotificationBloc bloc) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: bloc,
        child: const NotificationScreen(),
      ),
    ),
  );
}

void main() {
  group('NotificationBloc', () {
    test('initial state is NotificationInitial', () {
      final bloc = createBloc();
      expect(bloc.state, isA<NotificationInitial>());
      bloc.close();
    });

    test('emits loading then loaded after load', () async {
      final bloc = createBloc();
      bloc.add(const NotificationLoadAll());
      await expectLater(
        bloc.stream,
        emitsInOrder([isA<NotificationLoading>(), isA<NotificationLoaded>()]),
      );
      await bloc.close();
    });

    test('mark read sets isRead to true', () async {
      final bloc = createBloc();
      bloc.add(const NotificationLoadAll());
      await bloc.stream.firstWhere((s) => s is NotificationLoaded);
      bloc.add(const NotificationMarkRead('1'));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as NotificationLoaded;
      expect(state.notifications.firstWhere((n) => n.id == '1').isRead, true);
      bloc.close();
    });

    test('mark all read sets unreadCount to 0', () async {
      final bloc = createBloc();
      bloc.add(const NotificationLoadAll());
      await bloc.stream.firstWhere((s) => s is NotificationLoaded);
      bloc.add(const NotificationMarkAllRead());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as NotificationLoaded;
      expect(state.unreadCount, 0);
      bloc.close();
    });

    test('delete removes notification', () async {
      final bloc = createBloc();
      bloc.add(const NotificationLoadAll());
      await bloc.stream.firstWhere((s) => s is NotificationLoaded);
      final before = (bloc.state as NotificationLoaded).notifications.length;
      bloc.add(const NotificationDelete('1'));
      await Future.delayed(const Duration(milliseconds: 50));
      final after = (bloc.state as NotificationLoaded).notifications.length;
      expect(after, before - 1);
      bloc.close();
    });

    test('filter by category filters correctly', () async {
      final bloc = createBloc();
      bloc.add(const NotificationLoadAll());
      await bloc.stream.firstWhere((s) => s is NotificationLoaded);
      bloc.add(const NotificationFilterCategory('medical'));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as NotificationLoaded;
      expect(state.activeCategory, 'medical');
      expect(state.notifications.every((n) => n.type == NotificationType.medical), true);
      bloc.close();
    });

    test('filter by unread shows only unread', () async {
      final bloc = createBloc();
      bloc.add(const NotificationLoadAll());
      await bloc.stream.firstWhere((s) => s is NotificationLoaded);
      bloc.add(const NotificationFilterCategory('unread'));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as NotificationLoaded;
      expect(state.notifications.every((n) => !n.isRead), true);
      bloc.close();
    });
  });

  group('NotificationScreen', () {
    testWidgets('renders title and back button', (tester) async {
      final bloc = createBloc();
      await tester.pumpWidget(buildTestWidget(bloc));
      await tester.pump();
      expect(find.text(AppStrings.ntTitle), findsOneWidget);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
      bloc.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders mark all read button', (tester) async {
      final bloc = createBloc();
      await tester.pumpWidget(buildTestWidget(bloc));
      await tester.pump();
      expect(find.byIcon(Icons.done_all_rounded), findsOneWidget);
      bloc.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('shows filter chips after load', (tester) async {
      final bloc = createBloc();
      await tester.pumpWidget(buildTestWidget(bloc));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(find.text(AppStrings.ntCategoryAll), findsOneWidget);
      expect(find.text(AppStrings.ntCategoryUnread), findsOneWidget);
      expect(find.text(AppStrings.ntCategoryMedical), findsOneWidget);
      expect(find.text(AppStrings.ntCategoryAppointment), findsOneWidget);
      expect(find.text(AppStrings.ntCategorySystem), findsOneWidget);
      bloc.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('shows empty state when deleted all', (tester) async {
      final bloc = createBloc();
      await tester.pumpWidget(buildTestWidget(bloc));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();

      bloc.add(const NotificationDelete('1'));
      await tester.pump();
      bloc.add(const NotificationDelete('2'));
      await tester.pump();
      bloc.add(const NotificationDelete('3'));
      await tester.pump();
      bloc.add(const NotificationDelete('4'));
      await tester.pump();
      bloc.add(const NotificationDelete('5'));
      await tester.pump();
      bloc.add(const NotificationDelete('6'));
      await tester.pump();
      bloc.add(const NotificationDelete('7'));
      await tester.pump();
      bloc.add(const NotificationDelete('8'));
      await tester.pump();
      await tester.pump();

      expect(find.text(AppStrings.ntEmptyTitle), findsOneWidget);
      bloc.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
