import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PsFooter extends StatelessWidget {
  final VoidCallback? onGoToSettings;
  final VoidCallback? onTryLater;

  const PsFooter({super.key, this.onGoToSettings, this.onTryLater});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGoToSettings ?? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يَرْجَى تَفْعِيلُ الصَّلاحِيَاتِ مِنْ إِعْدَادَاتِ الجِهَازِ', textAlign: TextAlign.center),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: colors.surfaceDense,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.emerald.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide(color: colors.mint.withValues(alpha: 0.3)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: 20, color: colors.mint),
                  SizedBox(width: 8),
                  Text('الذَّهَابُ لِلإِعْدَادَاتِ', style: TextStyle(fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w600, color: colors.mint)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onTryLater ?? () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide(color: colors.mint.withValues(alpha: 0.3)),
              ),
              child: const Text('المُحَاوَلَةُ لَاحِقاً', style: TextStyle(fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w400, color: colors.mint)),
            ),
          ),
        ],
      ),
    );
  }
}
