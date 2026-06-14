import 'dart:math';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

class Particle {
  Offset position;
  Offset target;
  double size;
  double progress;
  double speed;
  double twinklePhase;
  Particle({
    required this.position,
    required this.target,
    required this.size,
    required this.speed,
  })  : progress = 0,
        twinklePhase = Random().nextDouble() * 3.14159 * 2;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double? pulseProgress;
  final bool starMode;
  final Color starColor;
  final Color particleColor;
  final Color pulseColor;

  ParticlePainter(this.particles, this.pulseProgress, {
    this.starMode = false,
    required this.starColor,
    required this.particleColor,
    required this.pulseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!starMode && pulseProgress != null) {
      final center = Offset(size.width / 2, size.height / 2);
      final pulseRadius = pulseProgress! * size.longestSide * 1.5;
      final pulseOpacity = (1.0 - pulseProgress!) * 0.15;
      final pulsePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = pulseColor.withValues(alpha: pulseOpacity);
      canvas.drawCircle(center, pulseRadius, pulsePaint);
    }

    for (final p in particles) {
      final t = p.progress;
      final current = Offset(
        p.position.dx + (p.target.dx - p.position.dx) * t,
        p.position.dy + (p.target.dy - p.position.dy) * t,
      );
      double opacity;
      if (starMode) {
        opacity = (0.5 + 0.5 * sin(t * 12.56 + p.twinklePhase)) * 0.8;
      } else {
        opacity = t < 0.5
            ? (t / 0.5) * 0.55
            : (1.0 - (t - 0.5) / 0.5) * 0.55;
      }
      final paint = Paint()
        ..color = (starMode ? starColor : particleColor).withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(current, p.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final bool starMode;
  const ParticleBackground({super.key, this.particleCount = 25, this.starMode = false});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  final _rand = Random();
  final _particles = <Particle>[];
  late AnimationController _controller;
  AnimationController? _pulseCtrl;
  Animation<double>? _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateParticles)..repeat();

    if (!widget.starMode) {
      _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 7),
      );
      _pulseAnim = CurvedAnimation(parent: _pulseCtrl!, curve: Curves.easeOut);
      _pulseCtrl!.repeat();
    }
  }

  void _updateParticles() {
    setState(() {
      while (_particles.length < widget.particleCount) {
        _spawnParticle();
      }
      for (var i = _particles.length - 1; i >= 0; i--) {
        _particles[i].progress += _particles[i].speed;
        if (_particles[i].progress >= 1.0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  void _spawnParticle() {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final sx = _rand.nextDouble() * sw;
    final sy = _rand.nextDouble() * sh;
    if (widget.starMode) {
      _particles.add(Particle(
        position: Offset(sx, sy),
        target: Offset(
          sx + (_rand.nextDouble() - 0.5) * 15,
          sy + (_rand.nextDouble() - 0.5) * 15,
        ),
        size: _rand.nextDouble() * 1.5 + 0.8,
        speed: 0.0005 + _rand.nextDouble() * 0.001,
      ));
    } else {
      _particles.add(Particle(
        position: Offset(sx, sy),
        target: Offset(
          sx + (_rand.nextDouble() - 0.5) * 220,
          sy + (_rand.nextDouble() - 0.5) * 220,
        ),
        size: _rand.nextDouble() * 3 + 1.5,
        speed: 0.003 + _rand.nextDouble() * 0.004,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final starColor = colors.secondary;
    final particleColor = colors.primary;
    final pulseColor = colors.secondary;

    return Positioned.fill(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _pulseAnim ?? _controller,
          builder: (_, _) => CustomPaint(
            painter: ParticlePainter(
              List<Particle>.from(_particles),
              _pulseAnim?.value,
              starMode: widget.starMode,
              starColor: starColor,
              particleColor: particleColor,
              pulseColor: pulseColor,
            ),
          ),
        ),
      ),
    );
  }
}
