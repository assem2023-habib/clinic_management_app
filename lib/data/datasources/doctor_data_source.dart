import 'package:clinic_management_app/data/models/doctor_model.dart';

abstract class DoctorDataSource {
  List<DoctorModel> get allDoctors;
  DoctorModel? doctorById(String id);
  void addDoctor(DoctorModel doctor);
  void updateDoctor(DoctorModel doctor);
  void deleteDoctor(String id);
  List<DoctorModel> searchDoctors(String query);
}
