import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildThemeData(AppColors.light, Brightness.light);
  static ThemeData get darkTheme => _buildThemeData(AppColors.dark, Brightness.dark);

  static ThemeData _buildThemeData(AppColorSet colors, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.scaffoldBg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: brightness == Brightness.light ? Colors.white : const Color(0xFF003921),
        primaryContainer: brightness == Brightness.light
            ? const Color(0xFF006D44)
            : const Color(0xFF006D44),
        onPrimaryContainer: const Color(0xFF93ECB8),
        secondary: colors.secondary,
        onSecondary: brightness == Brightness.light ? Colors.white : const Color(0xFF00391C),
        secondaryContainer: brightness == Brightness.light
            ? const Color(0xFFD6E3DC)
            : const Color(0xFF00CA73),
        onSecondaryContainer: brightness == Brightness.light
            ? const Color(0xFF596560)
            : const Color(0xFF004E29),
        tertiary: brightness == Brightness.light
            ? const Color(0xFF00531C)
            : const Color(0xFFFFB3B1),
        onTertiary: Colors.white,
        error: colors.error,
        onError: brightness == Brightness.light ? Colors.white : const Color(0xFF690005),
        errorContainer: brightness == Brightness.light
            ? const Color(0xFFFFDAD6)
            : const Color(0xFF93000A),
        onErrorContainer: brightness == Brightness.light
            ? const Color(0xFF93000A)
            : const Color(0xFFFFDAD6),
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerLowest: brightness == Brightness.light
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF001207),
        surfaceContainerLow: brightness == Brightness.light
            ? const Color(0xFFF0F3FF)
            : const Color(0xFF002111),
        surfaceContainer: brightness == Brightness.light
            ? const Color(0xFFE7EEFE)
            : const Color(0xFF032515),
        surfaceContainerHigh: brightness == Brightness.light
            ? const Color(0xFFE2E8F8)
            : const Color(0xFF0F301F),
        surfaceContainerHighest: brightness == Brightness.light
            ? const Color(0xFFDCE2F3)
            : const Color(0xFF1B3B29),
        outline: colors.textLight,
        outlineVariant: colors.divider,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBarBg,
        foregroundColor: colors.appBarForeground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colors.appBarForeground,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: colors.appBarForeground),
      ),
      cardTheme: CardThemeData(
        color: colors.cardBg,
        elevation: 0,
        shadowColor: colors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.divider.withValues(alpha: 0.2)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: brightness == Brightness.light ? Colors.white : const Color(0xFF003921),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: colors.textLight, fontWeight: FontWeight.w400),
        labelStyle: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w500),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: brightness == Brightness.light ? Colors.white : const Color(0xFF003921),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: colors.textPrimary, letterSpacing: -0.02),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.textPrimary, letterSpacing: -0.01),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.textPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colors.textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: colors.textSecondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textLight, letterSpacing: 0.02),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider.withValues(alpha: 0.3),
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: colors.textPrimary),
      listTileTheme: ListTileThemeData(
        iconColor: colors.textSecondary,
        textColor: colors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.cardBg,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.textPrimary),
        contentTextStyle: TextStyle(fontSize: 14, color: colors.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.bottomNavBg,
        selectedItemColor: colors.bottomNavSelected,
        unselectedItemColor: colors.bottomNavUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary.withValues(alpha: 0.3);
          return colors.divider;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.primary.withValues(alpha: 0.2);
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: colors.textSecondary,
        textColor: colors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.chipBg,
        labelStyle: TextStyle(color: colors.chipText, fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.bottomNavBg,
        indicatorColor: colors.primary.withValues(alpha: 0.15),
      ),
    );
  }
}
