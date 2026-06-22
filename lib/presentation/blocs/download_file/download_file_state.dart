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
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  const DownloadFileLoaded(this.files, {this.activeCategory = 'all', this.isLoadingMore = false, this.hasMore = true, this.page = 1});
  DownloadFileLoaded copyWith({List<DownloadFileEntity>? files, String? activeCategory, bool? isLoadingMore, bool? hasMore, int? page}) {
    return DownloadFileLoaded(
      files ?? this.files,
      activeCategory: activeCategory ?? this.activeCategory,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
  @override
  List<Object?> get props => [files, activeCategory, isLoadingMore, hasMore, page];
}

class DownloadFileError extends DownloadFileState {
  final String message;
  const DownloadFileError(this.message);
  @override
  List<Object?> get props => [message];
}
