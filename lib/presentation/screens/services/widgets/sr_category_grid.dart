import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_category_card.dart';

class SrCategoryGrid extends StatelessWidget {
  const SrCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.srCategories,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFC6EBD1)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(AppStrings.srViewAll, style: TextStyle(color: Color(0xFF80D8A6), fontSize: 13)),
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
            SrCategoryCard(icon: Icons.favorite_rounded, label: AppStrings.srCardiology, onTap: () {}),
            SrCategoryCard(icon: Icons.medical_services_rounded, label: AppStrings.srDental, onTap: () {}),
            SrCategoryCard(icon: Icons.child_care_rounded, label: AppStrings.srPediatrics, onTap: () {}),
            SrCategoryCard(icon: Icons.accessibility_rounded, label: AppStrings.srOrthopedics, onTap: () {}),
            SrCategoryCard(icon: Icons.visibility_rounded, label: AppStrings.srOphthalmology, onTap: () {}),
            SrCategoryCard(icon: Icons.psychology_rounded, label: AppStrings.srNeurology, onTap: () {}),
          ],
        ),
      ],
    );
  }
}
