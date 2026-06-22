import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository repository;
  int _page = 1;
  bool _hasMore = true;

  DoctorBloc(this.repository) : super(DoctorInitial()) {
    on<DoctorLoadAll>(_onLoadAll);
    on<DoctorLoadMore>(_onLoadMore);
    on<DoctorSearch>(_onSearch);
    on<DoctorAdd>(_onAdd);
    on<DoctorUpdate>(_onUpdate);
    on<DoctorDelete>(_onDelete);
    on<DoctorLoadPatientAppointments>(_onLoadPatientAppointments);
  }

  Future<void> _onLoadAll(DoctorLoadAll event, Emitter<DoctorState> emit) async {
    _page = 1;
    _hasMore = true;
    emit(DoctorLoading());
    try {
      final doctors = await repository.getAllDoctors(specializationId: event.specializationId, page: _page);
      _hasMore = doctors.length >= 20;
      emit(DoctorLoaded(doctors, hasMore: _hasMore));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onLoadMore(DoctorLoadMore event, Emitter<DoctorState> emit) async {
    if (state is! DoctorLoaded) return;
    final current = state as DoctorLoaded;
    if (!current.hasMore || current.isLoadingMore) return;
    emit(DoctorLoaded(current.doctors, isLoadingMore: true, hasMore: current.hasMore));
    try {
      _page++;
      final newDoctors = await repository.getAllDoctors(page: _page);
      final merged = [...current.doctors, ...newDoctors];
      _hasMore = newDoctors.length >= 20;
      emit(DoctorLoaded(merged, hasMore: _hasMore));
    } catch (e) {
      emit(DoctorLoaded(current.doctors, hasMore: current.hasMore));
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
      _page = 1;
      _hasMore = true;
      final doctors = await repository.getAllDoctors(page: _page);
      _hasMore = doctors.length >= 20;
      emit(DoctorLoaded(doctors, hasMore: _hasMore));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onUpdate(DoctorUpdate event, Emitter<DoctorState> emit) async {
    try {
      await repository.updateDoctor(event.doctor);
      _page = 1;
      _hasMore = true;
      final doctors = await repository.getAllDoctors(page: _page);
      _hasMore = doctors.length >= 20;
      emit(DoctorLoaded(doctors, hasMore: _hasMore));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onDelete(DoctorDelete event, Emitter<DoctorState> emit) async {
    try {
      await repository.deleteDoctor(event.id);
      _page = 1;
      _hasMore = true;
      final doctors = await repository.getAllDoctors(page: _page);
      _hasMore = doctors.length >= 20;
      emit(DoctorLoaded(doctors, hasMore: _hasMore));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onLoadPatientAppointments(DoctorLoadPatientAppointments event, Emitter<DoctorState> emit) async {
    _page = 1;
    _hasMore = true;
    emit(DoctorLoading());
    try {
      final doctors = await repository.getDoctorsWithAppointments(patientId: event.patientId);
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
