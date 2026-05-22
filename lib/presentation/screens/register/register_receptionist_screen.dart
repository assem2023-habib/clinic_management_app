import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';

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
  final _phoneController = TextEditingController();
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
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

    final cubit = context.read<AuthCubit>();
    await cubit.login(_emailController.text, _passwordController.text, role: UserRole.receptionist);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
      body: SingleChildScrollView(
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
              _buildTextField(controller: _phoneController, label: 'رَقْمُ الهَاتِفِ (اخْتِيَارِي)', keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(controller: _addressController, label: 'العُنْوَانُ (اخْتِيَارِي)'),
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
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('تَسْجِيلُ', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text('لَدَيْكَ حِسَابٌ؟ سَجِّلُ الدُّخُولَ'),
              ),
            ],
          ),
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
      decoration: InputDecoration(
        labelText: label, filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
