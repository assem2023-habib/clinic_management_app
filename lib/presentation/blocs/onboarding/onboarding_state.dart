import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class OnboardingState extends Equatable {
  final bool completed;
  final UserRole? selectedRole;
  final int currentPage;

  const OnboardingState({
    this.completed = false,
    this.selectedRole,
    this.currentPage = 0,
  });

  OnboardingState copyWith({
    bool? completed,
    UserRole? selectedRole,
    int? currentPage,
  }) {
    return OnboardingState(
      completed: completed ?? this.completed,
      selectedRole: selectedRole ?? this.selectedRole,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [completed, selectedRole, currentPage];
}
