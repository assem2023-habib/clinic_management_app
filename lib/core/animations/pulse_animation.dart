import 'package:flutter/material.dart';
import 'app_durations.dart';
import 'app_curves.dart';

class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final Curve curve;
  final bool repeat;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = AppDurations.dPulse,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.curve = AppCurves.easeInOutSine,
    this.repeat = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.minScale, end: widget.maxScale)
        .chain(CurveTween(curve: widget.curve))
        .animate(_ctrl);
    if (widget.repeat) {
      _ctrl.repeat(reverse: true);
    } else {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}

class PulsingDot extends StatefulWidget {
  final double size;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final Duration duration;

  const PulsingDot({
    super.key,
    this.size = 12,
    required this.color,
    this.borderColor,
    this.borderWidth = 2,
    this.boxShadow,
    this.duration = AppDurations.dPulse,
  });

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacityAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.3).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_ctrl);
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnim,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: (widget.borderColor ?? widget.color).withValues(alpha: 0.5),
            width: widget.borderWidth,
          ),
          boxShadow: widget.boxShadow,
        ),
      ),
    );
  }
}

class PulseRing extends StatefulWidget {
  final double size;
  final Color color;
  final int ringCount;
  final Duration duration;
  final double maxScale;

  const PulseRing({
    super.key,
    this.size = 200,
    required this.color,
    this.ringCount = 3,
    this.duration = AppDurations.dPulseSlow,
    this.maxScale = 2.5,
  });

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(widget.ringCount, (i) {
            final phase = i / widget.ringCount;
            final t = (_ctrl.value + phase) % 1.0;
            final scale = 1.0 + t * (widget.maxScale - 1.0);
            final opacity = (1.0 - t) * 0.4;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: opacity),
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class FloatAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double maxScale;
  final double maxOffset;

  const FloatAnimation({
    super.key,
    required this.child,
    this.duration = AppDurations.dBounce,
    this.maxScale = 1.05,
    this.maxOffset = -10,
  });

  @override
  State<FloatAnimation> createState() => _FloatAnimationState();
}

class _FloatAnimationState extends State<FloatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final scale = 1.0 + (_ctrl.value * (widget.maxScale - 1.0));
        final offset = _ctrl.value * widget.maxOffset;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class RotatingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const RotatingWidget({
    super.key,
    required this.child,
    this.duration = AppDurations.dRotate,
  });

  @override
  State<RotatingWidget> createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: widget.child,
    );
  }
}
