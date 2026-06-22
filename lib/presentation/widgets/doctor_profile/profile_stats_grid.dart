import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

class ProfileStatsGrid extends StatelessWidget {
  final DoctorEntity doctor;
  final List<StatItem> Function()? extraStats;

  const ProfileStatsGrid({super.key, required this.doctor, this.extraStats});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final defaultStats = [
      StatItem(label: AppStrings.experience, value: '${doctor.experienceYears}+', icon: Icons.work_history_rounded, color: colors.primary),
      StatItem(label: AppStrings.doctorPatients, value: '${doctor.patientsCount}+', icon: Icons.people_rounded, color: colors.secondary),
      StatItem(label: AppStrings.surgeries, value: '${doctor.surgeriesCount}', icon: Icons.biotech_rounded, color: colors.primary),
    ];

    final stats = extraStats?.call() ?? defaultStats;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: stats.length > 3 ? 4 : 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stat.icon, color: stat.color, size: 18),
              const SizedBox(height: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    stat.value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.textPrimary),
                  ),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    stat.label,
                    style: TextStyle(fontSize: 11, color: colors.textLight),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const StatItem({required this.label, required this.value, required this.icon, required this.color});
}
