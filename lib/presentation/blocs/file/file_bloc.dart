import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_event.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileRepository _repository;

  FileBloc(this._repository) : super(FileInitial()) {
    on<FileLoadAll>(_onLoadAll);
    on<FileLoadMore>(_onLoadMore);
    on<FileUploadDirect>(_onUploadDirect);
    on<FileChunkedInit>(_onChunkedInit);
    on<FileChunkedUploadChunk>(_onChunkedUploadChunk);
    on<FileChunkedComplete>(_onChunkedComplete);
    on<FileDelete>(_onDelete);
    on<FileRequestDownloadLink>(_onRequestDownloadLink);
    on<FileResetUpload>(_onResetUpload);
  }

  Future<void> _onLoadAll(FileLoadAll event, Emitter<FileState> emit) async {
    emit(FileLoading());
    try {
      final files = await _repository.getFiles(mine: event.mine, page: event.page, limit: event.limit);
      final hasMore = files.length >= event.limit;
      emit(FileLoaded(files, hasMore: hasMore, page: event.page));
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  Future<void> _onLoadMore(FileLoadMore event, Emitter<FileState> emit) async {
    if (state is! FileLoaded || (state as FileLoaded).isLoadingMore) return;
    final current = state as FileLoaded;
    emit(current.copyWith(isLoadingMore: true));
    try {
      final newFiles = await _repository.getFiles(mine: event.mine, page: event.page, limit: event.limit);
      final all = [...current.files, ...newFiles];
      final hasMore = newFiles.length >= event.limit;
      emit(FileLoaded(all, hasMore: hasMore, page: event.page));
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onUploadDirect(FileUploadDirect event, Emitter<FileState> emit) async {
    emit(FileUploadProgress(0, event.fileName));
    try {
      final file = await _repository.uploadFile(
        filePath: event.filePath,
        fileName: event.fileName,
        medicalRecordId: event.medicalRecordId,
        category: event.category,
        checksum: event.checksum,
      );
      emit(FileUploadSuccess(file));
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  Future<void> _onChunkedInit(FileChunkedInit event, Emitter<FileState> emit) async {
    emit(FileUploadProgress(0, event.originalName));
    try {
      final result = await _repository.initChunkedUpload(
        medicalRecordId: event.medicalRecordId,
        category: event.category,
        originalName: event.originalName,
        mimeType: event.mimeType,
        fileSize: event.fileSize,
        checksum: event.checksum,
      );
      emit(FileChunkedInitiated(
        result['id'] as String,
        totalChunks: result['total_chunks'] as int? ?? 0,
      ));
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  Future<void> _onChunkedUploadChunk(FileChunkedUploadChunk event, Emitter<FileState> emit) async {
    try {
      final result = await _repository.uploadChunk(
        fileId: event.fileId,
        chunkIndex: event.chunkIndex,
        chunkPath: event.chunkPath,
      );
      emit(FileChunkUploaded(
        event.fileId,
        result['total_chunks'] as int? ?? 0,
      ));
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  Future<void> _onChunkedComplete(FileChunkedComplete event, Emitter<FileState> emit) async {
    emit(FileUploadProgress(0.9, ''));
    try {
      final file = await _repository.completeUpload(event.fileId, checksum: event.checksum);
      emit(FileUploadSuccess(file));
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  Future<void> _onDelete(FileDelete event, Emitter<FileState> emit) async {
    try {
      await _repository.deleteFile(event.fileId);
      if (state is FileLoaded) {
        final updatedFiles = (state as FileLoaded).files.where((f) => f.id != event.fileId).toList();
        emit(FileLoaded(updatedFiles));
      }
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  Future<void> _onRequestDownloadLink(FileRequestDownloadLink event, Emitter<FileState> emit) async {
    try {
      final result = await _repository.requestDownloadLink(event.fileId);
      emit(FileDownloadLinkReady(
        result['url'] as String,
        result['expires_at'] as String,
      ));
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  void _onResetUpload(FileResetUpload event, Emitter<FileState> emit) {
    emit(FileInitial());
  }
}
