import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    final d = delay ?? Duration(milliseconds: index * 100);
    return child
        .animate()
        .fadeIn(duration: duration, delay: d, curve: Curves.easeOutCubic)
        .slideY(begin: 0.08, end: 0, duration: duration, delay: d, curve: Curves.easeOutCubic);
  }
}
