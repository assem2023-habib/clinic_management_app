import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class EmptyDataAction {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const EmptyDataAction({required this.label, this.icon, this.onTap});
}

class EmptyDataWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final EmptyDataAction? action;
  final bool compact;

  const EmptyDataWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (compact) {
      return _buildCompact(context, colors);
    }
    return _buildFull(context, colors);
  }

  Widget _buildCompact(BuildContext context, AppColorSet colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(colors, large: false),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 13, color: colors.textLight),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.md),
              _buildActionButton(context, colors),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context, AppColorSet colors) {
    final size = MediaQuery.of(context).size.width * 0.3;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size * 2,
                height: size * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.secondary.withValues(alpha: 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: colors.secondary.withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(icon, size: size, color: colors.secondary.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        subtitle!,
                        style: TextStyle(fontSize: 15, color: colors.textSecondary, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (action != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _buildActionButton(context, colors),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(AppColorSet colors, {required bool large}) {
    final iconSize = large ? 64.0 : 48.0;
    return Container(
      width: iconSize * 1.5,
      height: iconSize * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.cardBg.withValues(alpha: 0.5),
      ),
      child: Icon(icon, size: iconSize, color: colors.textLight.withValues(alpha: 0.3)),
    );
  }

  Widget _buildActionButton(BuildContext context, AppColorSet colors) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action!.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00FF85),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (action!.icon != null) ...[
              Icon(action!.icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(action!.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
