import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: 200, height: 18),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: List.generate(4, (_) => _statSkeleton(colors)),
          ),
          const SizedBox(height: AppSpacing.lg),
          SkeletonLine(width: 160, height: 18),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: List.generate(3, (_) => _statSkeleton(colors)),
          ),
          const SizedBox(height: AppSpacing.lg),
          _quickActionsSkeleton(colors),
          const SizedBox(height: AppSpacing.lg),
          _cardSkeleton(
            colors,
            child: Column(
              children: [
                SkeletonLine(width: 180, height: 18),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                ...List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _appointmentRowSkeleton(colors),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardSkeleton(AppColorSet colors, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }

  Widget _statSkeleton(AppColorSet colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.skeletonBase.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonBox(width: 24, height: 24, borderRadius: 6),
          SizedBox(height: AppSpacing.sm),
          SkeletonLine(width: 32, height: 20),
          SizedBox(height: AppSpacing.xs),
          SkeletonLine(width: 60, height: 12),
        ],
      ),
    );
  }

  Widget _quickActionsSkeleton(AppColorSet colors) {
    return _cardSkeleton(
      colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: 140, height: 18),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          Row(children: [
            Expanded(child: _actionSkeleton(colors)),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            Expanded(child: _actionSkeleton(colors)),
          ]),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          Row(children: [
            Expanded(child: _actionSkeleton(colors)),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            Expanded(child: _actionSkeleton(colors)),
          ]),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          Row(children: [
            Expanded(child: _actionSkeleton(colors)),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            const Expanded(child: SizedBox()),
          ]),
        ],
      ),
    );
  }

  Widget _actionSkeleton(AppColorSet colors) {
    return SkeletonBox(height: 50, borderRadius: 12);
  }

  Widget _appointmentRowSkeleton(AppColorSet colors) {
    return Row(
      children: [
        const SkeletonCircle(radius: 18),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: double.infinity, height: 14),
              SizedBox(height: AppSpacing.xs),
              SkeletonLine(width: 120, height: 12),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SkeletonBox(width: 60, height: 24, borderRadius: 12),
      ],
    );
  }
}

