import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/auth/registration_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/phone_field.dart';
import 'package:clinic_management_app/presentation/widgets/date_picker_field.dart';
import 'package:clinic_management_app/presentation/widgets/country_city_picker_field.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneState = GlobalKey<PhoneFieldState>();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'male';
  String? _cityId;
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
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppStrings.passwordsNotMatch)),
      );
      return;
    }

    final phone = _phoneState.currentState;
    final email = _emailController.text;
    context.read<RegistrationCubit>().registerPatient(
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
      cityId: _cityId,
      birthdayDate: _birthdayController.text.isEmpty
          ? null
          : _birthdayController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title:  Text(AppStrings.registerPatientTitle)),
      body: BlocListener<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state.registeredUser != null) {
            context.read<AuthCubit>().emitAuthenticated(state.registeredUser!);
            Navigator.pushReplacementNamed(context, AppRoutes.patientWelcome);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: colors.error),
            );
            context.read<RegistrationCubit>().reset();
          }
        },
        child: BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(controller: _firstNameController, label: AppStrings.firstName, prefixIcon: AppIcons.personOutline, validator: (v) => v?.isEmpty == true ? AppStrings.required : null),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(controller: _lastNameController, label: AppStrings.lastName, prefixIcon: AppIcons.personOutline, validator: (v) => v?.isEmpty == true ? AppStrings.required : null),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(controller: _emailController, label: AppStrings.email, prefixIcon: AppIcons.email, keyboardType: TextInputType.emailAddress, validator: (v) => v?.isEmpty == true ? AppStrings.required : null),
                    const SizedBox(height: AppSpacing.md),
                    PhoneField(key: _phoneState, hintText: AppStrings.phoneOptional),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(controller: _addressController, label: AppStrings.addressOptional, prefixIcon: AppIcons.locationOn),
                    const SizedBox(height: AppSpacing.md),
                    CountryCityPickerField(
                      cityId: _cityId,
                      onCityChanged: (v) => setState(() => _cityId = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DatePickerField(
                      controller: _birthdayController,
                      label: AppStrings.dateOfBirthOptional,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: InputDecoration(
                        labelText: AppStrings.gender, filled: true,
                        fillColor: colors.cardBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                        prefixIcon: Icon(AppIcons.wc, color: colors.textSecondary),
                      ),
                      items:  [
                        DropdownMenuItem(value: 'male', child: Text(AppStrings.male)),
                        DropdownMenuItem(value: 'female', child: Text(AppStrings.female)),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'male'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(controller: _passwordController, label: AppStrings.passwordTitle, prefixIcon: AppIcons.lock, obscureText: _obscurePassword, validator: (v) => (v?.length ?? 0) < 8 ? AppStrings.min8Chars : null, suffix: IconButton(icon: Icon(_obscurePassword ? AppIcons.visibility : AppIcons.visibilityOff), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(controller: _confirmPasswordController, label: AppStrings.confirmPassword, prefixIcon: AppIcons.lock, obscureText: _obscureConfirmPassword, suffix: IconButton(icon: Icon(_obscureConfirmPassword ? AppIcons.visibility : AppIcons.visibilityOff), onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword))),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                      ),
                      child: state.isLoading
                          ? SizedBox(height: AppSpacing.iconSmall, width: AppSpacing.iconSmall, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surface))
                          :  Text(AppStrings.register, style: TextStyle(fontSize: AppSpacing.bodyLarge)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                      child:  Text(AppStrings.haveAccountLogin2),
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
      style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.bodyLarge),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.textSecondary),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: colors.textSecondary) : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
      ),
      validator: validator,
    );
  }
}

