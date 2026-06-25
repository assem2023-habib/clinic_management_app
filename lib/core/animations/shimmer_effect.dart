import 'package:flutter/material.dart';
import 'app_durations.dart';
import 'common_tweens.dart';

class ShimmerWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    required this.child,
    this.duration = AppDurations.dShimmer,
    this.highlightColor,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                widget.highlightColor ?? Colors.white.withValues(alpha: 0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlideGradientTransform(CommonTweens.shimmerShift.evaluate(_ctrl)),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double offset;
  const _SlideGradientTransform(this.offset);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..setTranslationRaw(bounds.width * offset, 0, 0);
  }
}
