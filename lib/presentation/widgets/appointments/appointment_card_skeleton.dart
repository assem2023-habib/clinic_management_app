import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class AppointmentCardSkeleton extends StatefulWidget {
  const AppointmentCardSkeleton({super.key});
  @override
  State<AppointmentCardSkeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<AppointmentCardSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _anim = Tween(begin: -2.0, end: 2.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Widget _box(double w, double h, {double r = AppSpacing.sm}) {
    final c = AppColors.of(context);
    return AnimatedBuilder(animation: _anim, builder: (_, _) {
      return Container(
        width: w, height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          gradient: LinearGradient(
            stops: const [0, 0.5, 1],
            colors: [c.skeletonBase, c.skeletonShimmer, c.skeletonBase],
            transform: GradientRotation(_anim.value),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: c.cardBg.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          _box(AppSpacing.avatarSize, AppSpacing.avatarSize, r: AppSpacing.lg),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, children: [
            _box(140, 18),
            const SizedBox(height: 6),
            _box(100, 13),
          ])),
          const SizedBox(width: 10),
          _box(64, 26, r: 999),
        ]),
        const SizedBox(height: 14),
        _box(double.infinity, 1),
        const SizedBox(height: 14),
        Row(children: [
          _box(36, 36, r: 10),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _box(40, 11),
            const SizedBox(height: AppSpacing.xs + 1),
            _box(80, 15),
          ]),
          const Spacer(),
          _box(38, 38, r: 19),
        ]),
      ]),
    );
  }
}
