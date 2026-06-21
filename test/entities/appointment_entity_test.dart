import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

void main() {
  group('AppointmentStatus', () {
    test('toValue returns correct string for in_progress', () {
      expect(AppointmentStatus.inProgress.toValue(), 'in_progress');
    });

    test('toValue returns name for other statuses', () {
      expect(AppointmentStatus.pending.toValue(), 'pending');
      expect(AppointmentStatus.accepted.toValue(), 'accepted');
      expect(AppointmentStatus.confirmed.toValue(), 'confirmed');
    });

    test('fromString parses in_progress correctly', () {
      expect(AppointmentStatus.fromString('in_progress'), AppointmentStatus.inProgress);
    });

    test('fromString returns requested for unknown value', () {
      expect(AppointmentStatus.fromString('unknown_status'), AppointmentStatus.requested);
    });

    test('fromString round-trips all booked statuses', () {
      final statuses = ['set', 'accepted', 'in_progress', 'confirmed'];
      for (final s in statuses) {
        expect(AppointmentStatus.fromString(s).toValue(), s);
      }
    });
  });

  group('AppointmentEntity', () {
    const base = AppointmentEntity(
      id: 'apt-1',
      status: AppointmentStatus.accepted,
      reason: 'Checkup',
      notes: 'Please bring lab results',
      appointmentDate: '2026-06-15',
      startTime: '10:00',
      endTime: '11:00',
      createdBy: 'admin-1',
      createdAt: '2026-06-10T08:00:00Z',
      updatedAt: '2026-06-10T08:30:00Z',
      patientId: 'pat-1',
      patientName: 'أحمد علي',
      patientPhone: '+963900000000',
      doctorId: 'doc-1',
      doctorName: 'د. خالد',
      date: '2026-06-15',
      timeSlot: '10:00 - 11:00',
    );

    group('copyWith', () {
      test('returns identical object when no arguments', () {
        expect(base.copyWith(), equals(base));
      });

      test('updates id', () {
        final updated = base.copyWith(id: 'apt-2');
        expect(updated.id, 'apt-2');
        expect(updated.status, base.status);
      });

      test('updates status', () {
        final updated = base.copyWith(status: AppointmentStatus.completed);
        expect(updated.status, AppointmentStatus.completed);
      });

      test('updates appointmentDate', () {
        final updated = base.copyWith(appointmentDate: '2026-07-01');
        expect(updated.appointmentDate, '2026-07-01');
      });

      test('updates startTime and endTime', () {
        final updated = base.copyWith(startTime: '14:00', endTime: '15:00');
        expect(updated.startTime, '14:00');
        expect(updated.endTime, '15:00');
      });

      test('updates patient fields', () {
        final updated = base.copyWith(
          patientId: 'pat-2',
          patientName: 'مريم',
          patientPhone: '+963911111111',
        );
        expect(updated.patientId, 'pat-2');
        expect(updated.patientName, 'مريم');
        expect(updated.patientPhone, '+963911111111');
      });

      test('updates doctor fields', () {
        final updated = base.copyWith(
          doctorId: 'doc-2',
          doctorName: 'د. سارة',
        );
        expect(updated.doctorId, 'doc-2');
        expect(updated.doctorName, 'د. سارة');
      });

      test('updates date and timeSlot', () {
        final updated = base.copyWith(
          date: '2026-07-02',
          timeSlot: '15:00 - 16:00',
        );
        expect(updated.date, '2026-07-02');
        expect(updated.timeSlot, '15:00 - 16:00');
      });

      test('updates all fields together', () {
        final updated = base.copyWith(
          id: 'apt-3',
          status: AppointmentStatus.cancelled,
          reason: 'No show',
          notes: null,
          appointmentDate: '2026-08-01',
          startTime: '09:00',
          endTime: '09:30',
          createdBy: 'admin-2',
          createdAt: '2026-07-20T10:00:00Z',
          updatedAt: '2026-07-21T10:00:00Z',
          patientId: 'pat-3',
          patientName: 'عمر',
          patientPhone: '+963922222222',
          doctorId: 'doc-3',
          doctorName: 'د. نور',
          date: '2026-08-01',
          timeSlot: '09:00 - 09:30',
        );
        expect(updated.id, 'apt-3');
        expect(updated.status, AppointmentStatus.cancelled);
        expect(updated.reason, 'No show');
        expect(updated.notes, isNull);
        expect(updated.appointmentDate, '2026-08-01');
        expect(updated.startTime, '09:00');
        expect(updated.endTime, '09:30');
        expect(updated.createdBy, 'admin-2');
        expect(updated.createdAt, '2026-07-20T10:00:00Z');
        expect(updated.updatedAt, '2026-07-21T10:00:00Z');
        expect(updated.patientId, 'pat-3');
        expect(updated.patientName, 'عمر');
        expect(updated.patientPhone, '+963922222222');
        expect(updated.doctorId, 'doc-3');
        expect(updated.doctorName, 'د. نور');
        expect(updated.date, '2026-08-01');
        expect(updated.timeSlot, '09:00 - 09:30');
      });
    });

    group('value equality', () {
      test('identical objects are equal', () {
        final a = AppointmentEntity(id: '1', status: AppointmentStatus.set);
        final b = AppointmentEntity(id: '1', status: AppointmentStatus.set);
        expect(a, equals(b));
      });

      test('different ids are not equal', () {
        final a = AppointmentEntity(id: '1', status: AppointmentStatus.set);
        final b = AppointmentEntity(id: '2', status: AppointmentStatus.set);
        expect(a, isNot(equals(b)));
      });

      test('different statuses are not equal', () {
        final a = AppointmentEntity(id: '1', status: AppointmentStatus.set);
        final b = AppointmentEntity(id: '1', status: AppointmentStatus.accepted);
        expect(a, isNot(equals(b)));
      });
    });

    group('booked status combinations', () {
      test('all booked statuses are distinct', () {
        final set = AppointmentStatus.set;
        final accepted = AppointmentStatus.accepted;
        final inProgress = AppointmentStatus.inProgress;
        final confirmed = AppointmentStatus.confirmed;
        expect(set, isNot(equals(accepted)));
        expect(accepted, isNot(equals(inProgress)));
        expect(inProgress, isNot(equals(confirmed)));
      });
    });
  });
}
