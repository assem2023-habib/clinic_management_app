import 'package:clinic_management_app/data/datasources/remote/prescription_remote_datasource.dart';
import 'package:clinic_management_app/data/models/medicine_model.dart';
import 'package:clinic_management_app/data/models/prescription_item_model.dart';
import 'package:clinic_management_app/data/models/prescription_model.dart';
import 'package:clinic_management_app/domain/entities/medicine_entity.dart';
import 'package:clinic_management_app/domain/entities/prescription_entity.dart';
import 'package:clinic_management_app/domain/entities/prescription_item_entity.dart';
import 'package:clinic_management_app/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource? remoteDataSource;

  PrescriptionRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<MedicineEntity>> getAllMedicines({String? search, String? manufacturer}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getMedicines(search: search, manufacturer: manufacturer);
      } catch (_) {}
    }
    return List.from(_mockMedicines);
  }

  @override
  Future<MedicineEntity?> getMedicineById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getMedicineById(id);
      } catch (_) {}
    }
    try {
      return _mockMedicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MedicineEntity> createMedicine(MedicineEntity medicine) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createMedicine({
          'name_ar': medicine.nameAr,
          'name_en': medicine.nameEn,
          'description_ar': medicine.descriptionAr,
          'description_en': medicine.descriptionEn,
          'manufacturer': medicine.manufacturer,
          'barcode': medicine.barcode,
        });
      } catch (_) {}
    }
    final model = MedicineModel(
      id: medicine.id, nameAr: medicine.nameAr, nameEn: medicine.nameEn,
      descriptionAr: medicine.descriptionAr, descriptionEn: medicine.descriptionEn,
      manufacturer: medicine.manufacturer, barcode: medicine.barcode, imageUrl: medicine.imageUrl,
    );
    _mockMedicines.add(model);
    return model;
  }

  @override
  Future<void> updateMedicine(MedicineEntity medicine) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updateMedicine(medicine.id, {
          'name_ar': medicine.nameAr,
          'name_en': medicine.nameEn,
          'description_ar': medicine.descriptionAr,
          'description_en': medicine.descriptionEn,
          'manufacturer': medicine.manufacturer,
          'barcode': medicine.barcode,
        });
        return;
      } catch (_) {}
    }
    final i = _mockMedicines.indexWhere((m) => m.id == medicine.id);
    if (i != -1) {
      _mockMedicines[i] = MedicineModel(
        id: medicine.id, nameAr: medicine.nameAr, nameEn: medicine.nameEn,
        descriptionAr: medicine.descriptionAr, descriptionEn: medicine.descriptionEn,
        manufacturer: medicine.manufacturer, barcode: medicine.barcode, imageUrl: medicine.imageUrl,
      );
    }
  }

  @override
  Future<void> deleteMedicine(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteMedicine(id);
        return;
      } catch (_) {}
    }
    _mockMedicines.removeWhere((m) => m.id == id);
  }

  @override
  Future<List<PrescriptionEntity>> getPrescriptions(String medicalRecordId) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPrescriptions(medicalRecordId);
      } catch (_) {}
    }
    return List.from(_mockPrescriptions);
  }

  @override
  Future<PrescriptionEntity?> getPrescriptionById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPrescriptionById(id);
      } catch (_) {}
    }
    try {
      return _mockPrescriptions.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<PrescriptionEntity> createPrescription(String medicalRecordId, PrescriptionEntity prescription) async {
    if (remoteDataSource != null) {
      try {
        final model = PrescriptionModel(
          id: prescription.id, medicalRecordId: prescription.medicalRecordId,
          prescriptionDate: prescription.prescriptionDate, status: prescription.status,
          notes: prescription.notes, items: prescription.items,
        );
        return await remoteDataSource!.createPrescription(medicalRecordId, model.toCreateRequest());
      } catch (_) {}
    }
    final model = PrescriptionModel(
      id: prescription.id, medicalRecordId: medicalRecordId,
      prescriptionDate: prescription.prescriptionDate, status: prescription.status,
      notes: prescription.notes, items: prescription.items,
    );
    _mockPrescriptions.add(model);
    return model;
  }

  @override
  Future<void> updatePrescription(PrescriptionEntity prescription) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updatePrescription(prescription.id, {
          'prescription_date': prescription.prescriptionDate,
          'status': prescription.status,
          'notes': prescription.notes,
        });
        return;
      } catch (_) {}
    }
    final i = _mockPrescriptions.indexWhere((p) => p.id == prescription.id);
    if (i != -1) {
      _mockPrescriptions[i] = PrescriptionModel(
        id: prescription.id, medicalRecordId: prescription.medicalRecordId,
        prescriptionDate: prescription.prescriptionDate, status: prescription.status,
        notes: prescription.notes, items: prescription.items,
      );
    }
  }

  @override
  Future<void> deletePrescription(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deletePrescription(id);
        return;
      } catch (_) {}
    }
    _mockPrescriptions.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<PrescriptionItemEntity>> getPrescriptionItems(String prescriptionId) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPrescriptionItems(prescriptionId);
      } catch (_) {}
    }
    return List.from(_mockItems);
  }

  @override
  Future<PrescriptionItemEntity> createPrescriptionItem(String prescriptionId, PrescriptionItemEntity item) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createPrescriptionItem(prescriptionId, {
          'medicine_id': item.medicineId,
          'dosage': item.dosage,
          'frequency': item.frequency,
          'duration': item.duration,
          'instructions': item.instructions,
        });
      } catch (_) {}
    }
    final model = PrescriptionItemModel(
      id: item.id, prescriptionId: prescriptionId, medicineId: item.medicineId,
      dosage: item.dosage, frequency: item.frequency, duration: item.duration,
      instructions: item.instructions,
    );
    _mockItems.add(model);
    return model;
  }

  @override
  Future<void> updatePrescriptionItem(PrescriptionItemEntity item) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updatePrescriptionItem(item.id, {
          'medicine_id': item.medicineId,
          'dosage': item.dosage,
          'frequency': item.frequency,
          'duration': item.duration,
          'instructions': item.instructions,
        });
        return;
      } catch (_) {}
    }
    final i = _mockItems.indexWhere((it) => it.id == item.id);
    if (i != -1) {
      _mockItems[i] = PrescriptionItemModel(
        id: item.id, prescriptionId: item.prescriptionId, medicineId: item.medicineId,
        dosage: item.dosage, frequency: item.frequency, duration: item.duration,
        instructions: item.instructions,
      );
    }
  }

  @override
  Future<void> deletePrescriptionItem(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deletePrescriptionItem(id);
        return;
      } catch (_) {}
    }
    _mockItems.removeWhere((it) => it.id == id);
  }

  static final List<MedicineModel> _mockMedicines = [];
  static final List<PrescriptionModel> _mockPrescriptions = [];
  static final List<PrescriptionItemModel> _mockItems = [];
}
