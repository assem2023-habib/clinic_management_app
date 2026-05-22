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
      id: appointment.id, patientId: appointment.patientId,
      patientName: appointment.patientName, doctorId: appointment.doctorId,
      doctorName: appointment.doctorName, date: appointment.date,
      timeSlot: appointment.timeSlot, status: appointment.status,
      notes: appointment.notes,
    ));
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    dataSource.updateAppointment(AppointmentModel(
      id: appointment.id, patientId: appointment.patientId,
      patientName: appointment.patientName, doctorId: appointment.doctorId,
      doctorName: appointment.doctorName, date: appointment.date,
      timeSlot: appointment.timeSlot, status: appointment.status,
      notes: appointment.notes,
    ));
  }

  @override
  Future<void> deleteAppointment(String id) async => dataSource.deleteAppointment(id);

  @override
  Future<void> updateAppointmentStatus(String id, AppointmentStatus status) async {
    final a = dataSource.allAppointments.cast<AppointmentModel?>().firstWhere((a) => a?.id == id);
    if (a != null) {
      dataSource.updateAppointment(AppointmentModel(
        id: a.id, patientId: a.patientId, patientName: a.patientName,
        doctorId: a.doctorId, doctorName: a.doctorName, date: a.date,
        timeSlot: a.timeSlot, status: status, notes: a.notes,
      ));
    }
  }

  @override
  Future<int> getTodayAppointmentCount() async => dataSource.todayAppointmentCount;
}
