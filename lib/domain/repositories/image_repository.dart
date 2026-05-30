import 'package:clinic_management_app/domain/entities/image_entity.dart';

abstract class ImageRepository {
  Future<ImageEntity> uploadImage(String filePath, String type, String imageableId);
  Future<void> deleteImage(String id);
}
