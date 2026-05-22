import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;
  final UserRole? role;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
    this.role,
  });

  AuthState copyWith({bool? isAuthenticated, String? userId, String? userName, UserRole? role}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, userId, userName, role];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required super.userId, required super.userName, required super.role});
}

class AuthUnauthenticated extends AuthState {}

abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;
  AuthLogin(this.email, this.password);
}

class AuthLogout extends AuthEvent {}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void login(String email, String password, {UserRole? role}) {
    if (email.isNotEmpty && password.isNotEmpty) {
      final userRole = role ?? UserRole.admin;
      final name = switch (userRole) {
          UserRole.admin => 'مُدِير العِيَادَة',
          UserRole.doctor => 'طَبِيب',
          UserRole.receptionist => 'مَسْؤُول الاسْتِقْبَال',
          UserRole.patient => 'مَرِيض',
        };
      emit(AuthAuthenticated(userId: 'user1', userName: name, role: userRole));
    } else {
      emit(const AuthState(isAuthenticated: false));
    }
  }

  void logout() {
    emit(const AuthState(isAuthenticated: false));
  }
}
