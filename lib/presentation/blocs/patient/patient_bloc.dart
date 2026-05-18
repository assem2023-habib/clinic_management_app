import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/data/repositories/patient_repository.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository repository;

  PatientBloc(this.repository) : super(PatientInitial()) {
    on<PatientLoadAll>(_onLoadAll);
    on<PatientSearch>(_onSearch);
    on<PatientAdd>(_onAdd);
    on<PatientUpdate>(_onUpdate);
    on<PatientDelete>(_onDelete);
  }

  Future<void> _onLoadAll(PatientLoadAll event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final patients = await repository.getAllPatients();
      emit(PatientLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onSearch(PatientSearch event, Emitter<PatientState> emit) async {
    try {
      final patients = await repository.searchPatients(event.query);
      emit(PatientLoaded(patients));
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
