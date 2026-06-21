import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/booked_slot_model.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/booked_slot_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/core/services/appointment_rtdb_service.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final DataSource localDataSource;
  final AppointmentRemoteDataSource? remoteDataSource;
  final AppointmentRtdbService? rtdbService;

  AppointmentRepositoryImpl(this.localDataSource, {this.remoteDataSource, this.rtdbService});

  @override
  Future<List<AppointmentEntity>> getAllAppointments() async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getAppointments();
      } catch (_) {}
    }
    return localDataSource.allAppointments;
  }

  @override
  Future<AppointmentEntity?> getAppointmentById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getAppointmentById(id);
      } catch (_) {}
    }
    try { return localDataSource.allAppointments.firstWhere((a) => a.id == id); } catch (_) { return null; }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDate(DateTime date) async {
    if (remoteDataSource != null) {
      try {
        final dateStr = date.toIso8601String().substring(0, 10);
        return await remoteDataSource!.getAppointments(date: dateStr);
      } catch (_) {}
    }
    return localDataSource.appointmentsByDate(date);
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByPatient(String patientId) async {
    return localDataSource.appointmentsByPatient(patientId);
  }

  @override
  Future<List<AppointmentEntity>> getDoctorAppointments(String doctorId, {String? status, String? date}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getDoctorAppointments(doctorId, status: status, date: date);
      } catch (_) {}
    }
    return localDataSource.allAppointments.where((a) {
      final doc = a.doctor;
      return doc != null && doc.id == doctorId;
    }).toList();
  }

  @override
  Future<void> addAppointment(AppointmentEntity appointment) async {
    localDataSource.addAppointment(_toModel(appointment));
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    localDataSource.updateAppointment(_toModel(appointment));
  }

  @override
  Future<void> deleteAppointment(String id) async => localDataSource.deleteAppointment(id);

  @override
  Future<void> updateAppointmentStatus(String id, AppointmentStatus status) async {
    final a = localDataSource.allAppointments.cast<AppointmentModel?>().firstWhere((a) => a?.id == id);
    if (a != null) {
      localDataSource.updateAppointment(a.copyWith(status: status) as AppointmentModel);
    }
  }

  @override
  Future<int> getTodayAppointmentCount() async => localDataSource.todayAppointmentCount;

  @override
  Future<AppointmentEntity> requestAppointment(String doctorId, {String? preferredDate, String? reason}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createAppointment({
          'doctor_id': doctorId,
          'preferred_date': preferredDate,
          'reason': reason,
        });
      } catch (_) {}
    }
    final model = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: AppointmentStatus.requested,
      reason: reason,
      notes: preferredDate != null ? 'Preferred date: $preferredDate' : null,
      appointmentDate: preferredDate,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    localDataSource.addAppointment(model);
    return model;
  }

  @override
  Future<AppointmentEntity> setAppointmentTime(String appointmentId, String date, String startTime, String endTime) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.setTime(appointmentId, {
          'appointment_date': date,
          'start_time': startTime,
          'end_time': endTime,
        });
      } catch (_) {}
    }
    final a = await getAppointmentById(appointmentId);
    if (a == null) throw Exception('Appointment not found');
    final updated = a.copyWith(
      status: AppointmentStatus.set,
      appointmentDate: date,
      startTime: startTime,
      endTime: endTime,
    ) as AppointmentModel;
    localDataSource.updateAppointment(updated);
    return updated;
  }

  @override
  Future<AppointmentEntity> respondToAppointment(String appointmentId, String response) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.respond(appointmentId, response);
      } catch (_) {}
    }
    final a = await getAppointmentById(appointmentId);
    if (a == null) throw Exception('Appointment not found');
    final status = response == 'accepted' ? AppointmentStatus.accepted : AppointmentStatus.rejected;
    final updated = a.copyWith(status: status) as AppointmentModel;
    localDataSource.updateAppointment(updated);
    return updated;
  }

  @override
  Future<AppointmentEntity> startAppointment(String appointmentId) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.startAppointment(appointmentId);
      } catch (_) {}
    }
    final a = await getAppointmentById(appointmentId);
    if (a == null) throw Exception('Appointment not found');
    final updated = a.copyWith(status: AppointmentStatus.inProgress) as AppointmentModel;
    localDataSource.updateAppointment(updated);
    return updated;
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.cancelAppointment(appointmentId);
        return;
      } catch (_) {}
    }
    final a = await getAppointmentById(appointmentId);
    if (a != null) {
      localDataSource.updateAppointment(a.copyWith(status: AppointmentStatus.cancelled) as AppointmentModel);
    }
  }

  @override
  Future<void> completeAppointment(String appointmentId) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.completeAppointment(appointmentId);
        return;
      } catch (_) {}
    }
    final a = await getAppointmentById(appointmentId);
    if (a != null) {
      localDataSource.updateAppointment(a.copyWith(status: AppointmentStatus.completed) as AppointmentModel);
    }
  }

  @override
  Future<void> suggestAlternative(String appointmentId, String message) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.suggestAlternative(appointmentId, message);
        return;
      } catch (_) {}
    }
    final a = await getAppointmentById(appointmentId);
    if (a != null) {
      final notes = a.notes != null ? '${a.notes}\n$message' : message;
      localDataSource.updateAppointment(a.copyWith(notes: notes) as AppointmentModel);
    }
  }

  @override
  Future<List<BookedSlotEntity>> getBookedSlots(String doctorId, {String? date, String? fromDate, String? toDate}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getBookedSlots(doctorId, date: date, fromDate: fromDate, toDate: toDate);
      } catch (_) {}
    }
    return localDataSource.allAppointments
      .where((a) => a.doctor?.id == doctorId && a.appointmentDate != null)
      .map((a) => BookedSlotModel(
        appointmentDate: a.appointmentDate!,
        startTime: a.startTime ?? '',
        endTime: a.endTime ?? '',
      ))
      .toList();
  }

  @override
  Stream<List<AppointmentEntity>> watchRtdbAppointments(String doctorId) {
    if (rtdbService != null) {
      return rtdbService!.watchBookedAppointments(doctorId).map((list) => list.cast<AppointmentEntity>());
    }
    return Stream.value(localDataSource.allAppointments
      .where((a) => (a.doctor?.id ?? a.doctorId) == doctorId)
      .toList());
  }

  @override
  Stream<List<AppointmentEntity>> watchRtdbAppointmentsByDate(String doctorId, String date) {
    if (rtdbService != null) {
      return rtdbService!.watchBookedAppointmentsByDate(doctorId, date).map((list) => list.cast<AppointmentEntity>());
    }
    return const Stream.empty();
  }

  AppointmentModel _toModel(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      status: entity.status,
      reason: entity.reason,
      notes: entity.notes,
      appointmentDate: entity.appointmentDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      patient: entity.patient,
      doctor: entity.doctor,
    );
  }
}
