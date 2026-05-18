import 'package:clinic_management_app/data/models/patient.dart';
import 'package:clinic_management_app/data/mock/mock_data.dart';

class PatientRepository {
  final List<Patient> _patients = List.from(MockData.patients);

  Future<List<Patient>> getAllPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_patients);
  }

  Future<Patient?> getPatientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addPatient(Patient patient) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _patients.add(patient);
  }

  Future<void> updatePatient(Patient patient) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _patients.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      _patients[index] = patient;
    }
  }

  Future<void> deletePatient(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _patients.removeWhere((p) => p.id == id);
  }

  Future<List<Patient>> searchPatients(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return List.from(_patients);
    return _patients
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.phone.contains(query) ||
              p.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
