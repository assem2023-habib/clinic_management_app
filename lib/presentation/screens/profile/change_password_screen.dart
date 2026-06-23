import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppStrings.passwordsNotMatch)),
      );
      return;
    }
    context.read<ProfileCubit>().changePassword(
      _oldPasswordController.text,
      _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AppShell(
      title: AppStrings.changePassword,
      showBackButton: true,
      showDrawer: false,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.passwordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(AppStrings.passwordChanged)),
            );
            Navigator.pop(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: colors.error),
            );
            context.read<ProfileCubit>().clearError();
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPasswordField(
                      controller: _oldPasswordController,
                      label: AppStrings.currentPassword,
                      obscure: _obscureOld,
                      toggle: () => setState(() => _obscureOld = !_obscureOld),
                      colors: colors,
                      validator: (v) => v?.isEmpty == true ? AppStrings.required : null,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: _newPasswordController,
                      label: AppStrings.newPassword,
                      obscure: _obscureNew,
                      toggle: () => setState(() => _obscureNew = !_obscureNew),
                      colors: colors,
                      validator: (v) => (v?.length ?? 0) < 8 ? AppStrings.min8Chars : null,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: AppStrings.confirmNewPassword,
                      obscure: _obscureConfirm,
                      toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      colors: colors,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: state.isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state.isSaving
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surface))
                          :  Text(AppStrings.save, style: TextStyle(fontSize: AppSpacing.bodyLarge)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required AppColorSet colors,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
          onPressed: toggle,
        ),
      ),
    );
  }
}

