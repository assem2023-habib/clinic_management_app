import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/supervision_model.dart';
import 'package:clinic_management_app/data/models/supervision_request_model.dart';

class SupervisionRemoteDataSource {
  final ApiService _api;

  SupervisionRemoteDataSource(this._api);

  Future<List<SupervisionModel>> getDoctorPatients(String doctorId) async {
    final response = await _api.get('/doctors/$doctorId/patients');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => SupervisionModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<SupervisionModel>> getPatientDoctors(String patientId) async {
    final response = await _api.get('/patients/$patientId/doctors');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => SupervisionModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Map<String, dynamic>>> getAvailableDoctors(String patientId, {String? specializationId}) async {
    final queryParams = <String, dynamic>{'specialization_id': ?specializationId};
    final response = await _api.get('/patients/$patientId/available-doctors', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> assignPatientToDoctor(String doctorId, String patientId, {String? notes}) async {
    await _api.post('/doctors/$doctorId/patients', data: {'patient_id': patientId, 'notes': ?notes});
  }

  Future<void> selfAssignPatient(String doctorId, String patientId, {String? notes}) async {
    await _api.post('/doctors/$doctorId/patients/self', data: {'patient_id': patientId, 'notes': ?notes});
  }

  Future<void> bulkAssignPatients(String doctorId, List<String> patientIds) async {
    await _api.post('/doctors/$doctorId/patients/bulk', data: {'patient_ids': patientIds});
  }

  Future<void> removePatientFromDoctor(String doctorId, String patientId) async {
    await _api.delete('/doctors/$doctorId/patients/$patientId');
  }

  Future<void> patientRemoveDoctor(String patientId, String doctorId) async {
    await _api.delete('/patients/$patientId/doctors/$doctorId');
  }

  Future<SupervisionRequestModel> createSupervisionRequest(String patientId, String doctorId) async {
    final response = await _api.post('/patients/$patientId/supervision-requests', data: {'doctor_id': doctorId});
    final data = response.data['data'] as Map<String, dynamic>;
    return SupervisionRequestModel.fromMap(data);
  }

  Future<List<SupervisionRequestModel>> getPatientRequests(String patientId) async {
    final response = await _api.get('/patients/$patientId/supervision-requests');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => SupervisionRequestModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<SupervisionRequestModel>> getDoctorRequests(String doctorId, {String? status}) async {
    final queryParams = <String, dynamic>{'status': ?status};
    final response = await _api.get('/doctors/$doctorId/supervision-requests', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => SupervisionRequestModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> approveRequest(String requestId) async {
    await _api.post('/supervision-requests/$requestId/approve');
  }

  Future<void> rejectRequest(String requestId) async {
    await _api.post('/supervision-requests/$requestId/reject');
  }

  Future<void> cancelRequest(String requestId) async {
    await _api.post('/supervision-requests/$requestId/cancel');
  }
}
