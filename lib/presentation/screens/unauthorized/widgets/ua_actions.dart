import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class UaActions extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onGoHome;

  const UaActions({
    super.key,
    this.onLogin,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        SizedBox(
          width: 280,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: onLogin ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.login),
            icon: Icon(Icons.login_rounded, size: AppSpacing.iconSmall + 2),
            label:  Text(AppStrings.uaLogin),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.neonGreen,
              foregroundColor: colors.buttonTextDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
              shadowColor: colors.neonGreen.withValues(alpha: 0.3),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        SizedBox(
          width: 280,
          height: AppSpacing.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: onGoHome ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.dashboard),
            icon: Icon(Icons.home_rounded, size: AppSpacing.iconSmall + 2),
            label:  Text(AppStrings.uaGoHome),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
