import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository repository;

  DoctorBloc(this.repository) : super(DoctorInitial()) {
    on<DoctorLoadAll>(_onLoadAll);
    on<DoctorSearch>(_onSearch);
    on<DoctorAdd>(_onAdd);
    on<DoctorUpdate>(_onUpdate);
    on<DoctorDelete>(_onDelete);
    on<DoctorLoadPatientAppointments>(_onLoadPatientAppointments);
  }

  Future<void> _onLoadAll(DoctorLoadAll event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final doctors = await repository.getAllDoctors(specializationId: event.specializationId);
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onSearch(DoctorSearch event, Emitter<DoctorState> emit) async {
    try {
      final doctors = await repository.searchDoctors(event.query);
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onAdd(DoctorAdd event, Emitter<DoctorState> emit) async {
    try {
      await repository.addDoctor(event.doctor);
      final doctors = await repository.getAllDoctors();
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onUpdate(DoctorUpdate event, Emitter<DoctorState> emit) async {
    try {
      await repository.updateDoctor(event.doctor);
      final doctors = await repository.getAllDoctors();
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onDelete(DoctorDelete event, Emitter<DoctorState> emit) async {
    try {
      await repository.deleteDoctor(event.id);
      final doctors = await repository.getAllDoctors();
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onLoadPatientAppointments(DoctorLoadPatientAppointments event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final doctors = await repository.getDoctorsWithAppointments(patientId: event.patientId);
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
