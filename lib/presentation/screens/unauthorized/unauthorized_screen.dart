import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'unauthorized_painters.dart';
import 'widgets/ua_icon_section.dart';
import 'widgets/ua_content.dart';
import 'widgets/ua_actions.dart';
import 'widgets/ua_data_nodes.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class UnauthorizedScreen extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onGoHome;

  const UnauthorizedScreen({
    super.key,
    this.onLogin,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: UaParticlePainter(),
                ),
              ),
            ),
            Column(
              children: [
                _buildAppBar(context, colors),
                Expanded(child: _buildContent()),
                _buildFooter(colors),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorSet colors) {
    return Container(
      width: double.infinity,
      height: AppSpacing.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: AppSpacing.iconContainer,
              height: AppSpacing.iconContainer,
              alignment: Alignment.center,
              child: Icon(
                AppIcons.forward,
                color: colors.textPrimary,
                size: AppSpacing.iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppSpacing.xl + AppSpacing.sm),
            const UaIconSection(),
            SizedBox(height: AppSpacing.xl + AppSpacing.sm),
            const UaContent(),
            const SizedBox(height: AppSpacing.xl),
            UaActions(onLogin: onLogin, onGoHome: onGoHome),
            const SizedBox(height: AppSpacing.xl),
            const UaDataNodes(),
            SizedBox(height: AppSpacing.xl + AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white, width: 0.5)),
      ),
      child: Text(
        AppStrings.uaFooter,
        style: TextStyle(
          fontSize: AppSpacing.bodySmall,
          fontWeight: FontWeight.w600,
          color: colors.sage,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
