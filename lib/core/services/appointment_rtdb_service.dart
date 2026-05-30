import 'package:firebase_database/firebase_database.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';

class AppointmentRtdbService {
  final FirebaseDatabase _database;

  AppointmentRtdbService(this._database);

  String _bookedPath(String doctorId) => '/doctors/$doctorId/booked-appointments';

  Stream<List<AppointmentModel>> watchBookedAppointments(String doctorId) {
    final ref = _database.ref(_bookedPath(doctorId));
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value == null) return <AppointmentModel>[];
      final appointments = <AppointmentModel>[];
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((dateKey, dateValue) {
        if (dateValue is Map) {
          dateValue.forEach((appId, appData) {
            if (appData is Map) {
              appointments.add(AppointmentModel.fromRtdbMap(appData));
            }
          });
        }
      });
      return appointments;
    });
  }

  Future<Map<String, dynamic>?> readDoctorMeta(String doctorId) async {
    final snapshot = await _database.ref('/doctors/$doctorId').once();
    return snapshot.snapshot.value as Map<String, dynamic>?;
  }

  Future<String?> readDoctorName(String doctorId) async {
    final snapshot = await _database.ref('/doctors/$doctorId/doctor_name').once();
    return snapshot.snapshot.value as String?;
  }
}
