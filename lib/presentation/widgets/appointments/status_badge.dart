import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/timeline_painter.dart';

class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;
  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = status.uiColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(status.uiIcon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(status.label,
          style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}
