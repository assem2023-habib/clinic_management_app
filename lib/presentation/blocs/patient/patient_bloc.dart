import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository repository;

  PatientBloc(this.repository) : super(PatientInitial()) {
    on<PatientLoadAll>(_onLoadAll);
    on<PatientLoadMore>(_onLoadMore);
    on<PatientSearch>(_onSearch);
    on<PatientAdd>(_onAdd);
    on<PatientUpdate>(_onUpdate);
    on<PatientDelete>(_onDelete);
  }

  Future<void> _onLoadAll(PatientLoadAll event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final patients = await repository.getAllPatients(page: event.page, limit: event.limit);
      final hasMore = patients.length >= event.limit;
      emit(PatientLoaded(patients, hasMore: hasMore, page: event.page));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onLoadMore(PatientLoadMore event, Emitter<PatientState> emit) async {
    if (state is! PatientLoaded || (state as PatientLoaded).isLoadingMore) return;
    final current = state as PatientLoaded;
    emit(current.copyWith(isLoadingMore: true));
    try {
      final newPatients = await repository.getAllPatients(page: event.page, limit: event.limit);
      final all = [...current.patients, ...newPatients];
      final hasMore = newPatients.length >= event.limit;
      emit(PatientLoaded(all, hasMore: hasMore, page: event.page));
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSearch(PatientSearch event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final patients = await repository.getAllPatients(query: event.query, page: 1, limit: 50);
      emit(PatientLoaded(patients, hasMore: false, page: 1));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onAdd(PatientAdd event, Emitter<PatientState> emit) async {
    try {
      await repository.addPatient(event.patient);
      final patients = await repository.getAllPatients();
      emit(PatientLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onUpdate(PatientUpdate event, Emitter<PatientState> emit) async {
    try {
      await repository.updatePatient(event.patient);
      final patients = await repository.getAllPatients();
      emit(PatientLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onDelete(PatientDelete event, Emitter<PatientState> emit) async {
    try {
      await repository.deletePatient(event.id);
      final patients = await repository.getAllPatients();
      emit(PatientLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }
}
