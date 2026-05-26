import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/state_screen/state_screen.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StateScreen(
      showAppBar: true,
      appBarTitle: AppStrings.appName,
      icon: Icons.wifi_off_rounded,
      title: AppStrings.olTitle,
      message: AppStrings.olMessage,
      primaryAction: StateAction(
        label: AppStrings.olRetry,
        icon: Icons.refresh_rounded,
        onTap: () {},
      ),
      secondaryAction: StateAction(
        label: AppStrings.olShowCached,
        isPrimary: false,
        onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
      ),
      statusChips: const [
        StatusChip(icon: Icons.wifi_off_rounded, label: AppStrings.olSignalLost),
        StatusChip(icon: Icons.dns_rounded, label: AppStrings.olServerUnreachable),
      ],
    );
  }
}
