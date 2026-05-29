import 'package:flutter/material.dart';
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
    return Column(
      children: [
        SizedBox(
          width: 280,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onLogin ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.login),
            icon: const Icon(Icons.login_rounded, size: 22),
            label: const Text(AppStrings.uaLogin),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF00422B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
              shadowColor: const Color(0xFF10B981).withValues(alpha: 0.3),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 280,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: onGoHome ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.dashboard),
            icon: const Icon(Icons.home_rounded, size: 22),
            label: const Text(AppStrings.uaGoHome),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC6EBD1),
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
