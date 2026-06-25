import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/utils/seeded_random.dart';
import 'package:flutter/material.dart';
import '../suspended_painters.dart';

double _pulseScale(double t) {
  return 1.0 + (t < 0.5 ? t * 2 : 2.0 - t * 2) * 0.5;
}

double _pulseAlpha(double t) {
  return 0.1 + (t < 0.5 ? t * 2 : 2.0 - t * 2) * 0.3;
}

void _updateParticles(List<ParticleData> particles, Size size) {
  for (final p in particles) {
    p.x += p.speedX;
    p.y += p.speedY;
    if (p.x < 0 || p.x > size.width || p.y < 0 || p.y > size.height) {
      final rng = SeededRandom(
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

class SpBackground extends StatelessWidget {
  final AnimationController particleController;
  final AnimationController pulseController;
  final List<ParticleData> particles;
  final Size size;

  const SpBackground({
    super.key,
    required this.particleController,
    required this.pulseController,
    required this.particles,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([particleController, pulseController]),
      builder: (context, child) {
        _updateParticles(particles, size);
        final t1 = pulseController.value;
        final t2 = (t1 + 0.5) % 1.0;
        return Stack(
          children: [
            Positioned(
              left: size.width * 0.25 - 300,
              top: size.height * 0.25 - 300,
              child: Transform.scale(
                scale: _pulseScale(t1),
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      colors: [
                        colors.mint
                            .withValues(alpha: _pulseAlpha(t1)),
                        colors.mint.withValues(alpha: 0.0),
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
                scale: _pulseScale(t2),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      colors: [
                        colors.mint
                            .withValues(alpha: _pulseAlpha(t2)),
                        colors.mint.withValues(alpha: 0.0),
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
                  painter: MovingParticlePainter(particles),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
