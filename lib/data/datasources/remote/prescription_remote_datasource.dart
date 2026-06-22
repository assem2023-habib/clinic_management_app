import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/medicine_model.dart';
import 'package:clinic_management_app/data/models/prescription_item_model.dart';
import 'package:clinic_management_app/data/models/prescription_model.dart';

class PrescriptionRemoteDataSource {
  final ApiService _api;

  PrescriptionRemoteDataSource(this._api);

  Future<List<MedicineModel>> getMedicines({int page = 1, int limit = 20, String? search, String? manufacturer}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'search': ?search,
      'manufacturer': ?manufacturer,
    };
    final response = await _api.get('/medicines', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => MedicineModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<MedicineModel> getMedicineById(String id) async {
    final response = await _api.get('/medicines/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MedicineModel.fromMap(data);
  }

  Future<MedicineModel> createMedicine(Map<String, dynamic> body) async {
    final response = await _api.post('/medicines', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return MedicineModel.fromMap(data);
  }

  Future<MedicineModel> updateMedicine(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/medicines/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return MedicineModel.fromMap(data);
  }

  Future<void> deleteMedicine(String id) async {
    await _api.delete('/medicines/$id');
  }

  Future<List<PrescriptionModel>> getPrescriptions(String medicalRecordId, {int page = 1, int limit = 20}) async {
    final response = await _api.get('/medical-records/$medicalRecordId/prescriptions', queryParameters: {'page': page, 'limit': limit});
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => PrescriptionModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<PrescriptionModel> getPrescriptionById(String id) async {
    final response = await _api.get('/prescriptions/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return PrescriptionModel.fromMap(data);
  }

  Future<PrescriptionModel> createPrescription(String medicalRecordId, Map<String, dynamic> body) async {
    final response = await _api.post('/medical-records/$medicalRecordId/prescriptions', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PrescriptionModel.fromMap(data);
  }

  Future<PrescriptionModel> updatePrescription(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/prescriptions/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PrescriptionModel.fromMap(data);
  }

  Future<void> deletePrescription(String id) async {
    await _api.delete('/prescriptions/$id');
  }

  Future<List<PrescriptionItemModel>> getPrescriptionItems(String prescriptionId) async {
    final response = await _api.get('/prescriptions/$prescriptionId/items');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => PrescriptionItemModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<PrescriptionItemModel> createPrescriptionItem(String prescriptionId, Map<String, dynamic> body) async {
    final response = await _api.post('/prescriptions/$prescriptionId/items', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PrescriptionItemModel.fromMap(data);
  }

  Future<PrescriptionItemModel> updatePrescriptionItem(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/prescription-items/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PrescriptionItemModel.fromMap(data);
  }

  Future<void> deletePrescriptionItem(String id) async {
    await _api.delete('/prescription-items/$id');
  }
}
