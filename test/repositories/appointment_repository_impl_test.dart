import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/repositories/appointment_repository_impl.dart';
import 'package:clinic_management_app/core/services/appointment_rtdb_service.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class MockDataSource extends Mock implements DataSource {}

class MockRtdbService extends Mock implements AppointmentRtdbService {}

void main() {
  late MockDataSource dataSource;
  late MockRtdbService rtdbService;
  late AppointmentRepositoryImpl repository;

  setUp(() {
    dataSource = MockDataSource();
    rtdbService = MockRtdbService();
    repository = AppointmentRepositoryImpl(dataSource, rtdbService: rtdbService);
  });

  group('watchRtdbAppointmentsByDate', () {
    test('delegates to RTDB service for given doctor and date', () async {
      final date = '2026-06-15';
      final rtdbModels = [
        AppointmentModel(id: 'apt-1', status: AppointmentStatus.accepted,
          appointmentDate: date, startTime: '10:00', endTime: '11:00'),
      ];
      final rtdbStream = Stream<List<AppointmentModel>>.value(rtdbModels);

      when(() => rtdbService.watchBookedAppointmentsByDate('doc-1', date))
          .thenAnswer((_) => rtdbStream);

      final results = <List<AppointmentEntity>>[];
      final sub = repository.watchRtdbAppointmentsByDate('doc-1', date).listen((list) {
        results.add(list);
      });

      await Future(() {});
      await sub.cancel();

      expect(results.length, 1);
      expect(results[0].length, 1);
      expect(results[0][0].id, 'apt-1');
      expect(results[0][0].appointmentDate, date);
    });

    test('emits empty stream when RTDB service returns empty', () async {
      when(() => rtdbService.watchBookedAppointmentsByDate('doc-1', '2026-06-15'))
          .thenAnswer((_) => const Stream.empty());

      final results = <List<AppointmentEntity>>[];
      final sub = repository.watchRtdbAppointmentsByDate('doc-1', '2026-06-15').listen(
        (list) => results.add(list),
      );

      await Future(() {});
      await sub.cancel();

      expect(results, isEmpty);
    });

    test('returns empty stream when RTDB service is null', () async {
      final repo = AppointmentRepositoryImpl(dataSource);
      final results = <List<AppointmentEntity>>[];
      final sub = repo.watchRtdbAppointmentsByDate('doc-1', '2026-06-15').listen(
        (list) => results.add(list),
      );

      await Future(() {});
      await sub.cancel();

      expect(results, isEmpty);
    });
  });

  group('watchRtdbAppointments', () {
    test('delegates to RTDB service for all appointments', () async {
      final rtdbModels = [
        AppointmentModel(id: 'apt-1', status: AppointmentStatus.accepted),
      ];
      final rtdbStream = Stream<List<AppointmentModel>>.value(rtdbModels);

      when(() => rtdbService.watchBookedAppointments('doc-1'))
          .thenAnswer((_) => rtdbStream);

      final results = <List<AppointmentEntity>>[];
      final sub = repository.watchRtdbAppointments('doc-1').listen((list) {
        results.add(list);
      });

      await Future(() {});
      await sub.cancel();

      expect(results.length, 1);
      expect(results[0].length, 1);
      expect(results[0][0].id, 'apt-1');
    });

    test('falls back to local data source when RTDB service is null', () async {
      final repo = AppointmentRepositoryImpl(dataSource);
      final localAppts = <AppointmentModel>[
        AppointmentModel(id: 'local-1', status: AppointmentStatus.set, doctorId: 'doc-1'),
      ];

      when(() => dataSource.allAppointments).thenReturn(localAppts);

      final results = <List<AppointmentEntity>>[];
      final sub = repo.watchRtdbAppointments('doc-1').listen((list) {
        results.add(list);
      });

      await Future(() {});
      await sub.cancel();

      expect(results.length, 1);
      expect(results[0].length, 1);
      expect(results[0][0].id, 'local-1');
    });
  });
}
