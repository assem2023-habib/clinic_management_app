import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';

abstract class DownloadFileState extends Equatable {
  const DownloadFileState();
  @override
  List<Object?> get props => [];
}

class DownloadFileInitial extends DownloadFileState {}

class DownloadFileLoading extends DownloadFileState {}

class DownloadFileLoaded extends DownloadFileState {
  final List<DownloadFileEntity> files;
  final String activeCategory;
  const DownloadFileLoaded(this.files, {this.activeCategory = 'all'});
  @override
  List<Object?> get props => [files, activeCategory];
}

class DownloadFileError extends DownloadFileState {
  final String message;
  const DownloadFileError(this.message);
  @override
  List<Object?> get props => [message];
}
