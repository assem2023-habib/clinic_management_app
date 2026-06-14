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
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _greetingSkeleton(colors),
          const SizedBox(height: 24),
          _cardSkeleton(
            colors,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: List.generate(4, (_) => _statSkeleton(colors)),
            ),
          ),
          const SizedBox(height: 16),
          _cardSkeleton(
            colors,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: List.generate(4, (_) => _statSkeleton(colors)),
            ),
          ),
          const SizedBox(height: 24),
          _quickActionsSkeleton(colors),
          const SizedBox(height: 24),
          _cardSkeleton(
            colors,
            child: Column(
              children: [
                SkeletonLine(width: 180, height: 18),
                const SizedBox(height: 12),
                ...List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _appointmentRowSkeleton(colors),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _greetingSkeleton(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(width: 220, height: 26),
        const SizedBox(height: 6),
        SkeletonLine(width: 100, height: 14),
      ],
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonBox(width: 24, height: 24, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonLine(width: 32, height: 20),
          SizedBox(height: 4),
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
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _actionSkeleton(colors)),
            const SizedBox(width: 12),
            Expanded(child: _actionSkeleton(colors)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _actionSkeleton(colors)),
            const SizedBox(width: 12),
            Expanded(child: _actionSkeleton(colors)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _actionSkeleton(colors)),
            const SizedBox(width: 12),
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
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: double.infinity, height: 14),
              SizedBox(height: 4),
              SkeletonLine(width: 120, height: 12),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SkeletonBox(width: 60, height: 24, borderRadius: 12),
      ],
    );
  }
}
