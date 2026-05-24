import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_state.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_summary_section.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_action_card.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_filter_bar.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_review_card.dart';

class RatingScreen extends StatefulWidget {
  final String? doctorId;

  const RatingScreen({super.key, this.doctorId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<RatingBloc>().add(RatingLoad(doctorId: widget.doctorId));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<RatingBloc>().add(const RatingLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.ratingsTitle),
        actions: [
          IconButton(icon: Icon(Icons.search_rounded, color: colors.textSecondary), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colors.primary.withValues(alpha: 0.15),
              child: Icon(Icons.person_rounded, size: 20, color: colors.primary),
            ),
          ),
        ],
      ),
      body: BlocBuilder<RatingBloc, RatingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!, style: TextStyle(color: colors.error)));
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<RatingBloc>().add(RatingLoad(doctorId: widget.doctorId)),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: AppSpacing.sm,
                    bottom: 100,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: RatingSummarySection(
                            averageRating: state.averageRating,
                            totalReviews: state.totalReviews,
                            distribution: state.distribution,
                          )),
                          const SizedBox(width: AppSpacing.md),
                          const Expanded(flex: 2, child: SizedBox(
                            height: 180,
                            child: RatingActionCard(),
                          )),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      RatingFilterBar(
                        currentFilter: state.currentFilter,
                        onFilterChanged: (f) => context.read<RatingBloc>().add(RatingFilterChanged(f)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (state.displayedReviews.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                          child: Center(
                            child: Text(AppStrings.noReviews, style: TextStyle(color: colors.textSecondary)),
                          ),
                        ),
                      ...state.displayedReviews.map((review) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: RatingReviewCard(
                          review: review,
                          isLiked: state.likedReviewIds.contains(review.id),
                          onToggleLike: () => context.read<RatingBloc>().add(RatingToggleLike(review.id)),
                          onFlag: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppStrings.reviewReported)),
                            );
                          },
                        ),
                      )),
                      if (state.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (!state.hasMore && state.displayedReviews.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Center(
                            child: Text(AppStrings.noMoreReviews, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                          ),
                        ),
                      if (state.hasMore && !state.isLoadingMore)
                        Center(
                          child: OutlinedButton(
                            onPressed: () => context.read<RatingBloc>().add(const RatingLoadMore()),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                            ),
                            child: Text(
                              AppStrings.loadMoreReviews,
                              style: TextStyle(color: colors.primary, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xxl),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
