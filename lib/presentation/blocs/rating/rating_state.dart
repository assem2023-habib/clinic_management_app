import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';

class RatingDistribution {
  final int star;
  final double percentage;
  final int count;
  const RatingDistribution({required this.star, required this.percentage, required this.count});
}

class RatingState extends Equatable {
  final List<ReviewEntity> allReviews;
  final List<ReviewEntity> displayedReviews;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final RatingFilter currentFilter;
  final double averageRating;
  final int totalReviews;
  final List<RatingDistribution> distribution;
  final bool hasMore;
  final Set<String> likedReviewIds;

  const RatingState({
    this.allReviews = const [],
    this.displayedReviews = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentFilter = RatingFilter.newest,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.distribution = const [],
    this.hasMore = true,
    this.likedReviewIds = const {},
  });

  RatingState copyWith({
    List<ReviewEntity>? allReviews,
    List<ReviewEntity>? displayedReviews,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    RatingFilter? currentFilter,
    double? averageRating,
    int? totalReviews,
    List<RatingDistribution>? distribution,
    bool? hasMore,
    Set<String>? likedReviewIds,
  }) {
    return RatingState(
      allReviews: allReviews ?? this.allReviews,
      displayedReviews: displayedReviews ?? this.displayedReviews,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentFilter: currentFilter ?? this.currentFilter,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      distribution: distribution ?? this.distribution,
      hasMore: hasMore ?? this.hasMore,
      likedReviewIds: likedReviewIds ?? this.likedReviewIds,
    );
  }

  @override
  List<Object?> get props => [
    allReviews,
    displayedReviews,
    isLoading,
    isLoadingMore,
    error,
    currentFilter,
    averageRating,
    totalReviews,
    distribution,
    hasMore,
    likedReviewIds,
  ];
}
