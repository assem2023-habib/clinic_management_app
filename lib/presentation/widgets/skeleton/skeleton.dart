import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

Widget _shimmer(Widget child, BuildContext context) {
  final colors = AppColors.of(context);
  return child.animate(
    onInit: (controller) => controller.repeat(),
  ).shimmer(duration: const Duration(milliseconds: 1500), color: colors.skeletonShimmer);
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets? margin;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppSpacing.cardRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.skeletonBase,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
    if (margin != null) return _shimmer(Padding(padding: margin!, child: box), context);
    return _shimmer(box, context);
  }
}

class SkeletonCircle extends StatelessWidget {
  final double radius;

  const SkeletonCircle({super.key, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return _shimmer(
      Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(color: colors.skeletonBase, shape: BoxShape.circle),
      ),
      context,
    );
  }
}

class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return _shimmer(
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.skeletonBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      context,
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const SkeletonCircle(radius: 25),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: double.infinity, height: 15),
                SizedBox(height: AppSpacing.sm),
                SkeletonLine(width: 180, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int count;

  const SkeletonList({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, _) => const SkeletonCard(),
    );
  }
}

class SkeletonProfile extends StatelessWidget {
  const SkeletonProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SkeletonCircle(radius: 48),
          const SizedBox(height: AppSpacing.md),
          const SkeletonLine(width: 200, height: 20),
          const SizedBox(height: AppSpacing.sm),
          const SkeletonLine(width: 140, height: 14),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoCard(colors),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard(colors),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: const Column(
        children: [
          SkeletonLine(width: double.infinity, height: 16),
          SizedBox(height: AppSpacing.sm),
          SkeletonLine(width: double.infinity, height: 14),
          SizedBox(height: AppSpacing.sm),
          SkeletonLine(width: 150, height: 14),
        ],
      ),
    );
  }
}
