import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/blocs/language/language_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const SettingsScreen({super.key, required this.themeProvider});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = widget.themeProvider;

    return AppShell(
      title: AppStrings.settings,
      currentRoute: AppRoutes.settings,
      body: ListenableBuilder(
        listenable: themeProvider,
        builder: (context, _) => ListView(
          children: [
            _buildSection(
              AppStrings.account,
              [
                _buildTile(AppIcons.person, AppStrings.myProfile, AppStrings.manageProfile),
                _buildTile(AppIcons.lock, AppStrings.changePassword, AppStrings.updatePassword),
                _buildTile(AppIcons.notifications, AppStrings.notifications, AppStrings.manageNotifications),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              AppStrings.preferences,
              [
                _buildThemeTile(themeProvider),
                _buildLanguageTile(),
                _buildTile(AppIcons.upload, AppStrings.backup, AppStrings.backupDescription),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              AppStrings.about,
              [
                _buildTile(AppIcons.info, AppStrings.version, AppStrings.versionNumber),
                _buildTile(AppIcons.help, AppStrings.helpSupport, AppStrings.getHelp),
                _buildTile(AppIcons.privacyTip, AppStrings.privacyPolicy, AppStrings.viewPrivacyPolicy),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSpacing.bodyMedium,
              color: AppColors.of(context).primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.of(context).primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(AppIcons.chevronRight),
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile() {
    final locale = context.watch<LanguageCubit>().state;
    final isEn = locale.languageCode == 'en';
    final subtitle = isEn ? AppStrings.english : AppStrings.arabic;
    final flag = isEn ? '🇬🇧' : '🇸🇦';
    return ListTile(
      leading: Icon(AppIcons.language, color: AppColors.of(context).primary),
      title: Text(AppStrings.language),
      subtitle: Text('$subtitle  $flag'),
      trailing: const Icon(AppIcons.chevronRight),
      onTap: () => _showLanguageDialog(context),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final current = context.read<LanguageCubit>().state.languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: AppSpacing.titleError)),
              title: const Text('العربية'),
              trailing: current == 'ar' ? Icon(AppIcons.check, color: AppColors.of(context).primary) : null,
              onTap: () {
                context.read<LanguageCubit>().setLocale('ar');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: AppSpacing.titleError)),
              title: const Text('English'),
              trailing: current == 'en' ? Icon(AppIcons.check, color: AppColors.of(context).primary) : null,
              onTap: () {
                context.read<LanguageCubit>().setLocale('en');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(ThemeProvider themeProvider) {
    return ListTile(
      leading: Icon(
        themeProvider.isDarkMode ? AppIcons.darkMode : AppIcons.lightMode,
        color: AppColors.of(context).primary,
      ),
      title: const Text('الوَضْعُ الدَّاكِنُ'),
      subtitle: Text(_getThemeModeText(themeProvider.themeMode)),
      trailing: _buildThemeModeChip(themeProvider.themeMode),
      onTap: () => _showThemeDialog(context, themeProvider),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'الوَضْعُ الفَاتِحُ نَشِطٌ';
      case ThemeMode.dark:
        return 'الوَضْعُ الدَّاكِنُ نَشِطٌ';
      case ThemeMode.system:
        return 'يَتْبَعُ إِعْدَادَاتِ الجِهَازِ';
    }
  }

  Widget _buildThemeModeChip(ThemeMode mode) {
    Color color;
    String label;
    switch (mode) {
      case ThemeMode.light:
        color = Colors.amber;
        label = 'فَاتِحٌ';
        break;
      case ThemeMode.dark:
        color = Colors.deepPurple;
        label = 'دَاكِنٌ';
        break;
      case ThemeMode.system:
        color = Colors.grey;
        label = 'تِلْقَائِيٌّ';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ten, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, themeProvider, ThemeMode.light, AppIcons.lightMode, 'Light Mode'),
            _buildThemeOption(context, themeProvider, ThemeMode.dark, AppIcons.darkMode, 'الوَضْعُ الدَّاكِنُ'),
            _buildThemeOption(context, themeProvider, ThemeMode.system, AppIcons.darkMode, 'System Default'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.of(context).primary : null),
      title: Text(label),
      trailing: isSelected
          ? Icon(AppIcons.check, color: AppColors.of(context).primary)
          : null,
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}

