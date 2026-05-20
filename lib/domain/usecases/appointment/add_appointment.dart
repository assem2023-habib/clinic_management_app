import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';

class AddAppointment {
  final AppointmentRepository repository;
  AddAppointment(this.repository);

  Future<void> call(AppointmentEntity appointment) => repository.addAppointment(appointment);
}
