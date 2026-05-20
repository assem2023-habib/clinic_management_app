import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';

class UpdateAppointment {
  final AppointmentRepository repository;
  UpdateAppointment(this.repository);

  Future<void> call(AppointmentEntity appointment) => repository.updateAppointment(appointment);
}
