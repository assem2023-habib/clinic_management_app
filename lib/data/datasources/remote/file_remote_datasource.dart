import 'package:dio/dio.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/file_model.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';

class FileRemoteDataSource {
  final ApiService _api;

  FileRemoteDataSource(this._api);

  Future<List<FileModel>> getFiles({bool? mine}) async {
    final query = <String, dynamic>{};
    if (mine == true) query['mine'] = '1';
    final response = await _api.get('/files', queryParameters: query.isNotEmpty ? query : null);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => FileModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<FileModel> getFile(String id) async {
    final response = await _api.get('/files/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return FileModel.fromMap(data);
  }

  Future<FileModel> uploadFile({
    required String filePath,
    required String fileName,
    required String medicalRecordId,
    required FileCategory category,
    String? checksum,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'medical_record_id': medicalRecordId,
      'file_category': category.apiValue,
      'checksum': ?checksum,
    });
    final response = await _api.upload('/files', formData);
    final data = response.data['data'] as Map<String, dynamic>;
    return FileModel.fromMap(data);
  }

  Future<Map<String, dynamic>> initChunkedUpload({
    required String medicalRecordId,
    required FileCategory category,
    required String originalName,
    required String mimeType,
    required int fileSize,
    String? checksum,
  }) async {
    final response = await _api.post('/files/init', data: {
      'medical_record_id': medicalRecordId,
      'file_category': category.apiValue,
      'original_name': originalName,
      'mime_type': mimeType,
      'file_size': fileSize,
      'checksum': ?checksum,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> uploadChunk({
    required String fileId,
    required int chunkIndex,
    required String chunkPath,
  }) async {
    final formData = FormData.fromMap({
      'chunk': await MultipartFile.fromFile(chunkPath),
      'chunk_index': chunkIndex,
    });
    final response = await _api.upload('/files/$fileId/chunk', formData);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<FileModel> completeUpload(String fileId, {String? checksum}) async {
    final response = await _api.post('/files/$fileId/complete', data: {
      'checksum': ?checksum,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    return FileModel.fromMap(data);
  }

  Future<void> deleteFile(String id) async {
    await _api.delete('/files/$id');
  }

  Future<Map<String, dynamic>> requestDownloadLink(String id) async {
    final response = await _api.post('/files/$id/download-link');
    return response.data['data'] as Map<String, dynamic>;
  }
}
