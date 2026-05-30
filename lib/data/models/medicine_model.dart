import 'package:clinic_management_app/domain/entities/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  const MedicineModel({
    required super.id,
    super.nameAr,
    super.nameEn,
    super.descriptionAr,
    super.descriptionEn,
    super.manufacturer,
    super.barcode,
    super.imageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'] as String,
      nameAr: map['name_ar'] as String?,
      nameEn: map['name_en'] as String?,
      descriptionAr: map['description_ar'] as String?,
      descriptionEn: map['description_en'] as String?,
      manufacturer: map['manufacturer'] as String?,
      barcode: map['barcode'] as String?,
      imageUrl: map['image'] is Map ? (map['image'] as Map)['url'] as String? : map['image_url'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'manufacturer': manufacturer,
      'barcode': barcode,
      'image_url': imageUrl,
    };
  }
}
