import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/state_screen/state_screen.dart';

class ServerErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return StateScreen(
      showAppBar: true,
      appBarTitle: AppStrings.appName,
      icon: AppIcons.dns,
      title: AppStrings.seTitle,
      message: AppStrings.seMessage,
      primaryAction: StateAction(
        label: AppStrings.seRetry,
        icon: AppIcons.refresh,
        onTap: onRetry,
      ),
      secondaryAction: StateAction(
        label: AppStrings.seGoHome,
        isPrimary: false,
        onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
      ),
      statusChips:  [
        StatusChip(icon: AppIcons.cloudOff, label: AppStrings.seServerBusy),
        StatusChip(icon: AppIcons.refresh, label: AppStrings.seTryAgain),
      ],
    );
  }
}
