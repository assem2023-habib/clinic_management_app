import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/phone_field.dart';
import 'package:clinic_management_app/presentation/widgets/date_picker_field.dart';
import 'package:clinic_management_app/presentation/widgets/specialization_picker_field.dart';

class RegisterDoctorScreen extends StatefulWidget {
  const RegisterDoctorScreen({super.key});

  @override
  State<RegisterDoctorScreen> createState() => _RegisterDoctorScreenState();
}

class _RegisterDoctorScreenState extends State<RegisterDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneState = GlobalKey<PhoneFieldState>();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceController = TextEditingController();
  String _gender = 'male';
  String? _specialization;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.passwordsNotMatch)),
      );
      return;
    }

    final phone = _phoneState.currentState;
    final email = _emailController.text;
    context.read<AuthCubit>().registerDoctor(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      username: email.split('@').first,
      email: email,
      password: _passwordController.text,
      phone: phone != null && phone.fullPhoneNumber.isNotEmpty
          ? phone.fullPhoneNumber
          : null,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      gender: _gender,
      specializationId: _specialization ?? '',
      experienceMonths: int.tryParse(_experienceController.text) ?? 0,
      birthdayDate: _birthdayController.text.isEmpty
          ? null
          : _birthdayController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registerDoctor)),
      body:       BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          } else if (state.pendingMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.pendingMessage!), backgroundColor: Colors.green),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: colors.error),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(controller: _firstNameController, label: AppStrings.firstName, prefixIcon: Icons.person_outline, validator: (v) => v?.isEmpty == true ? AppStrings.required : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _lastNameController, label: AppStrings.lastName, prefixIcon: Icons.person_outline, validator: (v) => v?.isEmpty == true ? AppStrings.required : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _emailController, label: AppStrings.email, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v?.isEmpty == true ? AppStrings.required : null),
                    const SizedBox(height: 16),
                    PhoneField(key: _phoneState, hintText: AppStrings.phoneOptional),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _addressController, label: AppStrings.addressOptional, prefixIcon: Icons.location_on_outlined),
                    const SizedBox(height: 16),
                    DatePickerField(
                      controller: _birthdayController,
                      label: AppStrings.dateOfBirthOptional,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: InputDecoration(
                        labelText: AppStrings.gender, filled: true,
                        fillColor: colors.cardBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.wc_rounded, color: colors.textSecondary),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text(AppStrings.male)),
                        DropdownMenuItem(value: 'female', child: Text(AppStrings.female)),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'male'),
                    ),
                    const SizedBox(height: 16),
                    SpecializationPickerField(
                      value: _specialization,
                      onChanged: (v) => setState(() => _specialization = v),
                      validator: (v) => v == null ? AppStrings.required : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _experienceController, label: AppStrings.experienceMonths, prefixIcon: Icons.work_history_outlined, keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return AppStrings.required;
                      final n = int.tryParse(v);
                      if (n == null || n < 0 || n > 1200) return AppStrings.between0and1200;
                      return null;
                    }),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _passwordController, label: 'كَلِمَةُ السِّرِّ', prefixIcon: Icons.lock_outlined, obscureText: _obscurePassword, validator: (v) => (v?.length ?? 0) < 8 ? AppStrings.min8Chars : null, suffix: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _confirmPasswordController, label: AppStrings.confirmPassword, prefixIcon: Icons.lock_outlined, obscureText: _obscureConfirmPassword, suffix: IconButton(icon: Icon(_obscureConfirmPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded), onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword))),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state.isLoading
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surface))
                          : const Text(AppStrings.register, style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                      child: const Text(AppStrings.haveAccountLogin2),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    final colors = AppColors.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: colors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.textSecondary),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: colors.textSecondary) : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
