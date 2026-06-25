import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/entities/auth_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/core/services/fcm_service.dart';
import 'package:clinic_management_app/presentation/blocs/token/token_cubit.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;
  final UserRole? role;
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final String? pendingMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
    this.role,
    this.user,
    this.isLoading = false,
    this.error,
    this.pendingMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? userName,
    UserRole? role,
    UserEntity? user,
    bool? isLoading,
    String? error,
    String? pendingMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      pendingMessage: pendingMessage,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, userId, userName, role, user, isLoading, error, pendingMessage];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading() : super(isLoading: true);
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required super.userId, required super.userName, required super.role, super.user}) : super(isAuthenticated: true);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  const AuthError(String error) : super(error: error);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository? _authRepository;
  final TokenCubit? _tokenCubit;

  AuthCubit({AuthRepository? authRepository, TokenCubit? tokenCubit})
      : _authRepository = authRepository,
        _tokenCubit = tokenCubit,
        super(const AuthState());

  Future<void> checkAuthStatus() async {
    if (_authRepository == null) return;
    try {
      final user = await _authRepository.getProfile();
      emitAuthenticated(user);
      await _tokenCubit?.registerDeviceToken(FcmService().deviceToken);
      await _tokenCubit?.initFirebaseAuth();
    } catch (_) {}
  }

  Future<void> login(String email, String password, {UserRole? role}) async {
    emit(const AuthLoading());

    if (_authRepository != null) {
      try {
        final request = LoginRequestEntity(email: email, password: password);
        final response = await _authRepository.login(request);
        if (response.isAuthenticated && response.user != null) {
          emitAuthenticated(response.user!);
          await _tokenCubit?.registerDeviceToken(FcmService().deviceToken);
          await _tokenCubit?.initFirebaseAuth();
        } else {
          emit(AuthError(response.message ?? AppStrings.loginFailed));
        }
        return;
      } catch (e) {
        emit(AuthError(e.toString()));
        return;
      }
    }

    if (email.isNotEmpty && password.isNotEmpty) {
      final userRole = role ?? UserRole.admin;
      final name = switch (userRole) {
          UserRole.admin => AppStrings.roleNameAdmin,
          UserRole.doctor => AppStrings.roleNameDoctor,
          UserRole.receptionist => AppStrings.roleNameReceptionist,
          UserRole.patient => AppStrings.roleNamePatient,
        };
      emit(AuthAuthenticated(userId: 'user1', userName: name, role: userRole));
    } else {
      emit(const AuthState(isAuthenticated: false));
    }
  }

  void emitAuthenticated(UserEntity user) {
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
    await ApiService.clearCache();
    await _tokenCubit?.deleteToken();
    await _tokenCubit?.firebaseSignOut();
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
