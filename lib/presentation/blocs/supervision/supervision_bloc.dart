import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/supervision_entity.dart';
import 'package:clinic_management_app/domain/entities/supervision_request_entity.dart';
import 'package:clinic_management_app/domain/repositories/supervision_repository.dart';

abstract class SupervisionEvent {}

class LoadDoctorPatients extends SupervisionEvent {
  final String doctorId;
  LoadDoctorPatients(this.doctorId);
}

class LoadPatientDoctors extends SupervisionEvent {
  final String patientId;
  LoadPatientDoctors(this.patientId);
}

class AssignPatientToDoctor extends SupervisionEvent {
  final String doctorId;
  final String patientId;
  final String? notes;
  AssignPatientToDoctor(this.doctorId, this.patientId, {this.notes});
}

class SelfAssignPatient extends SupervisionEvent {
  final String doctorId;
  final String patientId;
  final String? notes;
  SelfAssignPatient(this.doctorId, this.patientId, {this.notes});
}

class BulkAssignPatients extends SupervisionEvent {
  final String doctorId;
  final List<String> patientIds;
  BulkAssignPatients(this.doctorId, this.patientIds);
}

class RemovePatientFromDoctor extends SupervisionEvent {
  final String doctorId;
  final String patientId;
  RemovePatientFromDoctor(this.doctorId, this.patientId);
}

class PatientRemoveDoctor extends SupervisionEvent {
  final String patientId;
  final String doctorId;
  PatientRemoveDoctor(this.patientId, this.doctorId);
}

class CreateSupervisionRequestEvent extends SupervisionEvent {
  final String patientId;
  final String doctorId;
  CreateSupervisionRequestEvent(this.patientId, this.doctorId);
}

class LoadPatientRequests extends SupervisionEvent {
  final String patientId;
  LoadPatientRequests(this.patientId);
}

class LoadDoctorRequests extends SupervisionEvent {
  final String doctorId;
  final String? status;
  LoadDoctorRequests(this.doctorId, {this.status});
}

class ApproveRequest extends SupervisionEvent {
  final String requestId;
  ApproveRequest(this.requestId);
}

class RejectRequest extends SupervisionEvent {
  final String requestId;
  RejectRequest(this.requestId);
}

class CancelRequest extends SupervisionEvent {
  final String requestId;
  CancelRequest(this.requestId);
}

abstract class SupervisionState {}

class SupervisionInitial extends SupervisionState {}

class SupervisionLoading extends SupervisionState {}

class DoctorPatientsLoaded extends SupervisionState {
  final List<SupervisionEntity> patients;
  DoctorPatientsLoaded(this.patients);
}

class PatientDoctorsLoaded extends SupervisionState {
  final List<SupervisionEntity> doctors;
  PatientDoctorsLoaded(this.doctors);
}

class PatientRequestsLoaded extends SupervisionState {
  final List<SupervisionRequestEntity> requests;
  PatientRequestsLoaded(this.requests);
}

class DoctorRequestsLoaded extends SupervisionState {
  final List<SupervisionRequestEntity> requests;
  DoctorRequestsLoaded(this.requests);
}

class SupervisionOperationSuccess extends SupervisionState {
  final String message;
  SupervisionOperationSuccess(this.message);
}

class SupervisionError extends SupervisionState {
  final String message;
  SupervisionError(this.message);
}

class SupervisionBloc extends Bloc<SupervisionEvent, SupervisionState> {
  final SupervisionRepository repository;

  SupervisionBloc(this.repository) : super(SupervisionInitial()) {
    on<LoadDoctorPatients>(_onLoadDoctorPatients);
    on<LoadPatientDoctors>(_onLoadPatientDoctors);
    on<AssignPatientToDoctor>(_onAssignPatientToDoctor);
    on<SelfAssignPatient>(_onSelfAssignPatient);
    on<BulkAssignPatients>(_onBulkAssignPatients);
    on<RemovePatientFromDoctor>(_onRemovePatientFromDoctor);
    on<PatientRemoveDoctor>(_onPatientRemoveDoctor);
    on<CreateSupervisionRequestEvent>(_onCreateRequest);
    on<LoadPatientRequests>(_onLoadPatientRequests);
    on<LoadDoctorRequests>(_onLoadDoctorRequests);
    on<ApproveRequest>(_onApproveRequest);
    on<RejectRequest>(_onRejectRequest);
    on<CancelRequest>(_onCancelRequest);
  }

  Future<void> _onLoadDoctorPatients(LoadDoctorPatients event, Emitter<SupervisionState> emit) async {
    emit(SupervisionLoading());
    try {
      final patients = await repository.getDoctorPatients(event.doctorId);
      emit(DoctorPatientsLoaded(patients));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onLoadPatientDoctors(LoadPatientDoctors event, Emitter<SupervisionState> emit) async {
    emit(SupervisionLoading());
    try {
      final doctors = await repository.getPatientDoctors(event.patientId);
      emit(PatientDoctorsLoaded(doctors));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onAssignPatientToDoctor(AssignPatientToDoctor event, Emitter<SupervisionState> emit) async {
    try {
      await repository.assignPatientToDoctor(event.doctorId, event.patientId, notes: event.notes);
      emit(SupervisionOperationSuccess('Patient assigned'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onSelfAssignPatient(SelfAssignPatient event, Emitter<SupervisionState> emit) async {
    try {
      await repository.selfAssignPatient(event.doctorId, event.patientId, notes: event.notes);
      emit(SupervisionOperationSuccess('Patient assigned'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onBulkAssignPatients(BulkAssignPatients event, Emitter<SupervisionState> emit) async {
    try {
      await repository.bulkAssignPatients(event.doctorId, event.patientIds);
      emit(SupervisionOperationSuccess('Patients assigned'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onRemovePatientFromDoctor(RemovePatientFromDoctor event, Emitter<SupervisionState> emit) async {
    try {
      await repository.removePatientFromDoctor(event.doctorId, event.patientId);
      emit(SupervisionOperationSuccess('Patient removed'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onPatientRemoveDoctor(PatientRemoveDoctor event, Emitter<SupervisionState> emit) async {
    try {
      await repository.patientRemoveDoctor(event.patientId, event.doctorId);
      emit(SupervisionOperationSuccess('Doctor removed'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onCreateRequest(CreateSupervisionRequestEvent event, Emitter<SupervisionState> emit) async {
    emit(SupervisionLoading());
    try {
      await repository.createSupervisionRequest(event.patientId, event.doctorId);
      emit(SupervisionOperationSuccess('Request sent'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onLoadPatientRequests(LoadPatientRequests event, Emitter<SupervisionState> emit) async {
    emit(SupervisionLoading());
    try {
      final requests = await repository.getPatientRequests(event.patientId);
      emit(PatientRequestsLoaded(requests));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onLoadDoctorRequests(LoadDoctorRequests event, Emitter<SupervisionState> emit) async {
    emit(SupervisionLoading());
    try {
      final requests = await repository.getDoctorRequests(event.doctorId, status: event.status);
      emit(DoctorRequestsLoaded(requests));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onApproveRequest(ApproveRequest event, Emitter<SupervisionState> emit) async {
    try {
      await repository.approveRequest(event.requestId);
      emit(SupervisionOperationSuccess('Request approved'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onRejectRequest(RejectRequest event, Emitter<SupervisionState> emit) async {
    try {
      await repository.rejectRequest(event.requestId);
      emit(SupervisionOperationSuccess('Request rejected'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }

  Future<void> _onCancelRequest(CancelRequest event, Emitter<SupervisionState> emit) async {
    try {
      await repository.cancelRequest(event.requestId);
      emit(SupervisionOperationSuccess('Request cancelled'));
    } catch (e) {
      emit(SupervisionError(e.toString()));
    }
  }
}
