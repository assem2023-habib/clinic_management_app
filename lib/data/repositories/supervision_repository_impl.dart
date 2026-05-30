import 'package:clinic_management_app/data/datasources/remote/supervision_remote_datasource.dart';
import 'package:clinic_management_app/data/models/supervision_model.dart';
import 'package:clinic_management_app/data/models/supervision_request_model.dart';
import 'package:clinic_management_app/domain/entities/supervision_entity.dart';
import 'package:clinic_management_app/domain/entities/supervision_request_entity.dart';
import 'package:clinic_management_app/domain/repositories/supervision_repository.dart';

class SupervisionRepositoryImpl implements SupervisionRepository {
  final SupervisionRemoteDataSource? remoteDataSource;

  SupervisionRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<SupervisionEntity>> getDoctorPatients(String doctorId) async {
    if (remoteDataSource != null) {
      try { return await remoteDataSource!.getDoctorPatients(doctorId); } catch (_) {}
    }
    return List.from(_mockSupervisions.where((s) => s.doctorId == doctorId));
  }

  @override
  Future<List<SupervisionEntity>> getPatientDoctors(String patientId) async {
    if (remoteDataSource != null) {
      try { return await remoteDataSource!.getPatientDoctors(patientId); } catch (_) {}
    }
    return List.from(_mockSupervisions.where((s) => s.patientId == patientId));
  }

  @override
  Future<void> assignPatientToDoctor(String doctorId, String patientId, {String? notes}) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.assignPatientToDoctor(doctorId, patientId, notes: notes); return; } catch (_) {}
    }
    _mockSupervisions.add(SupervisionModel(doctorId: doctorId, patientId: patientId, notes: notes, createdAt: DateTime.now().toIso8601String()));
  }

  @override
  Future<void> selfAssignPatient(String doctorId, String patientId, {String? notes}) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.selfAssignPatient(doctorId, patientId, notes: notes); return; } catch (_) {}
    }
    _mockSupervisions.add(SupervisionModel(doctorId: doctorId, patientId: patientId, notes: notes, createdAt: DateTime.now().toIso8601String()));
  }

  @override
  Future<void> bulkAssignPatients(String doctorId, List<String> patientIds) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.bulkAssignPatients(doctorId, patientIds); return; } catch (_) {}
    }
    for (final pid in patientIds) {
      _mockSupervisions.add(SupervisionModel(doctorId: doctorId, patientId: pid, createdAt: DateTime.now().toIso8601String()));
    }
  }

  @override
  Future<void> removePatientFromDoctor(String doctorId, String patientId) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.removePatientFromDoctor(doctorId, patientId); return; } catch (_) {}
    }
    _mockSupervisions.removeWhere((s) => s.doctorId == doctorId && s.patientId == patientId);
  }

  @override
  Future<void> patientRemoveDoctor(String patientId, String doctorId) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.patientRemoveDoctor(patientId, doctorId); return; } catch (_) {}
    }
    _mockSupervisions.removeWhere((s) => s.patientId == patientId && s.doctorId == doctorId);
  }

  @override
  Future<SupervisionRequestEntity> createSupervisionRequest(String patientId, String doctorId) async {
    if (remoteDataSource != null) {
      try { return await remoteDataSource!.createSupervisionRequest(patientId, doctorId); } catch (_) {}
    }
    final model = SupervisionRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patientId,
      doctorId: doctorId,
      status: 'pending',
      createdAt: DateTime.now().toIso8601String(),
    );
    _mockRequests.add(model);
    return model;
  }

  @override
  Future<List<SupervisionRequestEntity>> getPatientRequests(String patientId) async {
    if (remoteDataSource != null) {
      try { return await remoteDataSource!.getPatientRequests(patientId); } catch (_) {}
    }
    return List.from(_mockRequests.where((r) => r.patientId == patientId));
  }

  @override
  Future<List<SupervisionRequestEntity>> getDoctorRequests(String doctorId, {String? status}) async {
    if (remoteDataSource != null) {
      try { return await remoteDataSource!.getDoctorRequests(doctorId, status: status); } catch (_) {}
    }
    var list = _mockRequests.where((r) => r.doctorId == doctorId);
    if (status != null) list = list.where((r) => r.status == status);
    return List.from(list);
  }

  @override
  Future<void> approveRequest(String requestId) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.approveRequest(requestId); return; } catch (_) {}
    }
    final i = _mockRequests.indexWhere((r) => r.id == requestId);
    if (i != -1) {
      _mockRequests[i] = SupervisionRequestModel(
        id: _mockRequests[i].id, patientId: _mockRequests[i].patientId,
        doctorId: _mockRequests[i].doctorId, status: 'approved',
        respondedAt: DateTime.now().toIso8601String(), createdAt: _mockRequests[i].createdAt,
      );
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.rejectRequest(requestId); return; } catch (_) {}
    }
    final i = _mockRequests.indexWhere((r) => r.id == requestId);
    if (i != -1) {
      _mockRequests[i] = SupervisionRequestModel(
        id: _mockRequests[i].id, patientId: _mockRequests[i].patientId,
        doctorId: _mockRequests[i].doctorId, status: 'rejected',
        respondedAt: DateTime.now().toIso8601String(), createdAt: _mockRequests[i].createdAt,
      );
    }
  }

  @override
  Future<void> cancelRequest(String requestId) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.cancelRequest(requestId); return; } catch (_) {}
    }
    final i = _mockRequests.indexWhere((r) => r.id == requestId);
    if (i != -1) {
      _mockRequests[i] = SupervisionRequestModel(
        id: _mockRequests[i].id, patientId: _mockRequests[i].patientId,
        doctorId: _mockRequests[i].doctorId, status: 'cancelled',
        respondedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  static final List<SupervisionModel> _mockSupervisions = [];
  static final List<SupervisionRequestModel> _mockRequests = [];
}
