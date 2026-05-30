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
      final slots = await doctorRepository.getDoctorSlots(
        event.doctorId,
        DateTime(now.year, now.month),
      );
      final timeSlots = slots.map((s) => TimeSlotEntity(
        id: s.id,
        date: now,
        time: '${s.startTime} - ${s.endTime}',
        isAvailable: s.isActive,
      )).toList();
      final dates = _generateAvailableDates();
      emit(UserBookingLoaded(
        doctor: doer,
        allSlots: timeSlots,
        selectedDate: now,
        availableDates: dates,
      ));
    } catch (e) {
      emit(UserBookingError(e.toString()));
    }
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

  List<DateTime> _generateAvailableDates() {
    final now = DateTime.now();
    return List.generate(7, (i) => DateTime(now.year, now.month, now.day + i));
  }
}
