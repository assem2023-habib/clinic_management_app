import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final double progress;

  ClockPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final innerRadius = radius - 8;

    final shadowPaint = Paint()
      ..color = const Color(0xFF36FF8B).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, radius, shadowPaint);

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: const [
          Color(0xFF002111),
          Color(0xFF002111),
          Color(0xFF36FF8B),
          Color(0xFF36FF8B),
        ],
        stops: [0.0, progress, progress, 1.0],
      ).createShader(rect);

    canvas.drawCircle(center, radius - 1, sweepPaint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, borderPaint);

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi - pi / 2;
      final outer = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final inner = Offset(
        center.dx + innerRadius * cos(angle),
        center.dy + innerRadius * sin(angle),
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = const Color(0xFF002111).withValues(alpha: 0.5)
          ..strokeWidth = 2,
      );
    }

    final handAngle = -(1.0 - progress) * 2 * pi;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(handAngle);
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, -(radius * 0.45)),
      Paint()
        ..color = const Color(0xFF002111)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = const Color(0xFF002111)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;
    final paint = Paint()
      ..color = const Color(0xFF36FF8B).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashLength = 4.0;
    const gapLength = 8.0;
    final circumference = 2 * pi * radius;
    final totalSegments = circumference / (dashLength + gapLength);
    final adjustedDash = circumference / totalSegments - gapLength;

    for (double angle = 0; angle < 2 * pi; angle += (adjustedDash + gapLength) / radius) {
      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final endAngle = angle + adjustedDash / radius;
      final end = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = SeededRandom(42);
    for (var i = 0; i < 45; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 2.5 + 1.5;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = const Color(0xFF10B981)
              .withValues(alpha: 0.15 + rng.next() * 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SeededRandom {
  int _seed;
  SeededRandom(this._seed);

  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
