import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_event.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_state.dart';

class UserBookingBloc extends Bloc<UserBookingEvent, UserBookingState> {
  final DoctorRepository doctorRepository;
  final AppointmentRepository appointmentRepository;
  StreamSubscription? _rtdbSubscription;

  UserBookingBloc({
    required this.doctorRepository,
    required this.appointmentRepository,
  }) : super(UserBookingInitial()) {
    on<UserBookingLoad>(_onLoad);
    on<UserBookingSelectDate>(_onSelectDate);
    on<UserBookingSelectSlot>(_onSelectSlot);
    on<UserBookingConfirm>(_onConfirm);
  }

  Future<void> _onLoad(UserBookingLoad event, Emitter<UserBookingState> emit) async {
    emit(UserBookingLoading());
    try {
      final doer = await doctorRepository.getDoctorById(event.doctorId);
      if (doer == null) {
        emit(const UserBookingError(AppStrings.bookingDoctorNotFound));
        return;
      }
      final now = DateTime.now();
      final dates = List.generate(7, (i) => DateTime(now.year, now.month, now.day + i));
      final allSlots = _generateSlots(dates);

      emit(UserBookingLoaded(
        doctor: doer,
        allSlots: allSlots,
        selectedDate: now,
        availableDates: dates,
      ));

      _rtdbSubscription?.cancel();
      _rtdbSubscription = appointmentRepository.watchRtdbAppointments(event.doctorId).listen(
        (bookedAppts) {
          if (isClosed) return;
          final current = state;
          if (current is UserBookingLoaded) {
            final updated = _mergeBooked(current.allSlots, bookedAppts);
            emit(current.copyWith(allSlots: updated));
          }
        },
        onError: (_) {},
      );
    } catch (e) {
      emit(UserBookingError(e.toString()));
    }
  }

  List<TimeSlotEntity> _generateSlots(List<DateTime> dates) {
    final slots = <TimeSlotEntity>[];
    for (final date in dates) {
      for (int h = 8; h < 17; h++) {
        for (int m = 0; m < 60; m += 30) {
          final start = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
          final nextM = m + 30;
          final endH = nextM == 60 ? h + 1 : h;
          final endM = nextM == 60 ? 0 : nextM;
          final end = '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}';
          slots.add(TimeSlotEntity(
            id: '${date.toIso8601String().substring(0, 10)}_$start',
            date: date,
            time: '$start - $end',
            isAvailable: true,
          ));
        }
      }
    }
    return slots;
  }

  List<TimeSlotEntity> _mergeBooked(List<TimeSlotEntity> slots, List<AppointmentEntity> booked) {
    final ranges = <_TimeRange>[];
    for (final a in booked) {
      if (a.appointmentDate == null || a.startTime == null || a.endTime == null) continue;
      final d = DateTime.tryParse(a.appointmentDate!);
      if (d == null) continue;
      ranges.add(_TimeRange(
        date: DateTime(d.year, d.month, d.day),
        start: _toMin(a.startTime!),
        end: _toMin(a.endTime!),
      ));
    }
    if (ranges.isEmpty) return slots;

    return slots.map((s) {
      final parts = s.time.split(' - ');
      if (parts.length != 2) return s;
      final sStart = _toMin(parts[0]);
      final sEnd = _toMin(parts[1]);
      final isBooked = ranges.any((r) =>
        r.date == s.date &&
        sStart < r.end &&
        sEnd > r.start
      );
      return isBooked ? s.copyWith(isAvailable: false) : s;
    }).toList();
  }

  int _toMin(String t) {
    final p = t.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  Future<void> _onSelectDate(UserBookingSelectDate event, Emitter<UserBookingState> emit) async {
    final current = state;
    if (current is! UserBookingLoaded) return;
    emit(current.copyWith(selectedDate: event.date, selectedSlotId: null));
  }

  void _onSelectSlot(UserBookingSelectSlot event, Emitter<UserBookingState> emit) {
    final current = state;
    if (current is! UserBookingLoaded) return;
    emit(current.copyWith(selectedSlotId: event.slotId));
  }

  Future<void> _onConfirm(UserBookingConfirm event, Emitter<UserBookingState> emit) async {
    emit(UserBookingBooking());
    try {
      final id = const Uuid().v4();
      await appointmentRepository.addAppointment(AppointmentEntity(
        id: id,
        patientId: event.patientId,
        patientName: '',
        doctorId: event.doctorId,
        doctorName: '',
        date: event.date.toIso8601String(),
        timeSlot: event.timeSlot,
        status: AppointmentStatus.scheduled,
        notes: event.notes,
      ));
      emit(UserBookingConfirmed(
        appointmentId: id,
        doctor: event.doctorEntity,
        patientName: event.patientName,
        date: event.date,
        timeSlot: event.timeSlot,
      ));
    } catch (e) {
      emit(UserBookingError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _rtdbSubscription?.cancel();
    return super.close();
  }
}

class _TimeRange {
  final DateTime date;
  final int start;
  final int end;
  const _TimeRange({required this.date, required this.start, required this.end});
}
