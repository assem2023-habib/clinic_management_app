import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_category_card.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class SrCategoryGrid extends StatelessWidget {
  const SrCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
Text(
              AppStrings.srCategories,
              style: TextStyle(fontSize: AppSpacing.heading, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            TextButton(
              onPressed: () {},
              child: Text(AppStrings.srViewAll, style: TextStyle(color: colors.primary, fontSize: AppSpacing.caption)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.9,
          children: [
            SrCategoryCard(icon: AppIcons.favorite, label: AppStrings.srCardiology, onTap: () {}),
            SrCategoryCard(icon: AppIcons.medicalServices, label: AppStrings.srDental, onTap: () {}),
            SrCategoryCard(icon: AppIcons.childCare, label: AppStrings.srPediatrics, onTap: () {}),
            SrCategoryCard(icon: AppIcons.accessibility, label: AppStrings.srOrthopedics, onTap: () {}),
            SrCategoryCard(icon: AppIcons.visibility, label: AppStrings.srOphthalmology, onTap: () {}),
            SrCategoryCard(icon: AppIcons.psychology, label: AppStrings.srNeurology, onTap: () {}),
          ],
        ),
      ],
    );
  }
}
