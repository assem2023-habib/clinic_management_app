import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:clinic_management_app/core/painters/painters.dart';
import 'package:clinic_management_app/presentation/widgets/state_screen/state_screen.dart';

class ForbiddenScreen extends StatelessWidget {
  final VoidCallback? onContactSupport;

  const ForbiddenScreen({super.key, this.onContactSupport});

  @override
  Widget build(BuildContext context) {
    return StateScreen(
      showAppBar: true,
      appBarTitle: AppStrings.appName,
      background: ParticleLayer(
        color: AppColors.dark.emerald,
        particleCount: 30,
        minRadius: 0.5,
        maxRadius: 2.0,
        minAlpha: 0.1,
        maxAlpha: 0.2,
      ),
      icon: AppIcons.shield,
      title: AppStrings.fbTitle,
      message: AppStrings.fbMessage,
      primaryAction: StateAction(
        label: AppStrings.fbGoHome,
        icon: AppIcons.home,
        onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
      ),
      secondaryAction: StateAction(
        label: AppStrings.fbContactSupport,
        icon: AppIcons.supportAgent,
        isPrimary: false,
        onTap: onContactSupport,
      ),
    );
  }
}
