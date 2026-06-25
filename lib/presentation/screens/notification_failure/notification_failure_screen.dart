import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/presentation/screens/notification_failure/widgets/nf_actions.dart';
import 'package:clinic_management_app/presentation/screens/notification_failure/widgets/nf_content_card.dart';
import 'package:clinic_management_app/presentation/screens/notification_failure/widgets/nf_icon_section.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class NotificationFailureScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const NotificationFailureScreen({super.key, this.onRetry, this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.iconSmall, vertical: AppSpacing.sm + AppSpacing.xs),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(AppIcons.back, color: colors.textMuted),
                    onPressed: onBack ?? () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    AppStrings.ntTitle,
                    style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary),
                  ),
                  const SizedBox(width: AppSpacing.xxl),
                ],
              ),
            ),
            const Spacer(flex: 2),
            const NfIconSection(),
            const SizedBox(height: AppSpacing.xl),
            NfContentCard(
              title: AppStrings.notificationSendFailed,
              message: AppStrings.notificationFailureMsg,
            ),
            const Spacer(flex: 3),
            NfActions(onRetry: onRetry, onBack: onBack),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

