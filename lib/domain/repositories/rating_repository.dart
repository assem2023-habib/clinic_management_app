import 'package:clinic_management_app/domain/entities/rating_entity.dart';

class RatingFilter {
  final String? type;
  final List<String>? types;
  final String? raterId;
  final String? rateableId;
  final String? rateableType;
  final int? rating;
  final int limit;
  final int page;

  const RatingFilter({
    this.type,
    this.types,
    this.raterId,
    this.rateableId,
    this.rateableType,
    this.rating,
    this.limit = 20,
    this.page = 1,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (types != null && types!.isNotEmpty) {
      params['type'] = types;
    } else if (type != null) {
      params['type'] = type;
    }
    if (raterId != null) params['rater_id'] = raterId;
    if (rateableId != null) params['rateable_id'] = rateableId;
    if (rateableType != null) params['rateable_type'] = rateableType;
    if (rating != null) params['rating'] = rating;
    params['limit'] = limit;
    params['page'] = page;
    return params;
  }
}

class RatingListResponse {
  final List<RatingEntity> ratings;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const RatingListResponse({
    required this.ratings,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}

abstract class RatingRepository {
  Future<RatingListResponse> getAllRatings({RatingFilter? filter});
  Future<RatingEntity?> getRatingById(String id);
  Future<RatingEntity> createRating({
    required String type,
    String? rateableId,
    String? rateableType,
    required int rating,
    String? comment,
  });
  Future<RatingEntity> updateRating({
    required String id,
    required int rating,
    String? comment,
  });
  Future<void> deleteRating(String id);
}
