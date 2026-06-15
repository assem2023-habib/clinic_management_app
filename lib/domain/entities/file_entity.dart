import 'package:equatable/equatable.dart';

enum FileCategory {
  document,
  labResult,
  xray,
  prescription,
  report,
  other;

  String get apiValue {
    switch (this) {
      case FileCategory.labResult:
        return 'lab_result';
      default:
        return name;
    }
  }

  static FileCategory fromApi(String value) {
    switch (value) {
      case 'lab_result':
        return FileCategory.labResult;
      default:
        return FileCategory.values.firstWhere(
          (e) => e.name == value,
          orElse: () => FileCategory.other,
        );
    }
  }
}

enum FileUploadStatus { completed, uploading, failed }

class FileEntity extends Equatable {
  final String id;
  final String originalName;
  final String mimeType;
  final int size;
  final FileCategory fileCategory;
  final FileUploadStatus uploadStatus;
  final String medicalRecordId;
  final String userId;
  final int downloadsCount;
  final String? downloadUrl;
  final DateTime? createdAt;

  const FileEntity({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.fileCategory,
    required this.uploadStatus,
    required this.medicalRecordId,
    required this.userId,
    this.downloadsCount = 0,
    this.downloadUrl,
    this.createdAt,
  });

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  FileEntity copyWith({
    String? downloadUrl,
    int? downloadsCount,
    FileUploadStatus? uploadStatus,
  }) {
    return FileEntity(
      id: id,
      originalName: originalName,
      mimeType: mimeType,
      size: size,
      fileCategory: fileCategory,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      medicalRecordId: medicalRecordId,
      userId: userId,
      downloadsCount: downloadsCount ?? this.downloadsCount,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id, originalName, mimeType, size, fileCategory, uploadStatus,
    medicalRecordId, userId, downloadsCount, downloadUrl, createdAt,
  ];
}
