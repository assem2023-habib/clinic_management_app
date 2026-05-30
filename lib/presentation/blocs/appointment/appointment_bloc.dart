import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;
  StreamSubscription? _rtdbSubscription;

  AppointmentBloc(this.repository) : super(AppointmentInitial()) {
    on<AppointmentLoadAll>(_onLoadAll);
    on<AppointmentLoadByDate>(_onLoadByDate);
    on<AppointmentAdd>(_onAdd);
    on<AppointmentUpdate>(_onUpdate);
    on<AppointmentDelete>(_onDelete);
    on<AppointmentUpdateStatus>(_onUpdateStatus);
    on<AppointmentRequest>(_onRequest);
    on<AppointmentSetTime>(_onSetTime);
    on<AppointmentRespond>(_onRespond);
    on<AppointmentStart>(_onStart);
    on<AppointmentCancel>(_onCancel);
    on<AppointmentComplete>(_onComplete);
    on<AppointmentSuggestAlternative>(_onSuggestAlternative);
    on<AppointmentLoadBookedSlots>(_onLoadBookedSlots);
    on<AppointmentWatchRtdb>(_onWatchRtdb);
    on<AppointmentStopRtdb>(_onStopRtdb);
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
      await repository.updateAppointmentStatus(event.id, event.status);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onRequest(AppointmentRequest event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment = await repository.requestAppointment(
        event.doctorId,
        preferredDate: event.preferredDate,
        reason: event.reason,
      );
      emit(AppointmentWorkflowSuccess(appointment, message: 'Appointment requested'));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onSetTime(AppointmentSetTime event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment = await repository.setAppointmentTime(
        event.appointmentId, event.date, event.startTime, event.endTime,
      );
      emit(AppointmentWorkflowSuccess(appointment, message: 'Time set successfully'));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onRespond(AppointmentRespond event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment = await repository.respondToAppointment(event.appointmentId, event.response);
      emit(AppointmentWorkflowSuccess(appointment, message: event.response == 'accepted' ? 'Appointment accepted' : 'Appointment rejected'));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onStart(AppointmentStart event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment = await repository.startAppointment(event.appointmentId);
      emit(AppointmentWorkflowSuccess(appointment, message: 'Appointment started'));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCancel(AppointmentCancel event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await repository.cancelAppointment(event.appointmentId);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onComplete(AppointmentComplete event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await repository.completeAppointment(event.appointmentId);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onSuggestAlternative(AppointmentSuggestAlternative event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await repository.suggestAlternative(event.appointmentId, event.message);
      final appointments = await repository.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onLoadBookedSlots(AppointmentLoadBookedSlots event, Emitter<AppointmentState> emit) async {
    emit(BookedSlotsLoading());
    try {
      final slots = await repository.getBookedSlots(
        event.doctorId,
        date: event.date,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(BookedSlotsLoaded(slots));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onWatchRtdb(AppointmentWatchRtdb event, Emitter<AppointmentState> emit) async {
    await _rtdbSubscription?.cancel();
    try {
      _rtdbSubscription = repository.watchRtdbAppointments(event.doctorId).listen((appointments) {
        if (!isClosed) {
          emit(AppointmentLoaded(appointments));
        }
      });
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  void _onStopRtdb(AppointmentStopRtdb event, Emitter<AppointmentState> emit) {
    _rtdbSubscription?.cancel();
    _rtdbSubscription = null;
  }

  @override
  Future<void> close() {
    _rtdbSubscription?.cancel();
    return super.close();
  }
}
