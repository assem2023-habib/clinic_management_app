import 'package:flutter/material.dart';

class AppColors {
  static const light = LightColors();
  static const dark = DarkColors();

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
  Color get background;
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
  Color get overlay;
  Color get scaffoldBg;
}

class LightColors implements AppColorSet {
  const LightColors();

  @override
  Color get primary => const Color(0xFF059669);
  @override
  Color get primaryDark => const Color(0xFF047857);
  @override
  Color get primaryLight => const Color(0xFF34D399);
  @override
  Color get secondary => const Color(0xFF0D9488);
  @override
  Color get accent => const Color(0xFFF59E0B);
  @override
  Color get background => const Color(0xFFF8FAFC);
  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get cardBg => const Color(0xFFFFFFFF);
  @override
  Color get error => const Color(0xFFEF4444);
  @override
  Color get warning => const Color(0xFFF59E0B);
  @override
  Color get success => const Color(0xFF22C55E);
  @override
  Color get textPrimary => const Color(0xFF1E293B);
  @override
  Color get textSecondary => const Color(0xFF64748B);
  @override
  Color get textLight => const Color(0xFF94A3B8);
  @override
  Color get divider => const Color(0xFFE2E8F0);
  @override
  Color get shadow => const Color(0x1A000000);
  @override
  Color get appBarBg => const Color(0xFF2563EB);
  @override
  Color get appBarForeground => const Color(0xFFFFFFFF);
  @override
  Color get inputBg => const Color(0xFFFFFFFF);
  @override
  Color get bottomNavBg => const Color(0xFFFFFFFF);
  @override
  Color get bottomNavSelected => const Color(0xFF2563EB);
  @override
  Color get bottomNavUnselected => const Color(0xFF94A3B8);
  @override
  Color get chipBg => const Color(0xFFEFF6FF);
  @override
  Color get chipText => const Color(0xFF2563EB);
  @override
  Color get overlay => const Color(0x80000000);
  @override
  Color get scaffoldBg => const Color(0xFFF8FAFC);
}

class DarkColors implements AppColorSet {
  const DarkColors();

  @override
  Color get primary => const Color(0xFF34D399);
  @override
  Color get primaryDark => const Color(0xFF059669);
  @override
  Color get primaryLight => const Color(0xFF6EE7B7);
  @override
  Color get secondary => const Color(0xFF2DD4BF);
  @override
  Color get accent => const Color(0xFFFBBF24);
  @override
  Color get background => const Color(0xFF0F172A);
  @override
  Color get surface => const Color(0xFF1E293B);
  @override
  Color get cardBg => const Color(0xFF1E293B);
  @override
  Color get error => const Color(0xFFF87171);
  @override
  Color get warning => const Color(0xFFFBBF24);
  @override
  Color get success => const Color(0xFF34D399);
  @override
  Color get textPrimary => const Color(0xFFF1F5F9);
  @override
  Color get textSecondary => const Color(0xFF94A3B8);
  @override
  Color get textLight => const Color(0xFF64748B);
  @override
  Color get divider => const Color(0xFF334155);
  @override
  Color get shadow => const Color(0x3D000000);
  @override
  Color get appBarBg => const Color(0xFF1E293B);
  @override
  Color get appBarForeground => const Color(0xFFF1F5F9);
  @override
  Color get inputBg => const Color(0xFF1E293B);
  @override
  Color get bottomNavBg => const Color(0xFF1E293B);
  @override
  Color get bottomNavSelected => const Color(0xFF3B82F6);
  @override
  Color get bottomNavUnselected => const Color(0xFF64748B);
  @override
  Color get chipBg => const Color(0xFF1E3A5F);
  @override
  Color get chipText => const Color(0xFF93C5FD);
  @override
  Color get overlay => const Color(0x80000000);
  @override
  Color get scaffoldBg => const Color(0xFF0F172A);
}
