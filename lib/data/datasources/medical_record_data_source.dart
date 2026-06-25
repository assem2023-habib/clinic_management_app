import 'package:clinic_management_app/data/models/medical_record_model.dart';

abstract class MedicalRecordDataSource {
  void addMedicalRecord(MedicalRecordModel record);
}
