import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/animations/animations.dart';

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration? delay;
  final Duration duration;

  const AnimatedCard({
    super.key,
    required this.child,
    this.index = 0,
    this.delay,
    this.duration = AppDurations.dStaggered,
  });

  @override
  Widget build(BuildContext context) {
    final d = delay ?? Duration(milliseconds: index * 100);
    return AnimatedEntrance(
      type: EntranceType.fadeSlideUp,
      delay: d,
      duration: duration,
      child: child,
    );
  }
}
