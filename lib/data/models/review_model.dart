import 'package:clinic_management_app/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.patientName,
    super.patientImage,
    required super.rating,
    required super.comment,
    required super.date,
    super.likesCount,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      patientName: map['patientName'] as String,
      patientImage: map['patientImage'] as String?,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      date: DateTime.parse(map['date'] as String),
      likesCount: map['likesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'patientName': patientName,
        'patientImage': patientImage,
        'rating': rating,
        'comment': comment,
        'date': date.toIso8601String(),
        'likesCount': likesCount,
      };
}
