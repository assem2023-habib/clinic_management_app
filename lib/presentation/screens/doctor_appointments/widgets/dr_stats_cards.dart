import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class DrStatsCards extends StatelessWidget {
  final int totalToday;
  final int waitingPatients;
  final int emergencyCount;
  final int availableDoctors;
  final int totalDoctors;

  const DrStatsCards({
    super.key,
    required this.totalToday,
    required this.waitingPatients,
    this.emergencyCount = 0,
    this.availableDoctors = 0,
    this.totalDoctors = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        _buildCard(
          context,
          icon: Icons.calendar_today_rounded,
          label: AppStrings.daTotalApptsToday,
          value: totalToday.toString().padLeft(2, '0'),
          valueColor: colors.primary,
          trailing: Text('+12% ${AppStrings.daFromYesterday}',
            style: TextStyle(fontSize: 11, color: colors.secondary)),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCard(
          context,
          icon: Icons.group_rounded,
          label: AppStrings.daPatientsWaiting,
          value: waitingPatients.toString().padLeft(2, '0'),
          valueColor: colors.textPrimary,
          trailing: Text('$emergencyCount ${AppStrings.daEmergencyCases}',
            style: TextStyle(fontSize: 11, color: colors.error)),
          highlightBorder: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCard(
          context,
          icon: Icons.medical_services_rounded,
          label: AppStrings.daAvailableDoctors,
          value: availableDoctors.toString().padLeft(2, '0'),
          valueColor: colors.primary,
          trailing: Text('${AppStrings.daOutOf} $totalDoctors',
            style: TextStyle(fontSize: 11, color: colors.textLight)),
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required Widget trailing,
    bool highlightBorder = false,
  }) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: highlightBorder
              ? colors.primary.withValues(alpha: 0.3)
              : colors.divider.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: colors.textLight)),
              Icon(icon, color: colors.primary, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: valueColor, height: 1)),
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: trailing,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
