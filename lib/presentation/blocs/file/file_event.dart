import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();
  @override
  List<Object?> get props => [];
}

class FileLoadAll extends FileEvent {
  final bool mine;
  final int page;
  final int limit;
  const FileLoadAll({this.mine = true, this.page = 1, this.limit = 20});
  @override
  List<Object?> get props => [mine, page, limit];
}

class FileLoadMore extends FileEvent {
  final bool mine;
  final int page;
  final int limit;
  const FileLoadMore({this.mine = true, this.page = 1, this.limit = 20});
  @override
  List<Object?> get props => [mine, page, limit];
}

class FileUploadDirect extends FileEvent {
  final String filePath;
  final String fileName;
  final String medicalRecordId;
  final FileCategory category;
  final String? checksum;

  const FileUploadDirect({
    required this.filePath,
    required this.fileName,
    required this.medicalRecordId,
    required this.category,
    this.checksum,
  });
  @override
  List<Object?> get props => [filePath, fileName, medicalRecordId, category, checksum];
}

class FileChunkedInit extends FileEvent {
  final String medicalRecordId;
  final FileCategory category;
  final String originalName;
  final String mimeType;
  final int fileSize;
  final String? checksum;

  const FileChunkedInit({
    required this.medicalRecordId,
    required this.category,
    required this.originalName,
    required this.mimeType,
    required this.fileSize,
    this.checksum,
  });
  @override
  List<Object?> get props => [medicalRecordId, category, originalName, mimeType, fileSize, checksum];
}

class FileChunkedUploadChunk extends FileEvent {
  final String fileId;
  final int chunkIndex;
  final String chunkPath;

  const FileChunkedUploadChunk({
    required this.fileId,
    required this.chunkIndex,
    required this.chunkPath,
  });
  @override
  List<Object?> get props => [fileId, chunkIndex, chunkPath];
}

class FileChunkedComplete extends FileEvent {
  final String fileId;
  final String? checksum;

  const FileChunkedComplete(this.fileId, {this.checksum});
  @override
  List<Object?> get props => [fileId, checksum];
}

class FileDelete extends FileEvent {
  final String fileId;
  const FileDelete(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class FileRequestDownloadLink extends FileEvent {
  final String fileId;
  const FileRequestDownloadLink(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class FileResetUpload extends FileEvent {
  const FileResetUpload();
}
