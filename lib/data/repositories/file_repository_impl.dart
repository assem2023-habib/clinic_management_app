import 'package:clinic_management_app/data/datasources/remote/file_remote_datasource.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource? remoteDataSource;

  FileRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<FileEntity>> getFiles({bool? mine}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getFiles(mine: mine);
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<FileEntity> getFile(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getFile(id);
      } catch (_) {}
    }
    throw UnimplementedError('No remote data source available');
  }

  @override
  Future<FileEntity> uploadFile({
    required String filePath,
    required String fileName,
    required String medicalRecordId,
    required FileCategory category,
    String? checksum,
  }) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.uploadFile(
          filePath: filePath,
          fileName: fileName,
          medicalRecordId: medicalRecordId,
          category: category,
          checksum: checksum,
        );
      } catch (_) {}
    }
    throw UnimplementedError('No remote data source available');
  }

  @override
  Future<Map<String, dynamic>> initChunkedUpload({
    required String medicalRecordId,
    required FileCategory category,
    required String originalName,
    required String mimeType,
    required int fileSize,
    String? checksum,
  }) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.initChunkedUpload(
          medicalRecordId: medicalRecordId,
          category: category,
          originalName: originalName,
          mimeType: mimeType,
          fileSize: fileSize,
          checksum: checksum,
        );
      } catch (_) {}
    }
    throw UnimplementedError('No remote data source available');
  }

  @override
  Future<Map<String, dynamic>> uploadChunk({
    required String fileId,
    required int chunkIndex,
    required String chunkPath,
  }) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.uploadChunk(
          fileId: fileId,
          chunkIndex: chunkIndex,
          chunkPath: chunkPath,
        );
      } catch (_) {}
    }
    throw UnimplementedError('No remote data source available');
  }

  @override
  Future<FileEntity> completeUpload(String fileId, {String? checksum}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.completeUpload(fileId, checksum: checksum);
      } catch (_) {}
    }
    throw UnimplementedError('No remote data source available');
  }

  @override
  Future<void> deleteFile(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteFile(id);
        return;
      } catch (_) {}
    }
  }

  @override
  Future<Map<String, dynamic>> requestDownloadLink(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.requestDownloadLink(id);
      } catch (_) {}
    }
    throw UnimplementedError('No remote data source available');
  }
}
