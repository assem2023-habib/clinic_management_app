import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_state.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_summary_section.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_action_card.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_filter_bar.dart';
import 'package:clinic_management_app/presentation/screens/rating/widgets/rating_review_card.dart';

class RatingScreen extends StatefulWidget {
  final String? doctorId;
  final bool isAppRating;

  const RatingScreen({super.key, this.doctorId, this.isAppRating = false});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.isAppRating) {
      context.read<RatingBloc>().add(const RatingLoad(types: ['service', 'center', 'appointment_system']));
    } else {
      context.read<RatingBloc>().add(RatingLoad(doctorId: widget.doctorId));
    }
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

    return AppShell(
      showBackButton: true,
      useGlassAppBar: true,
      glassTitle: widget.isAppRating ? AppStrings.appRatings : AppStrings.ratingsTitle,
      body: BlocBuilder<RatingBloc, RatingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SkeletonList();
          }
          if (state.error != null) {
            return Center(child: Text(state.error!, style: TextStyle(color: colors.error)));
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<RatingBloc>().add(
              widget.isAppRating
                  ? const RatingLoad(types: ['service', 'center', 'appointment_system'])
                  : RatingLoad(doctorId: widget.doctorId),
            ),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                    child: Row(
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
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        RatingFilterBar(
                          currentFilter: state.currentFilter,
                          onFilterChanged: (f) => context.read<RatingBloc>().add(RatingFilterChanged(f)),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
                if (state.displayedReviews.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: EmptyDataWidget(icon: Icons.rate_review_outlined, title: AppStrings.noReviews, compact: true),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: RatingReviewCard(
                            review: state.displayedReviews[index],
                            isLiked: state.likedReviewIds.contains(state.displayedReviews[index].id),
                            showActions: !widget.isAppRating,
                            onToggleLike: () => context.read<RatingBloc>().add(RatingToggleLike(state.displayedReviews[index].id)),
                            onFlag: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppStrings.reviewReported)),
                              );
                            },
                          ),
                        ),
                        childCount: state.displayedReviews.length,
                      ),
                    ),
                  ),
                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (!state.hasMore && state.displayedReviews.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: EmptyDataWidget(icon: Icons.rate_review_outlined, title: AppStrings.noMoreReviews, compact: true),
                    ),
                  ),
                if (state.hasMore && !state.isLoadingMore)
                  SliverToBoxAdapter(
                    child: Center(
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
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight),
                    child: const SizedBox.shrink(),
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
