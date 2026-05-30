import 'package:equatable/equatable.dart';

class MedicineEntity extends Equatable {
  final String id;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? manufacturer;
  final String? barcode;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  const MedicineEntity({
    required this.id,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.manufacturer,
    this.barcode,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  String get name => nameAr ?? nameEn ?? '';
  String get description => descriptionAr ?? descriptionEn ?? '';

  @override
  List<Object?> get props => [id, nameAr, nameEn, descriptionAr, descriptionEn, manufacturer, barcode, imageUrl, createdAt, updatedAt];
}
