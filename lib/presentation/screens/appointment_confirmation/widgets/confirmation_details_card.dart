import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';

class ConfirmationDetailsCard extends StatelessWidget {
  final ConfirmationData data;

  const ConfirmationDetailsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final doctor = data.doctor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  backgroundImage: doctor.imageUrl != null
                      ? NetworkImage(doctor.imageUrl!)
                      : null,
                  child: doctor.imageUrl == null
                      ? Icon(Icons.person_rounded, size: 28, color: colors.primary)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: TextStyle(fontSize: 14, color: colors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: colors.divider.withValues(alpha: 0.2)),
          const SizedBox(height: AppSpacing.md),
          _buildDetailRow(
            context,
            Icons.calendar_today_rounded,
            AppStrings.historyLabel,
            _formatDate(data.date),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            Icons.schedule_rounded,
            AppStrings.timeLabel,
            _formatTime(data.timeSlot),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            Icons.location_on_rounded,
            AppStrings.location,
            '${doctor.clinicName ?? AppStrings.clinic}\n${doctor.clinicAddress ?? ''}',
            isMultiLine: true,
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.map_rounded, size: AppSpacing.xxl, color: colors.textLight.withValues(alpha: 0.3)),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on_rounded, color: colors.primary, size: AppSpacing.lg),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isMultiLine = false,
  }) {
    final colors = AppColors.of(context);
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: colors.divider.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: colors.textLight)),
            const SizedBox(height: 2),
            isMultiLine
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: value.split('\n').map((line) => Text(
                      line,
                      style: TextStyle(fontSize: 14, color: colors.textPrimary),
                    )).toList(),
                  )
                : Text(value, style: TextStyle(fontSize: 14, color: colors.textPrimary)),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const dayNames = [AppStrings.dayMonday, AppStrings.dayTuesday, AppStrings.dayWednesday, AppStrings.dayThursday, AppStrings.dayFriday, AppStrings.daySaturday, AppStrings.daySunday];
    const monthNames = [
      AppStrings.monthJan, AppStrings.monthFeb, AppStrings.monthMar, AppStrings.monthApr, AppStrings.monthMay, AppStrings.monthJun,
      AppStrings.monthJul, AppStrings.monthAug, AppStrings.monthSep, AppStrings.monthOct, AppStrings.monthNov, AppStrings.monthDec
    ];
    return '${dayNames[date.weekday - 1]}، ${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    if (hour < 12) {
      return '$hour:$minute ${AppStrings.morningFull}';
    } else if (hour == 12) {
      return '12:$minute ${AppStrings.eveningFull}';
    } else {
      return '${hour - 12}:$minute ${AppStrings.eveningFull}';
    }
  }
}
