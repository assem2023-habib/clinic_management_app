import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class DpSecurityFooter extends StatelessWidget {
  const DpSecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: colors.glassHighlight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(Icons.lock, '\u062e\u0635\u0648\u0635\u064a\u0629 AI', '\u0645\u0634\u0641\u0631 \u062a\u0645\u0627\u0645\u0627\u064b', colors),
          _buildItem(Icons.verified_user, '\u062a\u0634\u0641\u064a\u0631 PDF', '\u0645\u0639\u064a\u0627\u0631 \u0637\u0628\u064a \u0639\u0627\u0644', colors),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle, AppColorSet colors) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: colors.surfaceDark,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Icon(icon, size: 16, color: colors.textPrimary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(
              fontFamily: 'Sora', fontSize: 10, fontWeight: FontWeight.w600, color: colors.textPrimary,
            )),
            Text(subtitle, style: const TextStyle(
              fontFamily: 'Sora', fontSize: 8, fontWeight: FontWeight.w600, color: colors.textMuted,
            )),
          ],
        ),
      ],
    );
  }
}
