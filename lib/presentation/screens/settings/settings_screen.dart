import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: themeProvider,
        builder: (context, _) => ListView(
          children: [
            _buildSection(
              'Account',
              [
                _buildTile(Icons.person, 'Profile', 'Manage your profile'),
                _buildTile(Icons.lock, 'Change Password', 'Update your password'),
                _buildTile(Icons.notifications, 'Notifications', 'Manage notification settings'),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              'Preferences',
              [
                _buildThemeTile(themeProvider),
                _buildTile(Icons.language, 'Language', 'English'),
                _buildTile(Icons.backup, 'Backup Data', 'Backup clinic data'),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              'About',
              [
                _buildTile(Icons.info, 'Version', '1.0.0'),
                _buildTile(Icons.help, 'Help & Support', 'Get help'),
                _buildTile(Icons.privacy_tip, 'Privacy Policy', 'View privacy policy'),
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
      title: const Text('Dark Mode'),
      subtitle: Text(_getThemeModeText(themeProvider.themeMode)),
      trailing: _buildThemeModeChip(themeProvider.themeMode),
      onTap: () => _showThemeDialog(context, themeProvider),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light theme active';
      case ThemeMode.dark:
        return 'Dark theme active';
      case ThemeMode.system:
        return 'Follows system setting';
    }
  }

  Widget _buildThemeModeChip(ThemeMode mode) {
    Color color;
    String label;
    switch (mode) {
      case ThemeMode.light:
        color = Colors.amber;
        label = 'Light';
        break;
      case ThemeMode.dark:
        color = Colors.deepPurple;
        label = 'Dark';
        break;
      case ThemeMode.system:
        color = Colors.grey;
        label = 'Auto';
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
            _buildThemeOption(context, themeProvider, ThemeMode.dark, Icons.dark_mode, 'Dark Mode'),
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
