import 'package:clinic_management_app/data/models/patient_model.dart';

abstract class PatientDataSource {
  List<PatientModel> get allPatients;
  PatientModel? patientById(String id);
  void addPatient(PatientModel patient);
  void updatePatient(PatientModel patient);
  void deletePatient(String id);
  List<PatientModel> searchPatients(String query);
}
