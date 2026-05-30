import 'package:clinic_management_app/domain/entities/medicine_entity.dart';
import 'package:clinic_management_app/domain/entities/prescription_entity.dart';
import 'package:clinic_management_app/domain/entities/prescription_item_entity.dart';

abstract class PrescriptionRepository {
  Future<List<MedicineEntity>> getAllMedicines({String? search, String? manufacturer});
  Future<MedicineEntity?> getMedicineById(String id);
  Future<MedicineEntity> createMedicine(MedicineEntity medicine);
  Future<void> updateMedicine(MedicineEntity medicine);
  Future<void> deleteMedicine(String id);

  Future<List<PrescriptionEntity>> getPrescriptions(String medicalRecordId);
  Future<PrescriptionEntity?> getPrescriptionById(String id);
  Future<PrescriptionEntity> createPrescription(String medicalRecordId, PrescriptionEntity prescription);
  Future<void> updatePrescription(PrescriptionEntity prescription);
  Future<void> deletePrescription(String id);

  Future<List<PrescriptionItemEntity>> getPrescriptionItems(String prescriptionId);
  Future<PrescriptionItemEntity> createPrescriptionItem(String prescriptionId, PrescriptionItemEntity item);
  Future<void> updatePrescriptionItem(PrescriptionItemEntity item);
  Future<void> deletePrescriptionItem(String id);
}
