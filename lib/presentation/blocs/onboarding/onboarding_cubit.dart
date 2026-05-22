import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  static const _keyCompleted = 'onboarding_completed';
  static const _keyRole = 'user_role';

  Future<void> loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_keyCompleted) ?? false;
    final roleStr = prefs.getString(_keyRole);
    final role = switch (roleStr) {
        'admin' => UserRole.admin,
        'doctor' => UserRole.doctor,
        'receptionist' => UserRole.receptionist,
        'patient' => UserRole.patient,
        _ => null,
      };
    emit(state.copyWith(completed: completed, selectedRole: role));
  }

  Future<void> selectRole(UserRole role) async {
    emit(state.copyWith(selectedRole: role));
  }

  void setPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, true);
    if (state.selectedRole != null) {
      await prefs.setString(_keyRole, state.selectedRole!.name);
    }
    emit(state.copyWith(completed: true));
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, false);
    await prefs.remove(_keyRole);
    emit(const OnboardingState());
  }
}
