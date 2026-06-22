import 'package:clinic_management_app/core/constants/app_colors.dart';
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
          colors: [AppColors.dark.primaryDark, AppColors.dark.primaryDark.withValues(alpha: 0.15)],
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
          Paint()..color = AppColors.dark.primary..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawCircle(Offset(lineX, dotY), 7, Paint()..color = AppColors.dark.primary);
        canvas.drawCircle(
          Offset(lineX, dotY), 10,
          Paint()..color = AppColors.dark.scaffoldBg..style = PaintingStyle.stroke..strokeWidth = 3,
        );

      case _UiStatus.pending:
        canvas.drawCircle(
          Offset(lineX, dotY), 5,
          Paint()..color = AppColors.dark.textLight,
        );

      case _UiStatus.completed:
        canvas.drawCircle(
          Offset(lineX, dotY), 4,
          Paint()..color = AppColors.dark.divider.withValues(alpha: 0.6),
        );

      case _UiStatus.cancelled:
        canvas.drawCircle(
          Offset(lineX, dotY), 5,
          Paint()..color = AppColors.dark.error.withValues(alpha: 0.7),
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
      AppointmentStatus.confirmed || AppointmentStatus.accepted || AppointmentStatus.set || AppointmentStatus.scheduled => AppColors.dark.primary,
      AppointmentStatus.pending || AppointmentStatus.requested => AppColors.dark.warning,
      AppointmentStatus.completed => AppColors.dark.secondary,
      AppointmentStatus.cancelled || AppointmentStatus.rejected => AppColors.dark.error,
      AppointmentStatus.inProgress => AppColors.dark.primary,
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
