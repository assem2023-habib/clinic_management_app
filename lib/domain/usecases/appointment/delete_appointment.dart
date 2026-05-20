import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';

class DeleteAppointment {
  final AppointmentRepository repository;
  DeleteAppointment(this.repository);

  Future<void> call(String id) => repository.deleteAppointment(id);
}
