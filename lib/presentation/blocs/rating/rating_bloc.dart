import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_state.dart';

const _pageSize = 6;

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc() : super(const RatingState()) {
    on<RatingLoad>(_onLoad);
    on<RatingFilterChanged>(_onFilterChanged);
    on<RatingLoadMore>(_onLoadMore);
    on<RatingToggleLike>(_onToggleLike);
  }

  Future<void> _onLoad(RatingLoad event, Emitter<RatingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final reviews = _mockReviews;
      final dist = _computeDistribution(reviews);
      final avg = _computeAverage(reviews);
      final sorted = _applyFilter(reviews, state.currentFilter);
      emit(state.copyWith(
        isLoading: false,
        allReviews: reviews,
        displayedReviews: sorted.take(_pageSize).toList(),
        averageRating: avg,
        totalReviews: reviews.length,
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

  List<ReviewEntity> _applyFilter(List<ReviewEntity> reviews, RatingFilter filter) {
    final sorted = List<ReviewEntity>.from(reviews);
    switch (filter) {
      case RatingFilter.newest:
        sorted.sort((a, b) => b.date.compareTo(a.date));
      case RatingFilter.highest:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
      case RatingFilter.lowest:
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
      case RatingFilter.withPhotos:
        sorted.sort((a, b) => b.date.compareTo(a.date));
        sorted.retainWhere((r) => r.patientImage != null);
    }
    return sorted;
  }

  double _computeAverage(List<ReviewEntity> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<double>(0, (s, r) => s + r.rating);
    return (sum / reviews.length).roundToDouble();
  }

  List<RatingDistribution> _computeDistribution(List<ReviewEntity> reviews) {
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

final _mockReviews = [
  ReviewEntity(
    id: 'r1',
    patientName: 'سارة العامري',
    patientImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuACPhlrH1hPKgyAOTWhUqL5FN8JL_ZLv0wr_DTzbL6esD58ZnwW0UJ7B8i-YDwUtdbxcY5mF8uvNgrfsqvzY92bHRPsVEcV-DSc_tkHZZ_sHAPJwyQ3j2ptYM8E7y3Ii3sSW6Wbd29WpclfHyHV9caX2qVOROvy76m-gy5cVdLQYn1CQaP0fHd0LFY_bu5WoeLL6kSshxqMta9f-qGm6VbWt05yc6Aa4EWjM0_3NEGc89iewgFscNf8ZPTkzyFQO5eBYV-aO4xHUAg',
    rating: 5,
    comment: 'تجربة ممتازة جداً! الفريق الطبي محترف للغاية والتعامل راقي. التطبيق سهل الاستخدام وساعدني كثيراً في متابعة حالتي الصحية بدقة. أنصح به الجميع.',
    date: DateTime.now().subtract(const Duration(days: 2)),
    likesCount: 24,
  ),
  ReviewEntity(
    id: 'r2',
    patientName: 'أحمد منصور',
    patientImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBvBhvF_9y7NSVyDNgSMEbTNhVbUj0Z4_TbQBw5UKQRNMR93n4AE7MU6QNZNcDsEYjrSRcJjf3dZTnbzAkN763hNJxJApDGj7OfqodulritnDCL0MLmBaJkbQ7dSafwW1t4dYSt1qihH65EmkqstCV7_AG3fX6Ne3Vov2fzkQac-eZzhxxB699dxxKrf4XA9t7cCHjrMhxX9DxhLMIlumTbEBgLZqjyAyeGsi2hoGsxny0uEyAGHC_LF1n06rJS9NF0FreHoYyji7o',
    rating: 4,
    comment: 'النظام دقيق والمتابعة مستمرة. ميزة التحليلات الحيوية رائعة جداً وأعطتني نظرة شاملة عن صحتي لم أكن أجدها في تطبيقات أخرى. شكراً للقائمين عليه.',
    date: DateTime.now().subtract(const Duration(days: 7)),
    likesCount: 12,
  ),
  ReviewEntity(
    id: 'r3',
    patientName: 'ليلى حسن',
    patientImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBOr8cKyKrutMmrToQvJtOD1i03TrPBiJ9A8GMiAwTrS_EsFUjQpplT1yAhUSh26ZqmOY5zgvFQbcHv8MKqEu9R6rVU91Da5ergIvAm-86FbZ8NIosFjFf4Rrf3oTIBYO1c-FUNPqg7nxFtv4xmAWch3L__6DtBcP7GajAXi5nlDZGbiBdb2__RdM8rj0LQvD5WMmH425445fD27YZ1wjN_JdtbaNpMyyDKfz-ctsVUXb1qqA4U4mVwYuijk3QI_dCvwnDcpL9Gh4U',
    rating: 5,
    comment: 'أفضل تطبيق صحي استخدمته على الإطلاق. سرعة الاستجابة من قبل الأطباء مذهلة والتقارير الأسبوعية دقيقة ومفيدة جداً لتحسين نمط حياتي.',
    date: DateTime.now().subtract(const Duration(days: 14)),
    likesCount: 18,
  ),
  ReviewEntity(
    id: 'r4',
    patientName: 'فيصل الحربي',
    patientImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB2gLGySYoa6NWXUu677otU8IVlOm3OhYd1kQIvdU1QyLUBhXw06rE0YFksGfFKvkMoKYJzXsLbmhfdgwwPkRFqfWCTMBYRg5BimoFiSu3J0THDMa03mo022C6lh3kBaTTW-BUIxvicXBoSm6nvtYZw_9rrzdc4X5z-MM5azVC8Ib5Usl0Yn9Tsg27vncNnpWo4iAYmm0tPMeBb1G0cXCJl5n0onTuEwAnpIq5IGCz1qTu3Ndc9sfbrIUQa_2Mni-PCzQaNpZ9-3ro',
    rating: 5,
    comment: 'برنامج ممتاز وموثوق. كنت أبحث عن وسيلة سهلة لمراقبة ضغط الدم والسكري، وهذا التطبيق وفر لي كل ما أحتاجه وأكثر بتصميمه المريح.',
    date: DateTime.now().subtract(const Duration(days: 30)),
    likesCount: 8,
  ),
  ReviewEntity(
    id: 'r5',
    patientName: 'نورة الشمري',
    rating: 5,
    comment: 'خدمة رائعة وفريق متعاون. أنصح الجميع بتجربة هذه المنصة الصحية المتميزة.',
    date: DateTime.now().subtract(const Duration(days: 45)),
    likesCount: 6,
  ),
  ReviewEntity(
    id: 'r6',
    patientName: 'محمد القحطاني',
    rating: 4,
    comment: 'تطبيق جيد جداً ولكن أتمنى إضافة المزيد من التخصصات الطبية في الإصدارات القادمة.',
    date: DateTime.now().subtract(const Duration(days: 60)),
    likesCount: 4,
  ),
  ReviewEntity(
    id: 'r7',
    patientName: 'هدى العتيبي',
    rating: 5,
    comment: 'من أفضل التطبيقات الصحية. المتابعة المستمرة من الأطباء والتذكير بالمواعيد من المميزات الرائعة.',
    date: DateTime.now().subtract(const Duration(days: 75)),
    likesCount: 15,
  ),
  ReviewEntity(
    id: 'r8',
    patientName: 'سعود الدوسري',
    rating: 3,
    comment: 'التطبيق جيد ولكن واجهت بعض المشاكل التقنية في البداية. آمل تحسينها قريباً.',
    date: DateTime.now().subtract(const Duration(days: 90)),
    likesCount: 2,
  ),
];
