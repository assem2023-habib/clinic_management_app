import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  final MedicalRecordRepository repository;

  MedicalRecordBloc(this.repository) : super(MedicalRecordInitial()) {
    on<MedicalRecordLoadAll>(_onLoadAll);
  }

  Future<void> _onLoadAll(MedicalRecordLoadAll event, Emitter<MedicalRecordState> emit) async {
    emit(MedicalRecordLoading());
    try {
      final records = await repository.getAllRecords();
      emit(MedicalRecordLoaded(records));
    } catch (e) {
      emit(MedicalRecordError(e.toString()));
    }
  }
}

abstract class MedicalRecordEvent {
  const MedicalRecordEvent();
}

class MedicalRecordLoadAll extends MedicalRecordEvent {
  const MedicalRecordLoadAll();
}

abstract class MedicalRecordState {
  const MedicalRecordState();
}

class MedicalRecordInitial extends MedicalRecordState {
  const MedicalRecordInitial();
}

class MedicalRecordLoading extends MedicalRecordState {
  const MedicalRecordLoading();
}

class MedicalRecordLoaded extends MedicalRecordState {
  final List<MedicalRecordEntity> records;
  const MedicalRecordLoaded(this.records);
}

class MedicalRecordError extends MedicalRecordState {
  final String message;
  const MedicalRecordError(this.message);
}
