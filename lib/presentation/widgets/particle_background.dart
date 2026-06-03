import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset target;
  double size;
  double progress;
  double speed;
  Particle({
    required this.position,
    required this.target,
    required this.size,
    required this.speed,
  }) : progress = 0;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double pulseProgress;

  ParticlePainter(this.particles, this.pulseProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pulseRadius = pulseProgress * size.longestSide * 1.5;
    final pulseOpacity = (1.0 - pulseProgress) * 0.15;
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF40E78C).withValues(alpha: pulseOpacity);
    canvas.drawCircle(center, pulseRadius, pulsePaint);

    for (final p in particles) {
      final t = p.progress;
      final current = Offset(
        p.position.dx + (p.target.dx - p.position.dx) * t,
        p.position.dy + (p.target.dy - p.position.dy) * t,
      );
      final opacity = t < 0.5
          ? (t / 0.5) * 0.55
          : (1.0 - (t - 0.5) / 0.5) * 0.55;
      final paint = Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(current, p.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  const ParticleBackground({super.key, this.particleCount = 25});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  final _rand = Random();
  final _particles = <Particle>[];
  late AnimationController _controller;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateParticles)..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut);
    _pulseCtrl.repeat();
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

  @override
  void dispose() {
    _controller.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => CustomPaint(
            painter: ParticlePainter(
              List<Particle>.from(_particles),
              _pulseAnim.value,
            ),
          ),
        ),
      ),
    );
  }
}
