import 'package:equatable/equatable.dart';

abstract class DownloadFileEvent extends Equatable {
  const DownloadFileEvent();
  @override
  List<Object?> get props => [];
}

class DownloadFileLoadAll extends DownloadFileEvent {
  final int page;
  final int limit;
  const DownloadFileLoadAll({this.page = 1, this.limit = 20});
  @override
  List<Object?> get props => [page, limit];
}

class DownloadFileLoadMore extends DownloadFileEvent {
  final int page;
  final int limit;
  const DownloadFileLoadMore({this.page = 1, this.limit = 20});
  @override
  List<Object?> get props => [page, limit];
}

class DownloadFileSearch extends DownloadFileEvent {
  final String query;
  const DownloadFileSearch(this.query);
  @override
  List<Object?> get props => [query];
}

class DownloadFileStart extends DownloadFileEvent {
  final String fileId;
  const DownloadFileStart(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class DownloadFileUpdateProgress extends DownloadFileEvent {
  final String fileId;
  final double progress;
  const DownloadFileUpdateProgress(this.fileId, this.progress);
  @override
  List<Object?> get props => [fileId, progress];
}

class DownloadFileComplete extends DownloadFileEvent {
  final String fileId;
  const DownloadFileComplete(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class DownloadFileDelete extends DownloadFileEvent {
  final String fileId;
  const DownloadFileDelete(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class DownloadFileFilterCategory extends DownloadFileEvent {
  final String category;
  const DownloadFileFilterCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class DownloadFileInitialEvent extends DownloadFileEvent {
  const DownloadFileInitialEvent();
}
