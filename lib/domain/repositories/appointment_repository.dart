import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentEntity>> getAllAppointments();
  Future<AppointmentEntity?> getAppointmentById(String id);
  Future<List<AppointmentEntity>> getAppointmentsByDate(DateTime date);
  Future<List<AppointmentEntity>> getAppointmentsByPatient(String patientId);
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<void> updateAppointment(AppointmentEntity appointment);
  Future<void> deleteAppointment(String id);
  Future<void> updateAppointmentStatus(String id, AppointmentStatus status);
  Future<int> getTodayAppointmentCount();
}
