import 'package:clinic_management_app/core/constants/app_icons.dart';
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
                  radius: AppSpacing.avatarMedium,
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  backgroundImage: doctor.imageUrl != null
                      ? NetworkImage(doctor.imageUrl!)
                      : null,
                  child: doctor.imageUrl == null
                      ? Icon(AppIcons.person, size: AppSpacing.avatarMedium, color: colors.primary)
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
                      style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs / 2),
                    Text(
                      doctor.specialty,
                      style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.secondary),
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
            AppIcons.calendarToday,
            AppStrings.historyLabel,
            _formatDate(data.date),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          _buildDetailRow(
            context,
            AppIcons.schedule,
            AppStrings.timeLabel,
            _formatTime(data.timeSlot),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          _buildDetailRow(
            context,
            AppIcons.locationOn,
            AppStrings.location,
            '${doctor.clinicName ?? AppStrings.clinic}\n${doctor.clinicAddress ?? ''}',
            isMultiLine: true,
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: Container(
              width: double.infinity,
              height: AppSpacing.confirmationIconSize + AppSpacing.xs,
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(AppIcons.map, size: AppSpacing.xxl, color: colors.textLight.withValues(alpha: 0.3)),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(AppIcons.locationOn, color: colors.primary, size: AppSpacing.lg),
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
            padding: const EdgeInsets.all(AppSpacing.sm - 2),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: colors.divider.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, size: AppSpacing.titleMedium, color: colors.primary),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textLight)),
            const SizedBox(height: AppSpacing.xxs),
            isMultiLine
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: value.split('\n').map((line) => Text(
                      line,
                      style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textPrimary),
                    )).toList(),
                  )
                : Text(value, style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textPrimary)),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final dayNames = [AppStrings.dayMonday, AppStrings.dayTuesday, AppStrings.dayWednesday, AppStrings.dayThursday, AppStrings.dayFriday, AppStrings.daySaturday, AppStrings.daySunday];
    final monthNames = [
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
