import 'package:clinic_management_app/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    super.type = 'user',
    super.rater,
    super.rateableId,
    super.rateableType,
    required super.rating,
    super.comment,
    super.createdAt,
    super.updatedAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      type: map['type'] as String? ?? 'user',
      rater: map['rater'] as Map<String, dynamic>?,
      rateableId: map['rateable_id'] as String?,
      rateableType: map['rateable_type'] as String?,
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }
}
