import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SrFeaturedBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const SrFeaturedBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD1_sPJ1vjXIQYZtvyY13cqgMuQxWC_EcVh_sYOhkLuTIWI4lIZ-4eMauslmybMBnXMWt91M8K4n-Pvkc7QNuL0jOroiFHXvWuSyWj5yi6ZCjDASsaO0-ujeKqjs8_XqBTPXgHIRbOZU0D1Dw9IyOMOF6mqx0TIGEk3lZ5ZYkHOcmvab7yx0WOzBttpnIF9n7093h07sSx5J2UIQnsGJNiko9WyqCuMpgHhILZ-uuK_EbTsJ_BPlhBcnUuHbsImOsqAA2DndewtZVk',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      colors.cardBg.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    AppStrings.srBannerTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
Text(
                    AppStrings.srBannerSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

