import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/booked_slot_model.dart';

class AppointmentRemoteDataSource {
  final ApiService _api;

  AppointmentRemoteDataSource(this._api);

  Future<List<AppointmentModel>> getAppointments({String? doctorId, String? status, String? date, int page = 1, int limit = 10}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (doctorId != null) 'doctor_id': doctorId,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
    };
    final response = await _api.get('/appointments', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => AppointmentModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<AppointmentModel> getAppointmentById(String id) async {
    final response = await _api.get('/appointments/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentModel.fromMap(data);
  }

  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId, {String? date, String? status, int page = 1, int limit = 10}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
    };
    final response = await _api.get('/doctors/$doctorId/appointments', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => AppointmentModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<AppointmentModel> createAppointment(Map<String, dynamic> body) async {
    final response = await _api.post('/appointments', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentModel.fromMap(data);
  }

  Future<AppointmentModel> setTime(String appointmentId, Map<String, dynamic> body) async {
    final response = await _api.post('/appointments/$appointmentId/set-time', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentModel.fromMap(data);
  }

  Future<AppointmentModel> respond(String appointmentId, String response_) async {
    final response = await _api.post('/appointments/$appointmentId/respond', data: {'response': response_});
    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentModel.fromMap(data);
  }

  Future<AppointmentModel> startAppointment(String appointmentId) async {
    final response = await _api.post('/appointments/$appointmentId/start');
    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentModel.fromMap(data);
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _api.post('/appointments/$appointmentId/cancel');
  }

  Future<void> completeAppointment(String appointmentId) async {
    await _api.post('/appointments/$appointmentId/complete');
  }

  Future<void> suggestAlternative(String appointmentId, String message) async {
    await _api.post('/appointments/$appointmentId/suggest-alternative', data: {'message': message});
  }

  Future<List<BookedSlotModel>> getBookedSlots(String doctorId, {String? date, String? fromDate, String? toDate, int page = 1, int limit = 10}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (date != null) 'date': date,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
    };
    final response = await _api.get('/doctors/$doctorId/booked-slots', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => BookedSlotModel.fromMap(e as Map<String, dynamic>)).toList();
  }
}
