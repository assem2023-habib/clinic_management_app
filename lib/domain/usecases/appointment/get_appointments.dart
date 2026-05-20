import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';

class GetAppointments {
  final AppointmentRepository repository;
  GetAppointments(this.repository);

  Future<List<AppointmentEntity>> call() => repository.getAllAppointments();
}
