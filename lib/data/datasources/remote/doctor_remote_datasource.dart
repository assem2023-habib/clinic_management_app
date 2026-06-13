import 'package:flutter/foundation.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/specialization_model.dart';
import 'package:clinic_management_app/data/models/doctor_schedule_model.dart';

class DoctorRemoteDataSource {
  final ApiService _api;

  DoctorRemoteDataSource(this._api);

  Future<List<DoctorModel>> getDoctors({int page = 1, int limit = 20, String? search, String? specializationId, int? experienceFrom, int? experienceTo, String? gender, String? dateFrom, String? dateTo, bool? isActive}) async {
    final queryParams = <String, dynamic>{
      'page': page, 'limit': limit,
      if (search != null) 'search': search,
      if (specializationId != null) 'specialization_id': specializationId,
      if (experienceFrom != null) 'experience_from': experienceFrom,
      if (experienceTo != null) 'experience_to': experienceTo,
      if (gender != null) 'gender': gender,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (isActive != null) 'is_active': isActive,
    };
    final response = await _api.get('/doctors', queryParameters: queryParams);
    debugPrint('📡 [DoctorRemoteDataSource] GET /doctors response: ${response.data}');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => DoctorModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<DoctorModel> getDoctorById(String id) async {
    final response = await _api.get('/doctors/$id');
    debugPrint('📡 [DoctorRemoteDataSource] GET /doctors/$id response: ${response.data}');
    final data = response.data['data'] as Map<String, dynamic>;
    return DoctorModel.fromMap(data);
  }

  Future<DoctorModel> createDoctor(Map<String, dynamic> body) async {
    final response = await _api.post('/doctors', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return DoctorModel.fromMap(data);
  }

  Future<DoctorModel> updateDoctor(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/doctors/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return DoctorModel.fromMap(data);
  }

  Future<void> deleteDoctor(String id) async {
    await _api.delete('/doctors/$id');
  }

  Future<Map<String, dynamic>> activateAccount(String id) async {
    final response = await _api.put('/doctors/$id/activate-account');
    return response.data as Map<String, dynamic>;
  }

  Future<List<DoctorScheduleModel>> getDoctorSchedules(String doctorId, DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final response = await _api.get('/doctors/$doctorId/booked-slots', queryParameters: {
      'from_date': '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}',
      'to_date': '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}',
      'limit': '100',
    });
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => DoctorScheduleModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<SpecializationModel>> getSpecializations({int page = 1, int limit = 50, String? search, String? slug, bool? isActive}) async {
    final queryParams = <String, dynamic>{
      'page': page, 'limit': limit,
      if (search != null) 'search': search,
      if (slug != null) 'slug': slug,
      if (isActive != null) 'is_active': isActive,
    };
    final response = await _api.get('/specializations', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => SpecializationModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<SpecializationModel> getSpecializationById(String id) async {
    final response = await _api.get('/specializations/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return SpecializationModel.fromMap(data);
  }

  Future<SpecializationModel> createSpecialization(Map<String, dynamic> body) async {
    final response = await _api.post('/specializations', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return SpecializationModel.fromMap(data);
  }

  Future<SpecializationModel> updateSpecialization(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/specializations/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return SpecializationModel.fromMap(data);
  }

  Future<void> deleteSpecialization(String id) async {
    await _api.delete('/specializations/$id');
  }
}
