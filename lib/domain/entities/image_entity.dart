import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final String url;
  final String type;
  final String imageableId;
  final String? createdAt;

  const ImageEntity({
    required this.id,
    required this.url,
    required this.type,
    required this.imageableId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, url, type, imageableId, createdAt];
}
