import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_state.dart';

class DownloadFileBloc extends Bloc<DownloadFileEvent, DownloadFileState> {
  final FileRepository _repository;

  DownloadFileBloc(this._repository) : super(DownloadFileInitial()) {
    on<DownloadFileLoadAll>(_onLoadAll);
    on<DownloadFileLoadMore>(_onLoadMore);
    on<DownloadFileSearch>(_onSearch);
    on<DownloadFileFilterCategory>(_onFilterCategory);
    on<DownloadFileStart>(_onStartDownload);
    on<DownloadFileUpdateProgress>(_onUpdateProgress);
    on<DownloadFileComplete>(_onComplete);
    on<DownloadFileDelete>(_onDelete);
  }

  List<DownloadFileEntity> _allFiles = [];
  String _currentQuery = '';
  String _currentCategory = 'all';

  Future<void> _onLoadAll(DownloadFileLoadAll event, Emitter<DownloadFileState> emit) async {
    emit(DownloadFileLoading());
    try {
      final files = await _repository.getFiles(mine: true, page: event.page, limit: event.limit);
      _allFiles = files.map(_mapToDownloadEntity).toList();
      final hasMore = files.length >= event.limit;
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory, hasMore: hasMore, page: event.page));
    } catch (_) {
      emit(DownloadFileError('Failed to load files'));
    }
  }

  Future<void> _onLoadMore(DownloadFileLoadMore event, Emitter<DownloadFileState> emit) async {
    if (state is! DownloadFileLoaded || (state as DownloadFileLoaded).isLoadingMore) return;
    final current = state as DownloadFileLoaded;
    emit(current.copyWith(isLoadingMore: true));
    try {
      final newFiles = await _repository.getFiles(mine: true, page: event.page, limit: event.limit);
      _allFiles = [..._allFiles, ...newFiles.map(_mapToDownloadEntity)];
      final hasMore = newFiles.length >= event.limit;
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory, hasMore: hasMore, page: event.page));
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  void _onSearch(DownloadFileSearch event, Emitter<DownloadFileState> emit) {
    _currentQuery = event.query;
    if (state is DownloadFileLoaded) {
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
    }
  }

  void _onFilterCategory(DownloadFileFilterCategory event, Emitter<DownloadFileState> emit) {
    _currentCategory = event.category;
    if (state is DownloadFileLoaded) {
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
    }
  }

  Future<void> _onStartDownload(DownloadFileStart event, Emitter<DownloadFileState> emit) async {
    _updateFile(event.fileId, status: DownloadStatus.downloading, progress: 0.0);
    if (state is DownloadFileLoaded) {
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
    }
    try {
      await _repository.requestDownloadLink(event.fileId);
      _updateFile(event.fileId, status: DownloadStatus.downloading, progress: 0.5);
      if (state is DownloadFileLoaded) {
        emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
      }
    } catch (_) {
      _updateFile(event.fileId, status: DownloadStatus.error);
      if (state is DownloadFileLoaded) {
        emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
      }
    }
  }

  void _onUpdateProgress(DownloadFileUpdateProgress event, Emitter<DownloadFileState> emit) {
    _updateFile(event.fileId, progress: event.progress);
    if (state is DownloadFileLoaded) {
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
    }
  }

  void _onComplete(DownloadFileComplete event, Emitter<DownloadFileState> emit) {
    _updateFile(event.fileId, status: DownloadStatus.completed, progress: 1.0);
    if (state is DownloadFileLoaded) {
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
    }
  }

  Future<void> _onDelete(DownloadFileDelete event, Emitter<DownloadFileState> emit) async {
    try {
      await _repository.deleteFile(event.fileId);
      _allFiles.removeWhere((f) => f.id == event.fileId);
      if (state is DownloadFileLoaded) {
        emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
      }
    } catch (_) {}
  }

  void _updateFile(String id, {DownloadStatus? status, double? progress}) {
    final index = _allFiles.indexWhere((f) => f.id == id);
    if (index != -1) {
      _allFiles[index] = _allFiles[index].copyWith(status: status, progress: progress);
    }
  }

  List<DownloadFileEntity> _filtered() {
    var result = _allFiles;
    if (_currentCategory != 'all') {
      result = result.where((f) => f.category == _currentCategory).toList();
    }
    if (_currentQuery.isNotEmpty) {
      final q = _currentQuery.toLowerCase();
      result = result.where((f) =>
        f.name.toLowerCase().contains(q) ||
        f.category.toLowerCase().contains(q) ||
        f.type.toLowerCase().contains(q),
      ).toList();
    }
    return result;
  }

  static DownloadFileEntity _mapToDownloadEntity(FileEntity file) {
    final ext = file.originalName.split('.').last.toUpperCase();
    final category = file.fileCategory.apiValue;
    return DownloadFileEntity(
      id: file.id,
      name: file.originalName,
      type: ext,
      category: category,
      sizeInMb: file.size / (1024 * 1024),
      date: file.createdAt ?? DateTime.now(),
    );
  }
}
