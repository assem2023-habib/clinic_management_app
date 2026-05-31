import 'package:clinic_management_app/data/datasources/remote/image_remote_datasource.dart';
import 'package:clinic_management_app/domain/entities/image_entity.dart';
import 'package:clinic_management_app/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource? remoteDataSource;

  ImageRepositoryImpl({this.remoteDataSource});

  @override
  Future<ImageEntity> uploadImage(String filePath, String type, String imageableId) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.uploadImage(filePath, type, imageableId);
      } catch (_) {}
    }
    throw UnimplementedError('Image upload requires a remote data source');
  }

  @override
  Future<void> deleteImage(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteImage(id);
        return;
      } catch (_) {}
    }
    throw UnimplementedError('Image delete requires a remote data source');
  }
}
