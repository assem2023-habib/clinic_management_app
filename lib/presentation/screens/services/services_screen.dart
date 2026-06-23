import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_search_bar.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_category_grid.dart';
import 'package:clinic_management_app/presentation/screens/services/widgets/sr_featured_banner.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AppShell(
      useGlassAppBar: true,
      glassTitle: AppStrings.srMedicalServices,
      glassTrailing: CircleAvatar(
        radius: 20,
        backgroundColor: colors.cardBg.withValues(alpha: 0.6),
        child: IconButton(
          icon: Icon(Icons.notifications_outlined, color: colors.primary, size: AppSpacing.iconMedium),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colors.divider.withValues(alpha: 0.08)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            if (i == 2) {
              Navigator.pushNamed(context, AppRoutes.medicalRecords);
            }
          },
          backgroundColor: colors.bottomNavBg,
          selectedItemColor: colors.bottomNavSelected,
          unselectedItemColor: colors.bottomNavUnselected,
          type: BottomNavigationBarType.fixed,
          items:  [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: AppStrings.srBottomHome),
            BottomNavigationBarItem(icon: Icon(Icons.medical_services_rounded), label: AppStrings.srBottomServices),
            BottomNavigationBarItem(icon: Icon(Icons.description_rounded), label: AppStrings.srBottomRecords),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: AppStrings.srBottomAccount),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
