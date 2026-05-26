import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_search_bar.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_category_grid.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_featured_banner.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          const SrSearchBar(),
          const SizedBox(height: AppSpacing.md),
          const SrCategoryGrid(),
          const SizedBox(height: AppSpacing.md),
          const SrFeaturedBanner(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
