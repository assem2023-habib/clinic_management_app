import 'dart:math';
import 'package:flutter/material.dart';
import '../patient_welcome_painters.dart';

double _pulseScale(double t) => 1.0 + sin(t * 2 * pi) * 0.5;
double _pulseAlpha(double t) => 0.1 + sin(t * 2 * pi).abs() * 0.3;

void updatePwParticles(List<PwParticleData> particles, Size size) {
  for (final p in particles) {
    p.x += p.speedX;
    p.y += p.speedY;
    if (p.x < 0 || p.x > size.width || p.y < 0 || p.y > size.height) {
      final rng = PwSeededRandom(
        (p.x * 9999 + p.y * 9999).abs().toInt() % 100000 + 1,
      );
      p.x = rng.next() * size.width;
      p.y = rng.next() * size.height;
      p.size = rng.next() * 2 + 0.5;
      p.speedX = (rng.next() - 0.5) * 0.3;
      p.speedY = (rng.next() - 0.5) * 0.3;
      p.opacity = rng.next() * 0.5 + 0.2;
    }
  }
}

class PwBackground extends StatelessWidget {
  final AnimationController controller;
  final List<PwParticleData> particles;
  final Size size;

  const PwBackground({
    super.key,
    required this.controller,
    required this.particles,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        updatePwParticles(particles, size);
        final t = controller.value;
        return Stack(
          children: [
            Positioned(
              left: size.width * 0.25 - 300,
              top: size.height * 0.25 - 300,
              child: Transform.scale(
                scale: _pulseScale(t),
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      colors: [
                        const Color(0xFF4EDEA3).withValues(alpha: _pulseAlpha(t)),
                        const Color(0xFF4EDEA3).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: size.width * 0.75 - 200,
              top: size.height * 0.75 - 200,
              child: Transform.scale(
                scale: _pulseScale((t + 0.5) % 1.0),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      colors: [
                        const Color(0xFF10B981).withValues(alpha: _pulseAlpha((t + 0.5) % 1.0)),
                        const Color(0xFF10B981).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: PwParticlePainter(particles),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
