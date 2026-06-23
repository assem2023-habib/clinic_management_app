import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/presentation/screens/search_failure/widgets/sf_actions.dart';
import 'package:clinic_management_app/presentation/screens/search_failure/widgets/sf_content_card.dart';
import 'package:clinic_management_app/presentation/screens/search_failure/widgets/sf_icon_section.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class SearchFailureScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const SearchFailureScreen({super.key, this.onRetry, this.onBack});

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
                    'البَحْثُ',
                    style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary),
                  ),
                  const SizedBox(width: AppSpacing.xxl),
                ],
              ),
            ),
            const Spacer(flex: 2),
            const SfIconSection(),
            const SizedBox(height: AppSpacing.xl),
            const SfContentCard(
              title: 'فَشِلَتْ عَمَلِيَّةُ البَحْثِ',
              message: 'لَمْ نَتَمَكَّنْ مِنْ إِجْرَاءِ البَحْثِ فِي هَذِهِ اللَّحْظَةِ. يُرجَى التَّحَقُّقُ مِنْ صِحَّةِ بَيَانَاتِ البَحْثِ أَوِ المُحَاوَلَةِ لَاحِقاً.',
            ),
            const Spacer(flex: 3),
            SfActions(onRetry: onRetry, onBack: onBack),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

