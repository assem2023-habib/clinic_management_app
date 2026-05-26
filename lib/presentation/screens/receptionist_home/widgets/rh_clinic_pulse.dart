import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class RhClinicPulse extends StatelessWidget {
  final int totalAppts;
  final int checkedIn;
  final int inProgress;
  final int pending;

  const RhClinicPulse({
    super.key,
    required this.totalAppts,
    required this.checkedIn,
    required this.inProgress,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final (icon, label, value, color) = _stats(colors)[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBg.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: color, height: 1),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<(IconData, String, String, Color)> _stats(AppColorSet colors) => [
    (Icons.calendar_today_rounded, AppStrings.rhTotalAppts, totalAppts.toString().padLeft(2, '0'), colors.primary),
    (Icons.check_circle_rounded, AppStrings.rhCheckedIn, checkedIn.toString().padLeft(2, '0'), colors.secondary),
    (Icons.hourglass_empty_rounded, AppStrings.rhQueueInProgress, inProgress.toString().padLeft(2, '0'), colors.warning),
    (Icons.pending_actions_rounded, AppStrings.rhQueuePending, pending.toString().padLeft(2, '0'), colors.textLight),
  ];
}
