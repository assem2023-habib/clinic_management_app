import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/phone_field.dart';
import 'package:clinic_management_app/presentation/widgets/date_picker_field.dart';

const _specializations = {
  'cardiology': 'أمراض القلب',
  'dermatology': 'الأمراض الجلدية',
  'neurology': 'الأمراض العصبية',
  'pediatrics': 'طب الأطفال',
  'orthopedics': 'جراحة العظام',
  'ophthalmology': 'طب العيون',
  'ent': 'الأذن والأنف والحنجرة',
  'psychiatry': 'الطب النفسي',
  'radiology': 'الأشعة',
  'surgery': 'الجراحة العامة',
  'internal_medicine': 'الباطنة',
  'obstetrics_gynecology': 'النساء والتوليد',
  'emergency_medicine': 'طب الطوارئ',
  'anesthesiology': 'التخدير',
  'pathology': 'علم الأمراض',
  'urology': 'المسالك البولية',
  'gastroenterology': 'الجهاز الهضمي',
  'endocrinology': 'الغدد الصماء',
  'pulmonology': 'أمراض الصدر',
  'rheumatology': 'الروماتيزم',
  'nephrology': 'أمراض الكلى',
  'hematology': 'أمراض الدم',
  'oncology': 'الأورام',
  'infectious_disease': 'الأمراض المعدية',
  'genetics': 'علم الوراثة',
  'immunology': 'علم المناعة',
  'sports_medicine': 'الطب الرياضي',
};

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
        const SnackBar(content: Text('كَلِمَتَا السِّرِّ غَيْرُ مُتَطَابِقَتَيْنِ')),
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
      specialization: _specialization ?? '',
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
      appBar: AppBar(title: const Text('تَسْجِيلُ طَبِيبٍ جَدِيدٍ')),
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
                    _buildTextField(controller: _firstNameController, label: 'الاسْمُ الأَوَّلُ', prefixIcon: Icons.person_outline, validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _lastNameController, label: 'اسْمُ العَائِلَةِ', prefixIcon: Icons.person_outline, validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _emailController, label: 'البَرِيدُ الإِلِكْتْرُونِيُّ', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v?.isEmpty == true ? 'مَطْلُوبٌ' : null),
                    const SizedBox(height: 16),
                    PhoneField(key: _phoneState, hintText: 'رَقْمُ الهَاتِفِ (اخْتِيَارِي)'),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _addressController, label: 'العُنْوَانُ (اخْتِيَارِي)', prefixIcon: Icons.location_on_outlined),
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
                        prefixIcon: Icon(Icons.wc_rounded, color: colors.textSecondary),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('ذَكَر')),
                        DropdownMenuItem(value: 'female', child: Text('أُنْثَى')),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'male'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _specialization,
                      decoration: InputDecoration(
                        labelText: 'التَّخَصُّصُ', filled: true,
                        fillColor: colors.cardBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.medical_services_outlined, color: colors.textSecondary),
                      ),
                      items: _specializations.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                      onChanged: (v) => setState(() => _specialization = v),
                      validator: (v) => v == null ? 'مَطْلُوبٌ' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _experienceController, label: 'عَدَدُ شُهُورِ الخِبْرَةِ', prefixIcon: Icons.work_history_outlined, keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return 'مَطْلُوبٌ';
                      final n = int.tryParse(v);
                      if (n == null || n < 0 || n > 1200) return 'بَيْنَ 0 و 1200';
                      return null;
                    }),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _passwordController, label: 'كَلِمَةُ السِّرِّ', prefixIcon: Icons.lock_outlined, obscureText: true, validator: (v) => (v?.length ?? 0) < 8 ? '8 أَحْرُفٍ عَلَى الأَقَلِّ' : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _confirmPasswordController, label: 'تَأْكِيدُ كَلِمَةِ السِّرِّ', prefixIcon: Icons.lock_outlined, obscureText: true),
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
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
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
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
