import 'package:flutter/material.dart';
import 'app_durations.dart';
import 'app_curves.dart';
import 'common_tweens.dart';

enum EntranceType {
  fade,
  slideUp,
  fadeSlideUp,
  scaleIn,
  fadeScaleIn,
}

class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final EntranceType type;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final int index;
  final Duration? staggeredDelay;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.type = EntranceType.fadeSlideUp,
    this.delay = Duration.zero,
    this.duration = AppDurations.dStaggered,
    this.curve = AppCurves.easeOutCubic,
    this.index = 0,
    this.staggeredDelay,
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _ctrl, curve: widget.curve);

    _slide = CommonTweens.slideUp
        .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));

    _scale = CommonTweens.scaleIn
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.easeOutBack));

    final effectiveDelay = widget.staggeredDelay ??
        Duration(milliseconds: widget.index * 100);
    final totalDelay = widget.delay + effectiveDelay;
    if (totalDelay > Duration.zero) {
      Future.delayed(totalDelay, () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildAnimated(Widget child) {
    switch (widget.type) {
      case EntranceType.fade:
        return FadeTransition(opacity: _opacity, child: child);
      case EntranceType.slideUp:
        return SlideTransition(position: _slide, child: child);
      case EntranceType.fadeSlideUp:
        return FadeTransition(
          opacity: _opacity,
          child: SlideTransition(position: _slide, child: child),
        );
      case EntranceType.scaleIn:
        return ScaleTransition(scale: _scale, child: child);
      case EntranceType.fadeScaleIn:
        return FadeTransition(
          opacity: _opacity,
          child: ScaleTransition(scale: _scale, child: child),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimated(widget.child);
  }
}
