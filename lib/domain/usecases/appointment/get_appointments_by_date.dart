import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';

class GetAppointmentsByDate {
  final AppointmentRepository repository;
  GetAppointmentsByDate(this.repository);

  Future<List<AppointmentEntity>> call(DateTime date) => repository.getAppointmentsByDate(date);
}
