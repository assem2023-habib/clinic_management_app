import 'package:flutter/material.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class TimelinePainter extends CustomPainter {
  final AppointmentStatus status;
  final bool isFirst;
  final bool isLast;

  const TimelinePainter({
    required this.status,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const lineX = 19.0;
    const dotY = 22.0;

    if (!isLast) {
      final linePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF006D44), const Color(0xFF006D44).withValues(alpha: 0.15)],
        ).createShader(Rect.fromLTWH(lineX, dotY, 2, size.height - dotY))
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(lineX, dotY + 8),
        Offset(lineX, size.height),
        linePaint,
      );
    }

    switch (_uiStatus(status)) {
      case _UiStatus.confirmed:
        canvas.drawCircle(
          Offset(lineX, dotY), 7,
          Paint()..color = const Color(0xFF80D8A6)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawCircle(Offset(lineX, dotY), 7, Paint()..color = const Color(0xFF80D8A6));
        canvas.drawCircle(
          Offset(lineX, dotY), 10,
          Paint()..color = const Color(0xFF00180B)..style = PaintingStyle.stroke..strokeWidth = 3,
        );

      case _UiStatus.pending:
        canvas.drawCircle(
          Offset(lineX, dotY), 5,
          Paint()..color = const Color(0xFF88938A),
        );

      case _UiStatus.completed:
        canvas.drawCircle(
          Offset(lineX, dotY), 4,
          Paint()..color = const Color(0xFFBEC9BF).withValues(alpha: 0.6),
        );

      case _UiStatus.cancelled:
        canvas.drawCircle(
          Offset(lineX, dotY), 5,
          Paint()..color = const Color(0xFFFFB4AB).withValues(alpha: 0.7),
        );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

enum _UiStatus { confirmed, pending, completed, cancelled }

_UiStatus _uiStatus(AppointmentStatus s) {
  return switch (s) {
    AppointmentStatus.confirmed || AppointmentStatus.accepted || AppointmentStatus.set || AppointmentStatus.scheduled => _UiStatus.confirmed,
    AppointmentStatus.pending || AppointmentStatus.requested => _UiStatus.pending,
    AppointmentStatus.completed => _UiStatus.completed,
    AppointmentStatus.cancelled || AppointmentStatus.rejected => _UiStatus.cancelled,
    AppointmentStatus.inProgress => _UiStatus.confirmed,
  };
}

extension AppointmentStatusUI on AppointmentStatus {
  String get label {
    return switch (this) {
      AppointmentStatus.confirmed || AppointmentStatus.accepted || AppointmentStatus.set || AppointmentStatus.scheduled => 'مؤكد',
      AppointmentStatus.pending || AppointmentStatus.requested => 'قيد الانتظار',
      AppointmentStatus.completed => 'مكتمل',
      AppointmentStatus.cancelled || AppointmentStatus.rejected => 'ملغي',
      AppointmentStatus.inProgress => 'قيد التنفيذ',
    };
  }

  Color get uiColor {
    return switch (this) {
      AppointmentStatus.confirmed || AppointmentStatus.accepted || AppointmentStatus.set || AppointmentStatus.scheduled => const Color(0xFF80D8A6),
      AppointmentStatus.pending || AppointmentStatus.requested => const Color(0xFFFFB3B1),
      AppointmentStatus.completed => const Color(0xFF40E78C),
      AppointmentStatus.cancelled || AppointmentStatus.rejected => const Color(0xFFFFB4AB),
      AppointmentStatus.inProgress => const Color(0xFF80D8A6),
    };
  }

  IconData get uiIcon {
    return switch (this) {
      AppointmentStatus.confirmed || AppointmentStatus.accepted || AppointmentStatus.set || AppointmentStatus.scheduled => Icons.check_circle,
      AppointmentStatus.pending || AppointmentStatus.requested => Icons.schedule,
      AppointmentStatus.completed => Icons.done_all,
      AppointmentStatus.cancelled || AppointmentStatus.rejected => Icons.cancel,
      AppointmentStatus.inProgress => Icons.check_circle,
    };
  }
}
