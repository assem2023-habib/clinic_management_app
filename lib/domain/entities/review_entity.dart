import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String patientName;
  final String? patientImage;
  final double rating;
  final String comment;
  final DateTime date;
  final int likesCount;

  const ReviewEntity({
    required this.id,
    required this.patientName,
    this.patientImage,
    required this.rating,
    required this.comment,
    required this.date,
    this.likesCount = 0,
  });

  @override
  List<Object?> get props => [id, patientName, patientImage, rating, comment, date, likesCount];
}
