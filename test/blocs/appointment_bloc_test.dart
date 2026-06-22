import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

void main() {
  late AppointmentBloc bloc;
  late MockAppointmentRepository mockRepo;

  setUp(() {
    mockRepo = MockAppointmentRepository();
    bloc = AppointmentBloc(mockRepo);
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with AppointmentInitial', () {
      expect(bloc.state, isA<AppointmentInitial>());
    });
  });

  group('AppointmentLoadAll', () {
    test('emits Loading then Loaded with appointments', () async {
      final appointments = [
        const AppointmentEntity(id: '1', status: AppointmentStatus.pending),
      ];
      when(() => mockRepo.getAllAppointments(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => appointments);

      final expected = [isA<AppointmentLoading>(), isA<AppointmentLoaded>()];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const AppointmentLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as AppointmentLoaded;
      expect(state.appointments.length, 1);
      expect(state.hasMore, false);
    });

    test('emits AppointmentError on failure', () async {
      when(() => mockRepo.getAllAppointments(page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(Exception('fail'));
      bloc.add(const AppointmentLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state, isA<AppointmentError>());
    });
  });

  group('AppointmentLoadMore', () {
    test('appends more appointments', () async {
      final page1 = List.generate(10, (i) => AppointmentEntity(
        id: 'a$i', status: AppointmentStatus.pending,
      ));
      final page2 = List.generate(3, (i) => AppointmentEntity(
        id: 'a${i + 10}', status: AppointmentStatus.pending,
      ));

      when(() => mockRepo.getAllAppointments(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((invocation) async {
        final page = invocation.namedArguments[#page] as int;
        return page == 1 ? page1 : page2;
      });

      bloc.add(const AppointmentLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as AppointmentLoaded).appointments.length, 10);
      expect((bloc.state as AppointmentLoaded).hasMore, true);

      bloc.add(const AppointmentLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as AppointmentLoaded;
      expect(state.appointments.length, 13);
      expect(state.hasMore, false);
    });

    test('does nothing when state is not AppointmentLoaded', () {
      bloc.add(AppointmentLoadMore());
      expect(bloc.state, isA<AppointmentInitial>());
    });

    test('sets isLoadingMore immediately after LoadMore event', () async {
      final many = List.generate(10, (i) => AppointmentEntity(
        id: 'a$i', status: AppointmentStatus.pending,
      ));
      when(() => mockRepo.getAllAppointments(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => many);
      bloc.add(const AppointmentLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllAppointments(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });
      bloc.add(AppointmentLoadMore());
      await Future.delayed(const Duration(milliseconds: 10));
      expect((bloc.state as AppointmentLoaded).isLoadingMore, true);
    });

    test('maintains existing appointments on error', () async {
      when(() => mockRepo.getAllAppointments(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => [
        const AppointmentEntity(id: '1', status: AppointmentStatus.pending),
      ]);
      bloc.add(const AppointmentLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllAppointments(page: 2, limit: 10)).thenThrow(Exception('fail'));
      bloc.add(const AppointmentLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as AppointmentLoaded;
      expect(state.appointments.length, 1);
      expect(state.isLoadingMore, false);
    });
  });

  group('AppointmentLoadByDate', () {
    test('loads appointments by date', () async {
      final appointments = [
        const AppointmentEntity(id: '1', status: AppointmentStatus.scheduled),
      ];
      when(() => mockRepo.getAppointmentsByDate(any())).thenAnswer((_) async => appointments);

      bloc.add(AppointmentLoadByDate(DateTime(2026, 6, 22)));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as AppointmentLoaded;
      expect(state.appointments.length, 1);
    });
  });
}
