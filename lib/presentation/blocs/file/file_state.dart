import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';

abstract class FileState extends Equatable {
  const FileState();
  @override
  List<Object?> get props => [];
}

class FileInitial extends FileState {}

class FileLoading extends FileState {}

class FileLoaded extends FileState {
  final List<FileEntity> files;
  const FileLoaded(this.files);
  @override
  List<Object?> get props => [files];
}

class FileUploadProgress extends FileState {
  final double progress;
  final String fileName;
  const FileUploadProgress(this.progress, this.fileName);
  @override
  List<Object?> get props => [progress, fileName];
}

class FileUploadSuccess extends FileState {
  final FileEntity file;
  const FileUploadSuccess(this.file);
  @override
  List<Object?> get props => [file];
}

class FileChunkedInitiated extends FileState {
  final String fileId;
  final int totalChunks;
  const FileChunkedInitiated(this.fileId, {this.totalChunks = 0});
  @override
  List<Object?> get props => [fileId, totalChunks];
}

class FileChunkUploaded extends FileState {
  final String fileId;
  final int totalChunks;
  const FileChunkUploaded(this.fileId, this.totalChunks);
  @override
  List<Object?> get props => [fileId, totalChunks];
}

class FileDownloadLinkReady extends FileState {
  final String url;
  final String expiresAt;
  const FileDownloadLinkReady(this.url, this.expiresAt);
  @override
  List<Object?> get props => [url, expiresAt];
}

class FileError extends FileState {
  final String message;
  const FileError(this.message);
  @override
  List<Object?> get props => [message];
}
