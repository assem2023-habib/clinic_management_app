import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final DataSource dataSource;

  AppointmentRepositoryImpl(this.dataSource);

  @override
  Future<List<AppointmentEntity>> getAllAppointments() async => dataSource.allAppointments;

  @override
  Future<AppointmentEntity?> getAppointmentById(String id) async {
    try { return dataSource.allAppointments.firstWhere((a) => a.id == id); } catch (_) { return null; }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDate(DateTime date) async =>
      dataSource.appointmentsByDate(date);

  @override
  Future<List<AppointmentEntity>> getAppointmentsByPatient(String patientId) async =>
      dataSource.appointmentsByPatient(patientId);

  @override
  Future<void> addAppointment(AppointmentEntity appointment) async {
    dataSource.addAppointment(AppointmentModel(
      id: appointment.id, status: appointment.status,
      reason: appointment.reason, notes: appointment.notes,
      appointmentDate: appointment.appointmentDate,
      startTime: appointment.startTime, endTime: appointment.endTime,
      createdBy: appointment.createdBy,
      createdAt: appointment.createdAt, updatedAt: appointment.updatedAt,
      patient: appointment.patient, doctor: appointment.doctor,
    ));
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    dataSource.updateAppointment(AppointmentModel(
      id: appointment.id, status: appointment.status,
      reason: appointment.reason, notes: appointment.notes,
      appointmentDate: appointment.appointmentDate,
      startTime: appointment.startTime, endTime: appointment.endTime,
      createdBy: appointment.createdBy,
      createdAt: appointment.createdAt, updatedAt: appointment.updatedAt,
      patient: appointment.patient, doctor: appointment.doctor,
    ));
  }

  @override
  Future<void> deleteAppointment(String id) async => dataSource.deleteAppointment(id);

  @override
  Future<void> updateAppointmentStatus(String id, AppointmentStatus status) async {
    final a = dataSource.allAppointments.cast<AppointmentModel?>().firstWhere((a) => a?.id == id);
    if (a != null) {
      dataSource.updateAppointment(AppointmentModel(
        id: a.id, status: status,
        reason: a.reason, notes: a.notes,
        appointmentDate: a.appointmentDate,
        startTime: a.startTime, endTime: a.endTime,
        createdBy: a.createdBy,
        createdAt: a.createdAt, updatedAt: a.updatedAt,
        patient: a.patient, doctor: a.doctor,
      ));
    }
  }

  @override
  Future<int> getTodayAppointmentCount() async => dataSource.todayAppointmentCount;
}
