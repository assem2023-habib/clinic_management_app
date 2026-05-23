import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';

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
      title: 'الإِعْدَادَاتُ',
      currentRoute: AppRoutes.settings,
      body: ListenableBuilder(
        listenable: themeProvider,
        builder: (context, _) => ListView(
          children: [
            _buildSection(
              'الحِسَابُ',
              [
                _buildTile(Icons.person, 'المِلَفُّ الشَّخْصِيُّ', 'إِدَارَةُ المِلَفِّ الشَّخْصِيِّ'),
                _buildTile(Icons.lock, 'تَغْيِيرُ كَلِمَةِ السِّرِّ', 'تَحْدِيثُ كَلِمَةِ السِّرِّ'),
                _buildTile(Icons.notifications, 'الإِشْعَارَاتُ', 'إِدَارَةُ إِعْدَادَاتِ الإِشْعَارَاتِ'),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              'التَّفْضِيلَاتُ',
              [
                _buildThemeTile(themeProvider),
                _buildTile(Icons.language, 'اللُّغَةُ', 'العَرَبِيَّةُ'),
                _buildTile(Icons.backup, 'نَسْخٌ احْتِيَاطِيٌّ', 'نَسْخٌ احْتِيَاطِيٌّ لِبَيَانَاتِ العِيَادَةِ'),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              'حَوْلَ',
              [
                _buildTile(Icons.info, 'الإِصْدَارُ', '١.٠.٠'),
                _buildTile(Icons.help, 'المُسَاعَدَةُ وَالدَّعْمُ', 'الحُصُولُ عَلَى المُسَاعَدَةِ'),
                _buildTile(Icons.privacy_tip, 'سِيَاسَةُ الخُصُوصِيَّةِ', 'عَرْضُ سِيَاسَةِ الخُصُوصِيَّةِ'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.of(context).primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.of(context).primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _buildThemeTile(ThemeProvider themeProvider) {
    return ListTile(
      leading: Icon(
        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
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
            _buildThemeOption(context, themeProvider, ThemeMode.light, Icons.light_mode, 'Light Mode'),
            _buildThemeOption(context, themeProvider, ThemeMode.dark, Icons.dark_mode, 'الوَضْعُ الدَّاكِنُ'),
            _buildThemeOption(context, themeProvider, ThemeMode.system, Icons.brightness_auto, 'System Default'),
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
          ? Icon(Icons.check, color: AppColors.of(context).primary)
          : null,
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
