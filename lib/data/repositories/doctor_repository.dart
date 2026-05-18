import 'package:clinic_management_app/data/models/doctor.dart';
import 'package:clinic_management_app/data/mock/mock_data.dart';

class DoctorRepository {
  final List<Doctor> _doctors = List.from(MockData.doctors);

  Future<List<Doctor>> getAllDoctors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_doctors);
  }

  Future<Doctor?> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _doctors.add(doctor);
  }

  Future<void> updateDoctor(Doctor doctor) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _doctors.indexWhere((d) => d.id == doctor.id);
    if (index != -1) {
      _doctors[index] = doctor;
    }
  }

  Future<void> deleteDoctor(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _doctors.removeWhere((d) => d.id == id);
  }

  Future<List<Doctor>> searchDoctors(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return List.from(_doctors);
    return _doctors
        .where(
          (d) =>
              d.name.toLowerCase().contains(query.toLowerCase()) ||
              d.specialty.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
