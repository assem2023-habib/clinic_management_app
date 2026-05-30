import 'package:clinic_management_app/domain/entities/supervision_entity.dart';
import 'package:clinic_management_app/domain/entities/supervision_request_entity.dart';

abstract class SupervisionRepository {
  Future<List<SupervisionEntity>> getDoctorPatients(String doctorId);
  Future<List<SupervisionEntity>> getPatientDoctors(String patientId);
  Future<void> assignPatientToDoctor(String doctorId, String patientId, {String? notes});
  Future<void> selfAssignPatient(String doctorId, String patientId, {String? notes});
  Future<void> bulkAssignPatients(String doctorId, List<String> patientIds);
  Future<void> removePatientFromDoctor(String doctorId, String patientId);
  Future<void> patientRemoveDoctor(String patientId, String doctorId);

  Future<SupervisionRequestEntity> createSupervisionRequest(String patientId, String doctorId);
  Future<List<SupervisionRequestEntity>> getPatientRequests(String patientId);
  Future<List<SupervisionRequestEntity>> getDoctorRequests(String doctorId, {String? status});
  Future<void> approveRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<void> cancelRequest(String requestId);
}
