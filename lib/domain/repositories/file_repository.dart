import 'package:clinic_management_app/domain/entities/file_entity.dart';

abstract class FileRepository {
  Future<List<FileEntity>> getFiles({bool? mine});
  Future<FileEntity> getFile(String id);
  Future<FileEntity> uploadFile({
    required String filePath,
    required String fileName,
    required String medicalRecordId,
    required FileCategory category,
    String? checksum,
  });
  Future<Map<String, dynamic>> initChunkedUpload({
    required String medicalRecordId,
    required FileCategory category,
    required String originalName,
    required String mimeType,
    required int fileSize,
    String? checksum,
  });
  Future<Map<String, dynamic>> uploadChunk({
    required String fileId,
    required int chunkIndex,
    required String chunkPath,
  });
  Future<FileEntity> completeUpload(String fileId, {String? checksum});
  Future<void> deleteFile(String id);
  Future<Map<String, dynamic>> requestDownloadLink(String id);
}
