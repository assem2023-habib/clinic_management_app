import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated && state.user != null) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: colors.error),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, onboardingState) {
                  final role = onboardingState.selectedRole;
                  final roleLabel = role == null
                      ? AppStrings.chooseRole
                      : switch (role) {
                          UserRole.admin => AppStrings.roleAdmin,
                          UserRole.doctor => AppStrings.roleDoctor,
                          UserRole.receptionist => AppStrings.roleReceptionist,
                          UserRole.patient => AppStrings.rolePatient,
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
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AppStrings.appName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          AppStrings.loginAsRole,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppSpacing.bodyMedium,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.six),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.sm),
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
                            if (value == null || value.isEmpty) return AppStrings.enterEmail;
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: AppStrings.password,
                            prefixIcon: Icon(Icons.lock_outlined, color: colors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return AppStrings.enterPassword;
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().login(
                                              _emailController.text,
                                              _passwordController.text,
                                              role: onboardingState.selectedRole,
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              ),
                              child: state.isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.surface,
                                      ),
                                    )
                                  :  Text(
                                      AppStrings.login,
                                      style: TextStyle(fontSize: AppSpacing.bodyLarge, color: Colors.white),
                                    ),
                            );
                          },
                        ),
                        if (role == UserRole.doctor || role == UserRole.patient) ...[
                          const SizedBox(height: AppSpacing.xs),
                          TextButton(
                            onPressed: () {
                              final route = role == UserRole.doctor
                                  ? AppRoutes.registerDoctor
                                  : AppRoutes.registerPatient;
                              Navigator.pushReplacementNamed(context, route);
                            },
                            child: Text(
                              AppStrings.noAccountCreate,
                              style: TextStyle(color: colors.primary, fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xs),
                        TextButton(
                          onPressed: () {
                            context.read<OnboardingCubit>().resetOnboarding();
                            Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
                          },
                          child: Text(
                            AppStrings.backToRoleSelection,
                            style: TextStyle(color: colors.textLight, fontSize: AppSpacing.caption),
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
      ),
    );
  }
}

