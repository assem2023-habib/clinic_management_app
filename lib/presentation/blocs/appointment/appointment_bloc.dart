import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;

  AppointmentBloc(this.repository) : super(AppointmentInitial()) {
    on<AppointmentLoadAll>(_onLoadAll);
    on<AppointmentLoadByDate>(_onLoadByDate);
    on<AppointmentAdd>(_onAdd);
    on<AppointmentUpdate>(_onUpdate);
    on<AppointmentDelete>(_onDelete);
    on<AppointmentUpdateStatus>(_onUpdateStatus);
  }

  Future<void> _onLoadAll(AppointmentLoadAll event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onLoadByDate(AppointmentLoadByDate event, Emitter<AppointmentState> emit) async {
    try {
      final appointments = await repository.getAppointmentsByDate(event.date);
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onAdd(AppointmentAdd event, Emitter<AppointmentState> emit) async {
    try {
      await repository.addAppointment(event.appointment);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onUpdate(AppointmentUpdate event, Emitter<AppointmentState> emit) async {
    try {
      await repository.updateAppointment(event.appointment);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onDelete(AppointmentDelete event, Emitter<AppointmentState> emit) async {
    try {
      await repository.deleteAppointment(event.id);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onUpdateStatus(AppointmentUpdateStatus event, Emitter<AppointmentState> emit) async {
    try {
      final appointment = await repository.getAppointmentById(event.id);
      if (appointment != null) {
        final updated = appointment.copyWith(status: event.status);
        await repository.updateAppointment(updated);
        final appointments = await repository.getAllAppointments();
        emit(AppointmentLoaded(appointments));
      }
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
