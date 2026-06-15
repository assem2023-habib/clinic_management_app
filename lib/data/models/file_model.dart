import 'package:clinic_management_app/domain/entities/file_entity.dart';

class FileModel extends FileEntity {
  const FileModel({
    required super.id,
    required super.originalName,
    required super.mimeType,
    required super.size,
    required super.fileCategory,
    required super.uploadStatus,
    required super.medicalRecordId,
    required super.userId,
    super.downloadsCount,
    super.downloadUrl,
    super.createdAt,
  });

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] as String? ?? '',
      originalName: map['original_name'] as String? ?? '',
      mimeType: map['mime_type'] as String? ?? '',
      size: map['size'] as int? ?? 0,
      fileCategory: FileCategory.fromApi(map['file_category'] as String? ?? 'other'),
      uploadStatus: _parseUploadStatus(map['upload_status'] as String?),
      medicalRecordId: map['medical_record_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      downloadsCount: map['downloads_count'] as int? ?? 0,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? ''),
    );
  }

  static FileUploadStatus _parseUploadStatus(String? status) {
    switch (status) {
      case 'completed':
        return FileUploadStatus.completed;
      case 'uploading':
        return FileUploadStatus.uploading;
      default:
        return FileUploadStatus.failed;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original_name': originalName,
      'mime_type': mimeType,
      'size': size,
      'file_category': fileCategory.apiValue,
      'upload_status': uploadStatus.name,
      'medical_record_id': medicalRecordId,
      'user_id': userId,
      'downloads_count': downloadsCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
