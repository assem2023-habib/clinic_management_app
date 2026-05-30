import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/datasources/remote/rating_remote_datasource.dart';
import 'package:clinic_management_app/data/models/rating_model.dart';
import 'package:clinic_management_app/domain/entities/rating_entity.dart';
import 'package:clinic_management_app/domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final DataSource? localDataSource;
  final RatingRemoteDataSource? remoteDataSource;

  RatingRepositoryImpl({this.localDataSource, this.remoteDataSource});

  @override
  Future<RatingListResponse> getAllRatings({RatingFilter? filter}) async {
    if (remoteDataSource != null) {
      final json = await remoteDataSource!.getAllRatings(queryParams: filter?.toQueryParams());
      final dataList = (json['data'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final ratings = dataList.map((m) => RatingModel.fromMap(m)).toList();
      final meta = json['meta']?['pagination'] as Map<String, dynamic>?;
      return RatingListResponse(
        ratings: ratings,
        currentPage: (meta?['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (meta?['last_page'] as num?)?.toInt() ?? 1,
        total: (meta?['total'] as num?)?.toInt() ?? ratings.length,
        hasNextPage: meta?['hasNextPage'] as bool? ?? false,
        hasPreviousPage: meta?['hasPreviousPage'] as bool? ?? false,
      );
    }
    final all = localDataSource?.allRatings ?? [];
    return RatingListResponse(
      ratings: all,
      currentPage: 1,
      lastPage: 1,
      total: all.length,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  @override
  Future<RatingEntity?> getRatingById(String id) async {
    if (remoteDataSource != null) {
      final json = await remoteDataSource!.getRatingById(id);
      final data = json['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return RatingModel.fromMap(data);
    }
    try {
      return localDataSource!.allRatings.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RatingEntity> createRating({
    required String type,
    String? rateableId,
    String? rateableType,
    required int rating,
    String? comment,
  }) async {
    if (remoteDataSource != null) {
      final json = await remoteDataSource!.createRating({
        'type': type,
        if (rateableId != null) 'rateable_id': rateableId,
        if (rateableType != null) 'rateable_type': rateableType,
        'rating': rating,
        if (comment != null) 'comment': comment,
      });
      final data = json['data'] as Map<String, dynamic>;
      return RatingModel.fromMap(data);
    }
    final model = RatingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      rateableId: rateableId,
      rateableType: rateableType,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now().toIso8601String(),
    );
    localDataSource?.addRating(model);
    return model;
  }

  @override
  Future<RatingEntity> updateRating({
    required String id,
    required int rating,
    String? comment,
  }) async {
    if (remoteDataSource != null) {
      final json = await remoteDataSource!.updateRating(id, {
        'rating': rating,
        if (comment != null) 'comment': comment,
      });
      final data = json['data'] as Map<String, dynamic>;
      return RatingModel.fromMap(data);
    }
    final model = RatingModel(
      id: id,
      type: 'user',
      rating: rating,
      comment: comment,
    );
    localDataSource?.updateRating(model);
    return model;
  }

  @override
  Future<void> deleteRating(String id) async {
    if (remoteDataSource != null) {
      await remoteDataSource!.deleteRating(id);
      return;
    }
    localDataSource?.deleteRating(id);
  }
}
