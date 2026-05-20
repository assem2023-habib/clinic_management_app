import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';

class GetMedicalRecords {
  final MedicalRecordRepository repository;
  GetMedicalRecords(this.repository);

  Future<List<MedicalRecordEntity>> call() => repository.getAllRecords();
}
