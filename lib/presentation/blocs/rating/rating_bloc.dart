import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/rating_entity.dart';
import 'package:clinic_management_app/domain/repositories/rating_repository.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_state.dart';

const _pageSize = 6;

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository? repository;

  RatingBloc({this.repository}) : super(const RatingState()) {
    on<RatingLoad>(_onLoad);
    on<RatingFilterChanged>(_onFilterChanged);
    on<RatingLoadMore>(_onLoadMore);
    on<RatingToggleLike>(_onToggleLike);
    on<RatingCreate>(_onCreate);
    on<RatingUpdate>(_onUpdate);
    on<RatingDelete>(_onDelete);
  }

  Future<void> _onLoad(RatingLoad event, Emitter<RatingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      List<RatingEntity> ratings;
      if (repository != null) {
        final response = await repository!.getAllRatings(filter: RatingFilter(
          raterId: event.raterId,
          limit: 100,
        ));
        ratings = response.ratings;
      } else {
        ratings = _mockRatings;
      }
      final dist = _computeDistribution(ratings);
      final avg = _computeAverage(ratings);
      final sorted = _applyFilter(ratings, state.currentFilter);
      emit(state.copyWith(
        isLoading: false,
        allReviews: ratings,
        displayedReviews: sorted.take(_pageSize).toList(),
        averageRating: avg,
        totalReviews: ratings.length,
        distribution: dist,
        hasMore: sorted.length > _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onFilterChanged(RatingFilterChanged event, Emitter<RatingState> emit) {
    if (event.filter == state.currentFilter) return;
    final sorted = _applyFilter(state.allReviews, event.filter);
    emit(state.copyWith(
      currentFilter: event.filter,
      displayedReviews: sorted.take(_pageSize).toList(),
      hasMore: sorted.length > _pageSize,
    ));
  }

  void _onLoadMore(RatingLoadMore event, Emitter<RatingState> emit) {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    final sorted = _applyFilter(state.allReviews, state.currentFilter);
    final currentCount = state.displayedReviews.length;
    final next = sorted.skip(currentCount).take(_pageSize).toList();
    emit(state.copyWith(
      isLoadingMore: false,
      displayedReviews: [...state.displayedReviews, ...next],
      hasMore: currentCount + next.length < sorted.length,
    ));
  }

  void _onToggleLike(RatingToggleLike event, Emitter<RatingState> emit) {
    final liked = Set<String>.from(state.likedReviewIds);
    if (liked.contains(event.reviewId)) {
      liked.remove(event.reviewId);
    } else {
      liked.add(event.reviewId);
    }
    emit(state.copyWith(likedReviewIds: liked));
  }

  Future<void> _onCreate(RatingCreate event, Emitter<RatingState> emit) async {
    try {
      if (repository != null) {
        await repository!.createRating(
          type: event.type,
          rateableId: event.rateableId,
          rateableType: event.rateableType,
          rating: event.rating,
          comment: event.comment,
        );
      }
      add(const RatingLoad());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdate(RatingUpdate event, Emitter<RatingState> emit) async {
    try {
      if (repository != null) {
        await repository!.updateRating(
          id: event.id,
          rating: event.rating,
          comment: event.comment,
        );
      }
      add(const RatingLoad());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(RatingDelete event, Emitter<RatingState> emit) async {
    try {
      if (repository != null) {
        await repository!.deleteRating(event.id);
      }
      add(const RatingLoad());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  List<RatingEntity> _applyFilter(List<RatingEntity> reviews, RatingFilterOption filter) {
    final sorted = List<RatingEntity>.from(reviews);
    switch (filter) {
      case RatingFilterOption.newest:
        sorted.sort((a, b) {
          final aDate = a.createdAt ?? '';
          final bDate = b.createdAt ?? '';
          return bDate.compareTo(aDate);
        });
      case RatingFilterOption.highest:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
      case RatingFilterOption.lowest:
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
      case RatingFilterOption.withPhotos:
        sorted.sort((a, b) {
          final aDate = a.createdAt ?? '';
          final bDate = b.createdAt ?? '';
          return bDate.compareTo(aDate);
        });
        sorted.retainWhere((r) => r.raterImage != null);
    }
    return sorted;
  }

  double _computeAverage(List<RatingEntity> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<double>(0, (s, r) => s + r.rating);
    return (sum / reviews.length).roundToDouble();
  }

  List<RatingDistribution> _computeDistribution(List<RatingEntity> reviews) {
    final counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      final star = r.rating.round().clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }
    final total = reviews.length;
    return List.generate(5, (i) {
      final star = 5 - i;
      final count = counts[star] ?? 0;
      return RatingDistribution(
        star: star,
        percentage: total > 0 ? (count / total) * 100 : 0,
        count: count,
      );
    });
  }
}

final _mockRatings = [
  RatingEntity(
    id: 'r1',
    rater: {'first_name': 'سارة', 'last_name': 'العامري'},
    rating: 5,
    comment: 'تجربة ممتازة جداً! الفريق الطبي محترف للغاية والتعامل راقي.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r2',
    rater: {'first_name': 'أحمد', 'last_name': 'منصور'},
    rating: 4,
    comment: 'النظام دقيق والمتابعة مستمرة. ميزة التحليلات الحيوية رائعة جداً.',
    createdAt: DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r3',
    rater: {'first_name': 'ليلى', 'last_name': 'حسن'},
    rating: 5,
    comment: 'أفضل تطبيق صحي استخدمته على الإطلاق. سرعة الاستجابة من قبل الأطباء مذهلة.',
    createdAt: DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r4',
    rater: {'first_name': 'فيصل', 'last_name': 'الحربي'},
    rating: 5,
    comment: 'برنامج ممتاز وموثوق. كنت أبحث عن وسيلة سهلة لمراقبة ضغط الدم والسكري.',
    createdAt: DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r5',
    rater: {'first_name': 'نورة', 'last_name': 'الشمري'},
    rating: 5,
    comment: 'خدمة رائعة وفريق متعاون. أنصح الجميع بتجربة هذه المنصة الصحية المتميزة.',
    createdAt: DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r6',
    rater: {'first_name': 'محمد', 'last_name': 'القحطاني'},
    rating: 4,
    comment: 'تطبيق جيد جداً ولكن أتمنى إضافة المزيد من التخصصات الطبية.',
    createdAt: DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r7',
    rater: {'first_name': 'هدى', 'last_name': 'العتيبي'},
    rating: 5,
    comment: 'من أفضل التطبيقات الصحية. المتابعة المستمرة من الأطباء والتذكير بالمواعيد من المميزات الرائعة.',
    createdAt: DateTime.now().subtract(const Duration(days: 75)).toIso8601String(),
  ),
  RatingEntity(
    id: 'r8',
    rater: {'first_name': 'سعود', 'last_name': 'الدوسري'},
    rating: 3,
    comment: 'التطبيق جيد ولكن واجهت بعض المشاكل التقنية في البداية.',
    createdAt: DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
  ),
];
