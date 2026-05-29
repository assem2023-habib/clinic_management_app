import 'package:equatable/equatable.dart';

enum DownloadStatus { none, downloading, completed, error }

class DownloadFileEntity extends Equatable {
  final String id;
  final String name;
  final String type;
  final String category;
  final double sizeInMb;
  final DateTime date;
  final DownloadStatus status;
  final double progress;

  const DownloadFileEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.sizeInMb,
    required this.date,
    this.status = DownloadStatus.none,
    this.progress = 0.0,
  });

  DownloadFileEntity copyWith({
    String? id,
    String? name,
    String? type,
    String? category,
    double? sizeInMb,
    DateTime? date,
    DownloadStatus? status,
    double? progress,
  }) {
    return DownloadFileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      sizeInMb: sizeInMb ?? this.sizeInMb,
      date: date ?? this.date,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [id, name, type, category, sizeInMb, date, status, progress];
}
