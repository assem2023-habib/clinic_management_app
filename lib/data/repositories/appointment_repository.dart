import 'package:clinic_management_app/data/models/appointment.dart';
import 'package:clinic_management_app/data/mock/mock_data.dart';

class AppointmentRepository {
  final List<Appointment> _appointments = List.from(MockData.appointments);

  Future<List<Appointment>> getAllAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_appointments);
  }

  Future<Appointment?> getAppointmentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _appointments
        .where(
          (a) =>
              a.date.year == date.year &&
              a.date.month == date.month &&
              a.date.day == date.day,
        )
        .toList();
  }

  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _appointments.where((a) => a.patientId == patientId).toList();
  }

  Future<void> addAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appointments.add(appointment);
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      _appointments[index] = appointment;
    }
  }

  Future<void> deleteAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appointments.removeWhere((a) => a.id == id);
  }

  Future<int> getTodayAppointmentCount() async {
    final today = DateTime.now();
    return _appointments
        .where(
          (a) =>
              a.date.year == today.year &&
              a.date.month == today.month &&
              a.date.day == today.day,
        )
        .length;
  }
}
