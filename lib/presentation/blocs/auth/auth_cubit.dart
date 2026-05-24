import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;
  final UserRole? role;
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
    this.role,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? userName,
    UserRole? role,
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, userId, userName, role, user, isLoading, error];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading() : super(isLoading: true);
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required super.userId, required super.userName, required super.role, super.user});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  const AuthError(String error) : super(error: error);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository? _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository,
        super(const AuthState());

  Future<void> login(String email, String password, {UserRole? role}) async {
    emit(const AuthLoading());

    if (_authRepository != null) {
      try {
        final result = await _authRepository.login(email, password);
        final userRole = _mapRole(result.user.roles);
        emit(AuthAuthenticated(
          userId: result.user.id,
          userName: result.user.fullName,
          role: userRole,
          user: result.user,
        ));
        return;
      } catch (e) {
        emit(AuthError(e.toString()));
        return;
      }
    }

    if (email.isNotEmpty && password.isNotEmpty) {
      final userRole = role ?? UserRole.admin;
      final name = switch (userRole) {
          UserRole.admin => AppStrings.roleAdmin,
          UserRole.doctor => AppStrings.roleDoctor,
          UserRole.receptionist => AppStrings.roleReceptionist,
          UserRole.patient => AppStrings.rolePatient,
        };
      emit(AuthAuthenticated(userId: 'user1', userName: name, role: userRole));
    } else {
      emit(const AuthState(isAuthenticated: false));
    }
  }

  Future<void> registerPatient({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
  }) async {
    emit(const AuthLoading());
    if (_authRepository == null) {
      emit(const AuthError(AppStrings.apiNotAvailable));
      return;
    }
    try {
      final result = await _authRepository.registerPatient(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
      );
      _emitAuthenticated(result.user);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerDoctor({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    required String specialization, required int experienceMonths,
  }) async {
    emit(const AuthLoading());
    if (_authRepository == null) {
      emit(const AuthError(AppStrings.apiNotAvailable));
      return;
    }
    try {
      final result = await _authRepository.registerDoctor(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        specialization: specialization, experienceMonths: experienceMonths,
      );
      _emitAuthenticated(result.user);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerReceptionist({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? shiftStart, String? shiftEnd,
  }) async {
    emit(const AuthLoading());
    if (_authRepository == null) {
      emit(const AuthError(AppStrings.apiNotAvailable));
      return;
    }
    try {
      final result = await _authRepository.registerReceptionist(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        shiftStart: shiftStart, shiftEnd: shiftEnd,
      );
      _emitAuthenticated(result.user);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _emitAuthenticated(UserEntity user) {
    final userRole = _mapRole(user.roles);
    emit(AuthAuthenticated(
      userId: user.id,
      userName: user.fullName,
      role: userRole,
      user: user,
    ));
  }

  Future<void> logout() async {
    try {
      await _authRepository?.logout();
    } catch (_) {}
    emit(const AuthState(isAuthenticated: false));
  }

  UserRole _mapRole(List<RoleEntity> roles) {
    for (final role in roles) {
      if (role.slug == 'admin') return UserRole.admin;
      if (role.slug == 'doctor') return UserRole.doctor;
      if (role.slug == 'receptionist') return UserRole.receptionist;
      if (role.slug == 'patient') return UserRole.patient;
    }
    return UserRole.patient;
  }
}
