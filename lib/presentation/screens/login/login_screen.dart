import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, onboardingState) {
                final role = onboardingState.selectedRole;
                final roleLabel = role == null
                    ? 'اخْتَرْ دَوْرَكَ'
                    : switch (role) {
                        UserRole.admin => 'مُدِير العِيَادَة',
                        UserRole.doctor => 'طَبِيب',
                        UserRole.receptionist => 'مَسْؤُول الاسْتِقْبَال',
                        UserRole.patient => 'مَرِيض',
                      };

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.medical_services_rounded,
                        size: 80,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppStrings.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تَسْجِيلُ الدُّخُولِ بِصِفَةِ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          roleLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppStrings.email,
                          prefixIcon: Icon(Icons.email_outlined, color: colors.textSecondary),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'الرَّجَاء إِدْخَال البَرِيد الإِلِكْتُرُونِيّ';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppStrings.password,
                          prefixIcon: Icon(Icons.lock_outlined, color: colors.textSecondary),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'الرَّجَاء إِدْخَال كَلِمَة المُرُور';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                                  _emailController.text,
                                  _passwordController.text,
                                  role: onboardingState.selectedRole,
                                );
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.dashboard,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          AppStrings.login,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      if (role != UserRole.admin) ...[
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            final route = switch (role) {
                              UserRole.admin => AppRoutes.registerReceptionist,
                              UserRole.doctor => AppRoutes.registerDoctor,
                              UserRole.receptionist => AppRoutes.registerReceptionist,
                              UserRole.patient => AppRoutes.registerPatient,
                              null => AppRoutes.registerPatient,
                            };
                            Navigator.pushReplacementNamed(context, route);
                          },
                          child: Text(
                            'لَيْسَ لَدَيْكَ حِسَابٌ؟ إِنْشَاءُ حِسَابٍ',
                            style: TextStyle(color: colors.primary, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          context.read<OnboardingCubit>().resetOnboarding();
                          Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
                        },
                        child: Text(
                          'العَوْدَةُ لِاخْتِيَارِ الدَّوْرِ',
                          style: TextStyle(color: colors.textLight, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
