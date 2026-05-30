import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String type;
  final Map<String, dynamic>? rater;
  final String? rateableId;
  final String? rateableType;
  final int rating;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;
  final String? patientName;
  final String? date;
  final int? likesCount;

  const ReviewEntity({
    required this.id,
    this.type = 'user',
    this.rater,
    this.rateableId,
    this.rateableType,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.patientName,
    this.date,
    this.likesCount,
  });

  String get raterName {
    if (rater == null) return '';
    final first = rater!['first_name'] as String? ?? '';
    final last = rater!['last_name'] as String? ?? '';
    return '$first $last'.trim();
  }

  @override
  List<Object?> get props => [
    id, type, rater, rateableId, rateableType, rating, comment,
    createdAt, updatedAt, patientName, date, likesCount,
  ];
}
