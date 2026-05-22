import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/phone_field.dart';
import 'package:clinic_management_app/presentation/widgets/date_picker_field.dart';

class RegisterReceptionistScreen extends StatefulWidget {
  const RegisterReceptionistScreen({super.key});

  @override
  State<RegisterReceptionistScreen> createState() => _RegisterReceptionistScreenState();
}

class _RegisterReceptionistScreenState extends State<RegisterReceptionistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneState = GlobalKey<PhoneFieldState>();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _shiftStartController = TextEditingController();
  final _shiftEndController = TextEditingController();
  String _gender = 'male';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    _shiftStartController.dispose();
    _shiftEndController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كَلِمَتَا السِّرِّ غَيْرُ مُتَطَابِقَتَيْنِ')),
      );
      return;
    }

    final phone = _phoneState.currentState;
    context.read<AuthCubit>().registerReceptionist(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: phone != null && phone.fullPhoneNumber.isNotEmpty
          ? phone.fullPhoneNumber
          : null,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      gender: _gender,
      birthdayDate: _birthdayController.text.isEmpty
          ? null
          : _birthdayController.text,
      shiftStart: _shiftStartController.text.isEmpty ? null : _shiftStartController.text,
      shiftEnd: _shiftEndController.text.isEmpty ? null : _shiftEndController.text,
    );
  }

  Future<void> _pickTime(TextEditingController ctrl) async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      ctrl.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('تَسْجِيلُ مَسْؤُولِ اسْتِقْبَالٍ جَدِيدٍ')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
                    _buildTextField(controller: _firstNameController, label: 'الاسْمُ الأَوَّلُ', validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _lastNameController, label: 'اسْمُ العَائِلَةِ', validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _usernameController, label: 'اسْمُ المُسْتَخْدِمِ', validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _emailController, label: 'البَرِيدُ الإِلِكْتْرُونِيُّ', keyboardType: TextInputType.emailAddress, validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    PhoneField(key: _phoneState, hintText: 'رَقْمُ الهَاتِفِ (اخْتِيَارِي)'),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _addressController, label: 'العُنْوَانُ (اخْتِيَارِي)'),
                    const SizedBox(height: 16),
                    DatePickerField(
                      controller: _birthdayController,
                      label: 'تَارِيخُ المِيلَادِ (اخْتِيَارِي)',
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: InputDecoration(
                        labelText: 'الجِنْسُ', filled: true,
                        fillColor: colors.cardBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('ذَكَر')),
                        DropdownMenuItem(value: 'female', child: Text('أُنْثَى')),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'male'),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _shiftStartController, label: 'بِدَايَةُ الدَّوْرَةِ (اخْتِيَارِي)', readOnly: true, onTap: () => _pickTime(_shiftStartController)),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _shiftEndController, label: 'نِهَايَةُ الدَّوْرَةِ (اخْتِيَارِي)', readOnly: true, onTap: () => _pickTime(_shiftEndController)),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _passwordController, label: 'كَلِمَةُ السِّرِّ', obscureText: true, validator: (v) => (v?.length ?? 0) < 8 ? '8 أَحْرُفٍ عَلَى الأَقَلِّ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _confirmPasswordController, label: 'تَأْكِيدُ كَلِمَةِ السِّرِّ', obscureText: true),
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
                          : const Text('تَسْجِيلُ', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                      child: const Text('لَدَيْكَ حِسَابٌ؟ سَجِّلُ الدُّخُولَ'),
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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    final colors = AppColors.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: colors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.textSecondary),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
