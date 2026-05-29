import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_state.dart';

class DownloadFileBloc extends Bloc<DownloadFileEvent, DownloadFileState> {
  DownloadFileBloc() : super(DownloadFileInitial()) {
    on<DownloadFileLoadAll>(_onLoadAll);
    on<DownloadFileSearch>(_onSearch);
    on<DownloadFileFilterCategory>(_onFilterCategory);
    on<DownloadFileStart>(_onStartDownload);
    on<DownloadFileUpdateProgress>(_onUpdateProgress);
    on<DownloadFileComplete>(_onComplete);
    on<DownloadFileDelete>(_onDelete);
  }

  List<DownloadFileEntity> _allFiles = _mockFiles;
  String _currentQuery = '';
  String _currentCategory = 'all';

  Future<void> _onLoadAll(DownloadFileLoadAll event, Emitter<DownloadFileState> emit) async {
    emit(DownloadFileLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    _allFiles = _mockFiles;
    emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
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

  void _onDelete(DownloadFileDelete event, Emitter<DownloadFileState> emit) {
    _allFiles.removeWhere((f) => f.id == event.fileId);
    if (state is DownloadFileLoaded) {
      emit(DownloadFileLoaded(_filtered(), activeCategory: _currentCategory));
    }
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
      result = result.where((f) => f.name.toLowerCase().contains(_currentQuery.toLowerCase())).toList();
    }
    return result;
  }

  static final List<DownloadFileEntity> _mockFiles = [
    DownloadFileEntity(id: '1', name: 'التقرير الطبي - نوفمبر 2025', type: 'PDF', category: 'report', sizeInMb: 2.4, date: DateTime(2025, 11, 15)),
    DownloadFileEntity(id: '2', name: 'تحليل الدم الكامل', type: 'PDF', category: 'lab', sizeInMb: 1.1, date: DateTime(2025, 11, 10), status: DownloadStatus.completed, progress: 1.0),
    DownloadFileEntity(id: '3', name: 'أشعة الصدر الرقمية', type: 'JPG', category: 'imaging', sizeInMb: 5.8, date: DateTime(2025, 10, 28)),
    DownloadFileEntity(id: '4', name: 'روشتة العلاج - شهر نوفمبر', type: 'PDF', category: 'report', sizeInMb: 0.6, date: DateTime(2025, 11, 20)),
    DownloadFileEntity(id: '5', name: 'تحليل وظائف الكبد', type: 'PDF', category: 'lab', sizeInMb: 1.8, date: DateTime(2025, 9, 5), status: DownloadStatus.downloading, progress: 0.45),
    DownloadFileEntity(id: '6', name: 'الرنين المغناطيسي للركبة', type: 'DCM', category: 'imaging', sizeInMb: 12.3, date: DateTime(2025, 8, 12)),
    DownloadFileEntity(id: '7', name: 'فاتورة الكشف - نوفمبر', type: 'PDF', category: 'billing', sizeInMb: 0.3, date: DateTime(2025, 11, 15), status: DownloadStatus.completed, progress: 1.0),
    DownloadFileEntity(id: '8', name: 'تحليل البول الشامل', type: 'PDF', category: 'lab', sizeInMb: 0.9, date: DateTime(2025, 11, 22)),
  ];
}
