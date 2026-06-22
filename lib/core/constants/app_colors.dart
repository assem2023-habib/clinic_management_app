import 'package:flutter/material.dart';

class AppColors {
  static const light = VitalityLight();
  static const dark = VitalityDark();

  static AppColorSet of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}

abstract class AppColorSet {
  Color get primary;
  Color get primaryDark;
  Color get primaryLight;
  Color get secondary;
  Color get accent;
  Color get surface;
  Color get cardBg;
  Color get error;
  Color get warning;
  Color get success;
  Color get textPrimary;
  Color get textSecondary;
  Color get textLight;
  Color get divider;
  Color get shadow;
  Color get appBarBg;
  Color get appBarForeground;
  Color get inputBg;
  Color get bottomNavBg;
  Color get bottomNavSelected;
  Color get bottomNavUnselected;
  Color get chipBg;
  Color get chipText;
  Color get scaffoldBg;
  Color get skeletonBase;
  Color get skeletonShimmer;
  Color get neonGreen;
  Color get sage;
  Color get borderLight;
  Color get buttonFg;
  Color get emerald;
  Color get mint;
  Color get textMuted;
  Color get textDisabled;
  Color get borderDark;
  Color get buttonTextDark;
  Color get surfaceDark;
  Color get surfaceMedium;
  Color get surfaceDense;
  Color get buttonBg;
  Color get cardBorder;
  Color get purpleIcon;
  Color get iconGray;
  Color get iconGreen;
  Color get errorRed;
  Color get errorLight;
  Color get splashBg;
  Color get offlineBg;
  Color get glassBorder;
  Color get glassHighlight;
  Color get timelineBg;
  Color get verifiedIconBg;
}

class VitalityLight implements AppColorSet {
  const VitalityLight();

  @override
  Color get primary => const Color(0xFF006D44);

  @override
  Color get primaryDark => const Color(0xFF005232);

  @override
  Color get primaryLight => const Color(0xFF93ECB8);

  @override
  Color get secondary => const Color(0xFF55615C);

  @override
  Color get accent => const Color(0xFF006E28);

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get cardBg => const Color(0xFFFFFFFF);

  @override
  Color get error => const Color(0xFFBA1A1A);

  @override
  Color get warning => const Color(0xFFF59E0B);

  @override
  Color get success => const Color(0xFF006E28);

  @override
  Color get textPrimary => const Color(0xFF151C27);

  @override
  Color get textSecondary => const Color(0xFF3F4942);

  @override
  Color get textLight => const Color(0xFF6F7A71);

  @override
  Color get divider => const Color(0xFFBEC9BF);

  @override
  Color get shadow => const Color(0x1A006D44);

  @override
  Color get appBarBg => const Color(0xFFF0F3FF);

  @override
  Color get appBarForeground => const Color(0xFF151C27);

  @override
  Color get inputBg => const Color(0xFFF0F3FF);

  @override
  Color get bottomNavBg => const Color(0xCCF9F9FF);

  @override
  Color get bottomNavSelected => const Color(0xFF006D44);

  @override
  Color get bottomNavUnselected => const Color(0xFF6F7A71);

  @override
  Color get chipBg => const Color(0xFFE8F5EE);

  @override
  Color get chipText => const Color(0xFF006D44);

  @override
  Color get scaffoldBg => const Color(0xFFF9F9FF);

  @override
  Color get skeletonBase => const Color(0xFFE8E8E8);

  @override
  Color get skeletonShimmer => const Color(0x4DFFFFFF);


  @override
  Color get neonGreen => const Color(0xFF00FF85);

  @override
  Color get sage => const Color(0xFFABCFB6);

  @override
  Color get borderLight => const Color(0xFFC2C8C1);

  @override
  Color get buttonFg => const Color(0xFFF0F3FF);

  @override
  Color get emerald => const Color(0xFF10B981);

  @override
  Color get mint => const Color(0xFF4EDEA3);

  @override
  Color get textMuted => const Color(0xFFBBCABF);


  @override
  Color get textDisabled => const Color(0xFFE5E2E1);

  @override
  Color get borderDark => const Color(0xFF3C4A42);

  @override
  Color get buttonTextDark => const Color(0xFF00422B);


  @override
  Color get surfaceDark => const Color(0xFF012B17);

  @override
  Color get surfaceMedium => const Color(0xFF1B3B29);

  @override
  Color get surfaceDense => const Color(0xFF0F301F);

  @override
  Color get buttonBg => const Color(0xFF003824);

  @override
  Color get cardBorder => const Color(0xFF0B513D);

  @override
  Color get purpleIcon => const Color(0xFF8B5CF6);

  @override
  Color get iconGray => const Color(0xFF8C928C);

  @override
  Color get iconGreen => const Color(0xFF83C2A9);

  @override
  Color get errorRed => const Color(0xFF93000A);

  @override
  Color get errorLight => const Color(0xFFFFDAD6);

  @override
  Color get splashBg => const Color(0xFF002E1A);

  @override
  Color get offlineBg => const Color(0xFF131313);

  @override
  Color get glassBorder => const Color(0x66032515);

  @override
  Color get glassHighlight => const Color(0x0DFFFFFF);

  @override
  Color get timelineBg => const Color(0xFF00391C);


  @override
  Color get verifiedIconBg => const Color(0xFF004E29);

}

class VitalityDark implements AppColorSet {
  const VitalityDark();

  @override
  Color get primary => const Color(0xFF80D8A6);

  @override
  Color get primaryDark => const Color(0xFF006D44);

  @override
  Color get primaryLight => const Color(0xFF9CF5C1);

  @override
  Color get secondary => const Color(0xFF40E78C);

  @override
  Color get accent => const Color(0xFF00CA73);

  @override
  Color get surface => const Color(0xFF002111);

  @override
  Color get cardBg => const Color(0xFF032515);

  @override
  Color get error => const Color(0xFFFFB4AB);

  @override
  Color get warning => const Color(0xFFFFB3B1);

  @override
  Color get success => const Color(0xFF40E78C);

  @override
  Color get textPrimary => const Color(0xFFC6EBD1);

  @override
  Color get textSecondary => const Color(0xFFBEC9BF);

  @override
  Color get textLight => const Color(0xFF88938A);

  @override
  Color get divider => const Color(0xFF3F4942);

  @override
  Color get shadow => const Color(0x3D00180B);

  @override
  Color get appBarBg => const Color(0x6600180B);

  @override
  Color get appBarForeground => const Color(0xFFC6EBD1);

  @override
  Color get inputBg => const Color(0xFF002111);

  @override
  Color get bottomNavBg => const Color(0x9900180B);

  @override
  Color get bottomNavSelected => const Color(0xFF80D8A6);

  @override
  Color get bottomNavUnselected => const Color(0xFF88938A);

  @override
  Color get chipBg => const Color(0xFF006D44);

  @override
  Color get chipText => const Color(0xFF93ECB8);

  @override
  Color get scaffoldBg => const Color(0xFF00180B);

  @override
  Color get skeletonBase => const Color(0xFF2A2A2A);

  @override
  Color get skeletonShimmer => const Color(0x1AFFFFFF);


  @override
  Color get neonGreen => const Color(0xFF00FF85);

  @override
  Color get sage => const Color(0xFFABCFB6);

  @override
  Color get borderLight => const Color(0xFFC2C8C1);

  @override
  Color get buttonFg => const Color(0xFF00210C);

  @override
  Color get emerald => const Color(0xFF10B981);

  @override
  Color get mint => const Color(0xFF4EDEA3);

  @override
  Color get textMuted => const Color(0xFFBBCABF);


  @override
  Color get textDisabled => const Color(0xFFE5E2E1);

  @override
  Color get borderDark => const Color(0xFF3C4A42);

  @override
  Color get buttonTextDark => const Color(0xFF00422B);


  @override
  Color get surfaceDark => const Color(0xFF012B17);

  @override
  Color get surfaceMedium => const Color(0xFF1B3B29);

  @override
  Color get surfaceDense => const Color(0xFF0F301F);

  @override
  Color get buttonBg => const Color(0xFF003824);

  @override
  Color get cardBorder => const Color(0xFF0B513D);

  @override
  Color get purpleIcon => const Color(0xFF8B5CF6);

  @override
  Color get iconGray => const Color(0xFF8C928C);

  @override
  Color get iconGreen => const Color(0xFF83C2A9);

  @override
  Color get errorRed => const Color(0xFF93000A);

  @override
  Color get errorLight => const Color(0xFFFFDAD6);

  @override
  Color get splashBg => const Color(0xFF002E1A);

  @override
  Color get offlineBg => const Color(0xFF131313);

  @override
  Color get glassBorder => const Color(0x66032515);

  @override
  Color get glassHighlight => const Color(0x0DFFFFFF);

  @override
  Color get timelineBg => const Color(0xFF00391C);


  @override
  Color get verifiedIconBg => const Color(0xFF004E29);

}
