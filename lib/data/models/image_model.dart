import 'package:clinic_management_app/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required super.id,
    required super.url,
    required super.type,
    required super.imageableId,
    super.createdAt,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'] as String,
      url: map['url'] as String,
      type: map['type'] as String? ?? '',
      imageableId: map['imageable_id'] as String? ?? '',
      createdAt: map['created_at'] as String?,
    );
  }
}
