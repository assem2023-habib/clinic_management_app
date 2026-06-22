import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Decorator widget that wraps [child] with an animated ambient background
/// of floating green glow orbs and rising particles.
///
/// Usage:
/// ```dart
/// AmbientBackground(
///   child: MyContent(),
/// )
/// ```
///
/// Or standalone inside an existing Stack:
/// ```dart
/// Stack(
///   children: [
///     const AmbientBackground(),
///     MyContent(),
///   ],
/// )
/// ```
class AmbientBackground extends StatefulWidget {
  final Widget? child;

  const AmbientBackground({super.key, this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBgState();
}

class _AmbientBgState extends State<AmbientBackground>
    with TickerProviderStateMixin {
  late AnimationController _orb1Ctrl, _orb2Ctrl, _orb3Ctrl;

  void _mkOrb(AnimationController c) {
    c
      ..forward()
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) c.reverse();
        if (s == AnimationStatus.dismissed) c.forward();
      });
  }

  @override
  void initState() {
    super.initState();
    _orb1Ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _orb2Ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 18));
    _orb3Ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 22));
    _mkOrb(_orb1Ctrl);
    _mkOrb(_orb2Ctrl);
    _mkOrb(_orb3Ctrl);
  }

  @override
  void dispose() {
    _orb1Ctrl.dispose();
    _orb2Ctrl.dispose();
    _orb3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Stack(clipBehavior: Clip.none, children: [
            AnimatedBuilder(animation: _orb1Ctrl, builder: (_, _) {
              final t = _orb1Ctrl.value;
              return Positioned(
                top: lerpDouble(-100, -30, t)!,
                right: lerpDouble(-80, 20, t)!,
                child: _Orb(size: 380, color: AppColors.dark.primaryDark),
              );
            }),
            AnimatedBuilder(animation: _orb2Ctrl, builder: (_, _) {
              final t = _orb2Ctrl.value;
              return Positioned(
                bottom: lerpDouble(-50, 30, t)!,
                left: lerpDouble(-50, 20, t)!,
                child: _Orb(size: 280, color: AppColors.dark.primary),
              );
            }),
            AnimatedBuilder(animation: _orb3Ctrl, builder: (_, _) {
              final t = _orb3Ctrl.value;
              final height = MediaQuery.of(context).size.height;
              final width = MediaQuery.of(context).size.width;
              return Positioned(
                top: lerpDouble(height * 0.35, height * 0.45, t)!,
                left: lerpDouble(width * 0.25, width * 0.35, t)!,
                child: _Orb(size: 240, color: AppColors.dark.secondary, opacity: 0.08),
              );
            }),
            const _RisingParticles(count: 30),
          ]),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const _Orb({required this.size, required this.color, this.opacity = 0.15});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _RisingParticles extends StatefulWidget {
  final int count;
  const _RisingParticles({this.count = 30});

  @override
  State<_RisingParticles> createState() => _RisingParticlesState();
}

class _RisingParticlesState extends State<_RisingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _rand = Random();
  late List<_RisingParticle> _particles;

  _RisingParticle _makeParticle() => _RisingParticle(
        x: _rand.nextDouble(),
        progress: _rand.nextDouble(),
        size: 1 + _rand.nextDouble() * 3,
        speed: (10 + _rand.nextDouble() * 10) / 1000,
      );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_tick)
      ..repeat();
    _particles = List.generate(widget.count, (_) => _makeParticle());
  }

  void _tick() {
    setState(() {
      for (var i = 0; i < _particles.length; i++) {
        _particles[i].progress += _particles[i].speed;
        if (_particles[i].progress >= 1.0) {
          _particles[i] = _makeParticle()..progress = 0;
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _RisingPainter(_particles),
        size: Size.infinite,
      ),
    );
  }
}

class _RisingParticle {
  double x, progress, size, speed;
  _RisingParticle({
    required this.x,
    required this.progress,
    required this.size,
    required this.speed,
  });
}

class _RisingPainter extends CustomPainter {
  final List<_RisingParticle> particles;
  const _RisingPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = p.progress;
      final y = size.height * (1 - t);
      final op = t < 0.1
          ? t / 0.1
          : (t > 0.9 ? (1 - t) / 0.1 : 1.0);
      canvas.drawCircle(
        Offset(size.width * p.x, y),
        p.size / 2,
        Paint()..color = AppColors.dark.primary.withValues(alpha: op * 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}
