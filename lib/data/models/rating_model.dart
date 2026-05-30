import 'package:clinic_management_app/domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  const RatingModel({
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

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
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

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'rater': rater,
    'rateable_id': rateableId,
    'rateable_type': rateableType,
    'rating': rating,
    'comment': comment,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
