import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? value;

  const StatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.six),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSpacing.iconSmall, color: color),
              if (value != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(value!, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.bold, color: color)),
              ],
              const SizedBox(height: AppSpacing.xxs),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}

