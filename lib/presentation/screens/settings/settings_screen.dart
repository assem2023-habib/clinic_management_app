import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
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
              _buildTile(Icons.language, 'Language', 'English'),
              _buildTile(Icons.dark_mode, 'Dark Mode', 'Toggle dark theme'),
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
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
