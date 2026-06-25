import 'package:clinic_management_app/data/models/appointment_model.dart';

abstract class AppointmentDataSource {
  List<AppointmentModel> get allAppointments;
  void addAppointment(AppointmentModel appointment);
  void updateAppointment(AppointmentModel appointment);
  void deleteAppointment(String id);
  List<AppointmentModel> appointmentsByDate(DateTime date);
  List<AppointmentModel> appointmentsByPatient(String patientId);
  int get todayAppointmentCount;
}
