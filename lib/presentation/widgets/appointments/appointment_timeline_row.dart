import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/timeline_painter.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/appointment_card.dart';

class AppointmentTimelineRow extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onMoreTap;
  final VoidCallback? onTap;
  final bool isFeatured;
  final bool isPast;

  const AppointmentTimelineRow({
    super.key,
    required this.appointment,
    this.isFirst = false,
    this.isLast = false,
    this.onMoreTap,
    this.onTap,
    this.isFeatured = false,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 38,
            child: CustomPaint(
              painter: TimelinePainter(
                status: appointment.status,
                isFirst: isFirst,
                isLast: isLast,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateLabel(appointment: appointment),
                  const SizedBox(height: 6),
                  AppointmentCard(
                    appointment: appointment,
                    isFeatured: isFeatured,
                    isPast: isPast,
                    onMoreTap: onMoreTap,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  final AppointmentEntity appointment;
  const _DateLabel({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final dateStr = appointment.date ?? appointment.appointmentDate;
    final dateTime = dateStr != null ? DateTime.tryParse(dateStr) : null;

    String label;
    bool isUpcoming = false;

    if (dateTime != null) {
      final now = DateTime.now();
      final diff = dateTime.difference(DateTime(now.year, now.month, now.day)).inDays;
      if (diff == 0) {
        label = AppStrings.today;
        isUpcoming = true;
      } else if (diff == 1) {
        label = 'غداً';
        isUpcoming = true;
      } else if (diff < 7 && diff > 0) {
        final days = [
          AppStrings.dayMonday, AppStrings.dayTuesday, AppStrings.dayWednesday,
          AppStrings.dayThursday, AppStrings.dayFriday, AppStrings.daySaturday,
          AppStrings.daySunday,
        ];
        label = '${days[dateTime.weekday - 1]} • ${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}';
        isUpcoming = true;
      } else {
        label = '${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}';
        isUpcoming = false;
      }
    } else {
      label = dateStr ?? '';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Text(label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isUpcoming ? c.primary : c.textSecondary,
        ),
      ),
    );
  }

  String _monthName(int m) {
    final months = [
      '', AppStrings.monthJan, AppStrings.monthFeb, AppStrings.monthMar,
      AppStrings.monthApr, AppStrings.monthMay, AppStrings.monthJun,
      AppStrings.monthJul, AppStrings.monthAug, AppStrings.monthSep,
      AppStrings.monthOct, AppStrings.monthNov, AppStrings.monthDec,
    ];
    return months[m];
  }
}
