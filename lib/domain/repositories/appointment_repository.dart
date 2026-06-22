import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/booked_slot_entity.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentEntity>> getAllAppointments({int page = 1, int limit = 10});
  Future<AppointmentEntity?> getAppointmentById(String id);
  Future<List<AppointmentEntity>> getAppointmentsByDate(DateTime date);
  Future<List<AppointmentEntity>> getAppointmentsByPatient(String patientId);
  Future<List<AppointmentEntity>> getDoctorAppointments(String doctorId, {String? status, String? date});
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<void> updateAppointment(AppointmentEntity appointment);
  Future<void> deleteAppointment(String id);
  Future<void> updateAppointmentStatus(String id, AppointmentStatus status);
  Future<int> getTodayAppointmentCount();

  Future<AppointmentEntity> requestAppointment(String doctorId, {String? preferredDate, String? reason});
  Future<AppointmentEntity> setAppointmentTime(String appointmentId, String date, String startTime, String endTime);
  Future<AppointmentEntity> respondToAppointment(String appointmentId, String response);
  Future<AppointmentEntity> startAppointment(String appointmentId);
  Future<void> cancelAppointment(String appointmentId);
  Future<void> completeAppointment(String appointmentId);
  Future<void> suggestAlternative(String appointmentId, String message);
  Future<List<BookedSlotEntity>> getBookedSlots(String doctorId, {String? date, String? fromDate, String? toDate});
  Stream<List<AppointmentEntity>> watchRtdbAppointments(String doctorId);
  Stream<List<AppointmentEntity>> watchRtdbAppointmentsByDate(String doctorId, String date);
}
