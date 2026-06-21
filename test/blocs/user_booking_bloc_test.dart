import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_event.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_state.dart';

class MockDoctorRepository extends Mock implements DoctorRepository {}

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

DoctorEntity _createDoctor({String id = 'doc-1'}) {
  return DoctorEntity(
    id: id,
    firstName: 'خالد',
    lastName: 'سليمان',
    username: 'drkhaled',
    email: 'khaled@test.com',
    gender: 'male',
  );
}

AppointmentEntity _bookedAppt({
  String date = '2026-06-15',
  String start = '10:00',
  String end = '11:00',
  String status = 'accepted',
}) {
  return AppointmentEntity(
    id: 'apt-1',
    status: AppointmentStatus.fromString(status),
    appointmentDate: date,
    startTime: start,
    endTime: end,
  );
}

TimeSlotEntity _slot(DateTime date, String time) {
  return TimeSlotEntity(
    id: '${date.toIso8601String().substring(0, 10)}_${time.split(' - ')[0]}',
    date: date,
    time: time,
  );
}

void main() {
  late MockDoctorRepository doctorRepository;
  late MockAppointmentRepository appointmentRepository;
  late UserBookingBloc bloc;

  setUp(() {
    doctorRepository = MockDoctorRepository();
    appointmentRepository = MockAppointmentRepository();
    bloc = UserBookingBloc(
      doctorRepository: doctorRepository,
      appointmentRepository: appointmentRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with UserBookingInitial', () {
      expect(bloc.state, isA<UserBookingInitial>());
    });
  });

  group('UserBookingLoad', () {
    test('emits Loading then Loaded with doctor and 7 days of slots', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      final expected = [
        isA<UserBookingLoading>(),
        isA<UserBookingLoaded>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});
      final loaded = bloc.state as UserBookingLoaded;
      expect(loaded.doctor, doctor);
      expect(loaded.allSlots.length, 7 * 18, reason: '7 days × 18 half-hour slots (08:00-16:30)');
      expect(loaded.availableDates.length, 7);
    });

    test('emits error when doctor not found', () async {
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => null);

      final expected = [
        isA<UserBookingLoading>(),
        isA<UserBookingError>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const UserBookingLoad('doc-1'));
    });

    test('filters out appointments outside the 7-day window from RTDB stream', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);

      final oldAppt = _bookedAppt(date: '2025-01-01', start: '09:00', end: '10:00');
      final futureAppt = _bookedAppt(date: '2030-12-31', start: '14:00', end: '15:00');
      final bookedStream = Stream<List<AppointmentEntity>>.value([oldAppt, futureAppt]);

      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => bookedStream);

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      final loaded = bloc.state as UserBookingLoaded;
      final allAvailable = loaded.allSlots.every((s) => s.isAvailable);
      expect(allAvailable, isTrue,
          reason: 'Old and far-future appointments should be filtered out');
    });

    test('marks slots as unavailable when RTDB emits overlapping bookings', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);

      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final todayApt = _bookedAppt(date: todayStr, start: '09:00', end: '10:00');
      final controller = StreamController<List<AppointmentEntity>>();
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => controller.stream);

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      controller.add([todayApt]);
      await Future(() {});

      final loaded = bloc.state as UserBookingLoaded;
      final todaySlots = loaded.allSlots.where((s) =>
        s.date.year == now.year && s.date.month == now.month && s.date.day == now.day).toList();

      final slot09 = todaySlots.firstWhere((s) => s.time.startsWith('09:00'));
      final slot0930 = todaySlots.firstWhere((s) => s.time.startsWith('09:30'));
      final slot0830 = todaySlots.firstWhere((s) => s.time.startsWith('08:30'));
      final slot1000 = todaySlots.firstWhere((s) => s.time.startsWith('10:00'));

      expect(slot0830.isAvailable, isTrue, reason: '08:30-09:00 before booking');
      expect(slot09.isAvailable, isFalse, reason: '09:00-09:30 overlaps with 09:00-10:00');
      expect(slot0930.isAvailable, isFalse, reason: '09:30-10:00 overlaps with 09:00-10:00');
      expect(slot1000.isAvailable, isTrue, reason: '10:00-10:30 after booking');

      await controller.close();
    });

    test('does not mark slots on other dates when booking is on a different date', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);

      final controller = StreamController<List<AppointmentEntity>>();
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => controller.stream);

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      final anotherDateAppt = _bookedAppt(date: '2026-12-25', start: '09:00', end: '10:00');
      controller.add([anotherDateAppt]);
      await Future(() {});

      final loaded = bloc.state as UserBookingLoaded;
      expect(loaded.allSlots.every((s) => s.isAvailable), isTrue,
          reason: 'Booking on Dec 25 should not affect slots on other dates');

      await controller.close();
    });
  });

  group('UserBookingSelectDate', () {
    test('updates selectedDate and clears selectedSlotId', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      final newDate = DateTime(2026, 6, 20);
      bloc.add(UserBookingSelectDate(newDate));
      await Future(() {});

      final loaded = bloc.state as UserBookingLoaded;
      expect(loaded.selectedDate, newDate);
      expect(loaded.selectedSlotId, isNull);
    });
  });

  group('UserBookingSelectSlot', () {
    test('updates selectedSlotId', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      bloc.add(const UserBookingSelectSlot('2026-06-15_10:00'));
      await Future(() {});

      final loaded = bloc.state as UserBookingLoaded;
      expect(loaded.selectedSlotId, '2026-06-15_10:00');
    });
  });

  group('UserBookingConfirm', () {
    test('emits Booking then Confirmed on success', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());
      when(() => appointmentRepository.requestAppointment(
        any(),
        preferredDate: any(named: 'preferredDate'),
        reason: any(named: 'reason'),
      )).thenAnswer((_) async =>
        AppointmentEntity(id: 'new-apt', status: AppointmentStatus.requested));

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      final expected = [
        isA<UserBookingBooking>(),
        isA<UserBookingConfirmed>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(UserBookingConfirm(
        patientId: 'pat-1',
        patientName: 'أحمد',
        doctorId: 'doc-1',
        doctorEntity: doctor,
        date: DateTime(2026, 6, 15),
        timeSlot: '10:00 - 11:00',
      ));
      await Future(() {});

      final confirmed = bloc.state as UserBookingConfirmed;
      expect(confirmed.appointmentId, 'new-apt');
      expect(confirmed.doctor, doctor);
    });

    test('emits error when requestAppointment fails', () async {
      final doctor = _createDoctor();
      when(() => doctorRepository.getDoctorById('doc-1'))
          .thenAnswer((_) async => doctor);
      when(() => appointmentRepository.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());
      when(() => appointmentRepository.requestAppointment(
        any(),
        preferredDate: any(named: 'preferredDate'),
        reason: any(named: 'reason'),
      )).thenThrow(Exception('Slot already taken'));

      bloc.add(const UserBookingLoad('doc-1'));
      await Future(() {});

      bloc.add(UserBookingConfirm(
        patientId: 'pat-1',
        patientName: 'أحمد',
        doctorId: 'doc-1',
        doctorEntity: doctor,
        date: DateTime(2026, 6, 15),
        timeSlot: '10:00 - 11:00',
      ));
      await Future(() {});

      expect(bloc.state, isA<UserBookingError>());
      expect((bloc.state as UserBookingError).message, contains('Slot already taken'));
    });
  });
}
