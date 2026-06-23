import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  void _showEditDialog(String label, String fieldKey, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${AppStrings.editLabel}$label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child:  Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileCubit>().updateProfile({fieldKey: controller.text});
            },
            child:  Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.15 : 16.0;

    return AppShell(
      title: AppStrings.profileTitle,
      currentRoute: AppRoutes.profile,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.accountDeleted) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const SkeletonProfile();
          }
          final user = state.user;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(AppStrings.failedToLoadProfile),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => context.read<ProfileCubit>().loadProfile(), child:  Text(AppStrings.retry)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
            child: Column(
              children: [
                _buildAvatar(user.imageUrl, colors),
                const SizedBox(height: 24),
                _buildInfoCard(user, colors),
                const SizedBox(height: 24),
                _buildActionButtons(colors),
                if (state.isSaving)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: LinearProgressIndicator(),
                  ),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(state.error!, style: TextStyle(color: colors.error), textAlign: TextAlign.center),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl, AppColorSet colors) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: colors.primary.withValues(alpha: 0.15),
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null ? Icon(Icons.person_rounded, size: 48, color: colors.primary) : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: colors.primary,
            child: Icon(Icons.camera_alt_rounded, size: 16, color: colors.surface),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(dynamic user, AppColorSet colors) {
    return Card(
      color: colors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildInfoTile(AppStrings.firstName, user.firstName, 'first_name', colors),
          _buildDivider(colors),
          _buildInfoTile(AppStrings.lastName, user.lastName, 'last_name', colors),
          _buildDivider(colors),
          _buildInfoTile(AppStrings.username, user.username, 'username', colors),
          _buildDivider(colors),
          _buildInfoTile(AppStrings.email, user.email, 'email', colors),
          _buildDivider(colors),
          _buildInfoTile(AppStrings.phone, user.phone ?? '—', 'phone', colors),
          _buildDivider(colors),
          _buildInfoTile(AppStrings.address, user.address ?? '—', 'address', colors),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, String fieldKey, AppColorSet colors) {
    return ListTile(
      title: Text(value, style: TextStyle(fontSize: AppSpacing.bodyLarge, color: colors.textPrimary)),
      subtitle: Text(label, style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textSecondary)),
      trailing: Icon(Icons.edit_rounded, size: 18, color: colors.primaryLight),
      onTap: () => _showEditDialog(label, fieldKey, value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildDivider(AppColorSet colors) {
    return Divider(height: 1, indent: 20, endIndent: 20, color: colors.divider.withValues(alpha: 0.5));
  }

  Widget _buildActionButtons(AppColorSet colors) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.changePassword),
            icon: const Icon(Icons.lock_outline_rounded),
            label:  Text(AppStrings.changePassword),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.surface,
              foregroundColor: colors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colors.divider),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title:  Text(AppStrings.deleteAccount),
                  content:  Text(AppStrings.deleteAccountConfirm),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child:  Text(AppStrings.cancel)),
                    ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child:  Text(AppStrings.confirmDeletion)),
                  ],
                ),
              );
              if (!mounted) return;
              if (confirmed == true) {
                Navigator.pushNamed(context, AppRoutes.deleteAccount);
              }
            },
            icon: const Icon(Icons.delete_forever_rounded),
            label:  Text(AppStrings.deleteAccount),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error.withValues(alpha: 0.1),
              foregroundColor: colors.error,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

