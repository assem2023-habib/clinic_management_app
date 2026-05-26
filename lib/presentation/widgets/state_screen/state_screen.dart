import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class StateAction {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  const StateAction({
    required this.label,
    this.icon,
    this.onTap,
    this.isPrimary = true,
  });
}

class StatusChip {
  final IconData icon;
  final String label;

  const StatusChip({required this.icon, required this.label});
}

class StateScreen extends StatelessWidget {
  final Widget? illustration;
  final IconData? icon;
  final String title;
  final String message;
  final StateAction? primaryAction;
  final StateAction? secondaryAction;
  final List<StatusChip>? statusChips;
  final bool showAppBar;
  final String? appBarTitle;
  final Widget? bottomWidget;

  const StateScreen({
    super.key,
    this.illustration,
    this.icon,
    required this.title,
    required this.message,
    this.primaryAction,
    this.secondaryAction,
    this.statusChips,
    this.showAppBar = true,
    this.appBarTitle,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (showAppBar) _buildAppBar(context, colors),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      _buildIllustration(context),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildCard(context, colors),
                      if (statusChips != null || bottomWidget != null) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        if (statusChips != null) _buildStatusRow(colors),
                        if (bottomWidget != null) bottomWidget!,
                      ],
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorSet colors) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.appBarBg.withValues(alpha: 0.7),
        border: Border(bottom: BorderSide(color: colors.divider.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          if (Navigator.of(context).canPop())
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_back_rounded, color: colors.textPrimary, size: 24),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          const Spacer(),
          Text(
            appBarTitle ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final colors = AppColors.of(context);
    final size = MediaQuery.of(context).size.width * 0.55;

    if (illustration != null) {
      return SizedBox(width: size, height: size, child: illustration);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.secondary.withValues(alpha: 0.05),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.1),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(
        icon ?? Icons.error_outline_rounded,
        size: size * 0.45,
        color: colors.secondary.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildCard(BuildContext context, AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: colors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          if (primaryAction != null || secondaryAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            if (primaryAction != null) _buildPrimaryButton(colors),
            if (primaryAction != null && secondaryAction != null)
              const SizedBox(height: AppSpacing.sm),
            if (secondaryAction != null) _buildSecondaryButton(colors),
          ],
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(AppColorSet colors) {
    final isEnabled = primaryAction!.onTap != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? primaryAction!.onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00FF85),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          shadowColor: const Color(0xFF00FF85).withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (primaryAction!.icon != null) ...[
              Icon(primaryAction!.icon, size: 22),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              primaryAction!.label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(AppColorSet colors) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: secondaryAction!.onTap,
        style: TextButton.styleFrom(
          foregroundColor: colors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (secondaryAction!.icon != null) ...[
              Icon(secondaryAction!.icon, size: 22),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              secondaryAction!.label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(AppColorSet colors) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: statusChips!.map((chip) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(chip.icon, size: 14, color: colors.textLight.withValues(alpha: 0.4)),
            const SizedBox(width: 4),
            Text(
              chip.label,
              style: TextStyle(fontSize: 12, color: colors.textLight.withValues(alpha: 0.4)),
            ),
          ],
        );
      }).toList(),
    );
  }
}
