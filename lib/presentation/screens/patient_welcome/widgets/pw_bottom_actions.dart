import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class PwBottomActions extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onStart;
  final String startLabel;

  const PwBottomActions({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onStart,
    required this.startLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (i) {
              final isActive = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                width: isActive ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.mint
                      : colors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  boxShadow: isActive
                      ? [BoxShadow(
                          color: colors.emerald.withValues(alpha: 0.5),
                          blurRadius: 8,
                        )]
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.emerald,
                foregroundColor: colors.buttonBg,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
                elevation: 0,
                shadowColor: colors.emerald.withValues(alpha: 0.3),
              ),
              child: Text(
                startLabel,
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

