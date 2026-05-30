import 'package:dio/dio.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/image_model.dart';

class ImageRemoteDataSource {
  final ApiService _api;

  ImageRemoteDataSource(this._api);

  Future<ImageModel> uploadImage(String filePath, String type, String imageableId) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'type': type,
      'imageable_id': imageableId,
    });
    final response = await _api.upload('/images', formData);
    return ImageModel.fromMap(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteImage(String id) async {
    await _api.delete('/images/$id');
  }
}
