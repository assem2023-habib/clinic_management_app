import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

void main() {
  group('AppointmentModel.fromRtdbMap', () {
    test('sets date and timeSlot from appointment_date, start_time, end_time', () {
      final map = <dynamic, dynamic>{
        'id': 'apt-1',
        'appointment_date': '2026-06-15',
        'start_time': '10:00',
        'end_time': '11:00',
        'status': 'accepted',
      };
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.date, '2026-06-15');
      expect(model.timeSlot, '10:00 - 11:00');
      expect(model.appointmentDate, '2026-06-15');
      expect(model.startTime, '10:00');
      expect(model.endTime, '11:00');
    });

    test('does not set patient_name, patient_id, or patient_phone', () {
      final map = <dynamic, dynamic>{
        'id': 'apt-1',
        'appointment_date': '2026-06-15',
        'start_time': '10:00',
        'end_time': '11:00',
        'status': 'accepted',
      };
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.patientId, isNull);
      expect(model.patientName, isNull);
      expect(model.patientPhone, isNull);
    });

    test('sets timeSlot to null when start_time or end_time is missing', () {
      final map = <dynamic, dynamic>{
        'id': 'apt-2',
        'appointment_date': '2026-06-15',
        'status': 'set',
      };
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.timeSlot, isNull);
      expect(model.startTime, isNull);
      expect(model.endTime, isNull);
    });

    test('sets date to null when appointment_date is missing', () {
      final map = <dynamic, dynamic>{
        'id': 'apt-3',
        'start_time': '10:00',
        'end_time': '11:00',
        'status': 'set',
      };
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.date, isNull);
      expect(model.appointmentDate, isNull);
    });

    test('parses all booked statuses correctly', () {
      final statuses = ['set', 'accepted', 'in_progress', 'confirmed'];
      for (final status in statuses) {
        final map = <dynamic, dynamic>{
          'id': 'apt-1',
          'appointment_date': '2026-06-15',
          'start_time': '10:00',
          'end_time': '11:00',
          'status': status,
        };
        final model = AppointmentModel.fromRtdbMap(map);
        expect(model.status.toValue(), status,
            reason: 'Failed for status: $status');
      }
    });

    test('parses non-booked statuses correctly', () {
      final statuses = ['pending', 'requested', 'rejected', 'cancelled', 'completed'];
      for (final status in statuses) {
        final map = <dynamic, dynamic>{
          'id': 'apt-1',
          'appointment_date': '2026-06-15',
          'start_time': '10:00',
          'end_time': '11:00',
          'status': status,
        };
        final model = AppointmentModel.fromRtdbMap(map);
        expect(model.status.toValue(), status,
            reason: 'Failed for status: $status');
      }
    });

    test('defaults to requested when status is missing', () {
      final map = <dynamic, dynamic>{
        'id': 'apt-1',
      };
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.status, AppointmentStatus.requested);
    });

    test('reads optional fields: reason, notes, synced_at, doctor_id', () {
      final map = <dynamic, dynamic>{
        'id': 'apt-1',
        'appointment_date': '2026-06-15',
        'start_time': '10:00',
        'end_time': '11:00',
        'status': 'accepted',
        'reason': 'Follow-up',
        'notes': 'Patient has allergies',
        'synced_at': '2026-06-10T10:00:00Z',
        'doctor_id': 'doc-1',
      };
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.reason, 'Follow-up');
      expect(model.notes, 'Patient has allergies');
      expect(model.createdAt, '2026-06-10T10:00:00Z');
      expect(model.doctorId, 'doc-1');
    });

    test('handles empty map gracefully', () {
      final map = <dynamic, dynamic>{};
      final model = AppointmentModel.fromRtdbMap(map);
      expect(model.id, '');
      expect(model.status, AppointmentStatus.requested);
      expect(model.date, isNull);
      expect(model.timeSlot, isNull);
      expect(model.appointmentDate, isNull);
    });
  });

  group('AppointmentModel.toRtdbMap', () {
    test('includes all required fields', () {
      final model = AppointmentModel(
        id: 'apt-1',
        status: AppointmentStatus.accepted,
        appointmentDate: '2026-06-15',
        startTime: '10:00',
        endTime: '11:00',
        doctorId: 'doc-1',
        patientId: 'pat-1',
        patientName: 'أحمد',
        patientPhone: '+963900000000',
      );
      final map = model.toRtdbMap();
      expect(map['id'], 'apt-1');
      expect(map['appointment_date'], '2026-06-15');
      expect(map['start_time'], '10:00');
      expect(map['end_time'], '11:00');
      expect(map['status'], 'accepted');
      expect(map['doctor_id'], 'doc-1');
      expect(map['patient_id'], 'pat-1');
      expect(map['patient_name'], 'أحمد');
      expect(map['patient_phone'], '+963900000000');
    });

    test('includes synced_at and timestamp', () {
      final model = AppointmentModel(
        id: 'apt-1',
        status: AppointmentStatus.accepted,
      );
      final map = model.toRtdbMap();
      expect(map['synced_at'], isA<String>());
      expect(map['synced_at_timestamp'], isA<int>());
    });
  });

  group('AppointmentModel.fromMap (REST API)', () {
    test('parses standard REST API response', () {
      final map = <String, dynamic>{
        'id': 'apt-1',
        'status': 'accepted',
        'reason': 'Checkup',
        'notes': null,
        'appointment_date': '2026-06-15',
        'start_time': '10:00',
        'end_time': '11:00',
        'created_by': 'admin-1',
        'created_at': '2026-06-10T08:00:00Z',
        'updated_at': '2026-06-10T08:30:00Z',
      };
      final model = AppointmentModel.fromMap(map);
      expect(model.id, 'apt-1');
      expect(model.status, AppointmentStatus.accepted);
      expect(model.reason, 'Checkup');
      expect(model.appointmentDate, '2026-06-15');
      expect(model.startTime, '10:00');
      expect(model.endTime, '11:00');
    });
  });

  group('AppointmentModel.toMap', () {
    test('produces correct REST API map', () {
      final model = AppointmentModel(
        id: 'apt-1',
        status: AppointmentStatus.inProgress,
        appointmentDate: '2026-06-15',
        startTime: '10:00',
        endTime: '11:00',
      );
      final map = model.toMap();
      expect(map['id'], 'apt-1');
      expect(map['status'], 'in_progress');
      expect(map['appointment_date'], '2026-06-15');
      expect(map['start_time'], '10:00');
      expect(map['end_time'], '11:00');
    });
  });

  group('AppointmentModel value equality', () {
    test('identical models are equal', () {
      final a = AppointmentModel(id: '1', status: AppointmentStatus.set);
      final b = AppointmentModel(id: '1', status: AppointmentStatus.set);
      expect(a, equals(b));
    });

    test('models with different dates are not equal', () {
      final a = AppointmentModel(id: '1', status: AppointmentStatus.set, date: '2026-06-15');
      final b = AppointmentModel(id: '1', status: AppointmentStatus.set, date: '2026-06-16');
      expect(a, isNot(equals(b)));
    });
  });
}
