import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/data/models/auth/login_request.dart';
import 'package:clinic_management_app/data/models/auth/register_patient_request.dart';
import 'package:clinic_management_app/data/models/auth/register_doctor_request.dart';
import 'package:clinic_management_app/data/models/auth/register_receptionist_request.dart';
import 'package:clinic_management_app/core/services/fcm_service.dart';
import 'package:clinic_management_app/core/services/firebase_auth_service.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;
  final UserRole? role;
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final String? pendingMessage;
  final Map<String, String>? firebaseToken;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
    this.role,
    this.user,
    this.isLoading = false,
    this.error,
    this.pendingMessage,
    this.firebaseToken,
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
    Map<String, String>? firebaseToken,
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
      firebaseToken: firebaseToken,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, userId, userName, role, user, isLoading, error, pendingMessage, firebaseToken];
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
  StreamSubscription<String>? _tokenSubscription;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    _listenToTokenRefreshes();
  }

  void _listenToTokenRefreshes() {
    _tokenSubscription = FcmService().onTokenRefresh.listen((newToken) {
      _registerDeviceToken(newToken);
    });
  }

  Future<void> _registerDeviceToken(String? token) async {
    if (_authRepository == null || token == null || token.isEmpty) return;
    try {
      await _authRepository.updateDeviceToken(token);
    } catch (_) {}
  }

  Future<void> _initFirebaseAuth() async {
    if (_authRepository == null) return;
    try {
      final result = await _authRepository.getFirebaseToken();
      final customToken = result['firebase_token'];
      if (customToken != null && customToken.isNotEmpty) {
        await FirebaseAuthService().signInWithCustomToken(customToken);
      }
    } catch (_) {}
  }

  Future<void> checkAuthStatus() async {
    if (_authRepository == null) return;
    try {
      final user = await _authRepository.getProfile();
      final userRole = _mapRole(user.roles);
      emit(AuthAuthenticated(
        userId: user.id,
        userName: user.fullName,
        role: userRole,
        user: user,
      ));
      await _registerDeviceToken(FcmService().deviceToken);
      await _initFirebaseAuth();
    } catch (_) {}
  }

  Future<void> login(String email, String password, {UserRole? role}) async {
    emit(const AuthLoading());

    if (_authRepository != null) {
      try {
        final request = LoginRequest(email: email, password: password);
        final response = await _authRepository.login(request);
        if (response.isAuthenticated && response.user != null) {
          final userRole = _mapRole(response.user!.roles);
          emit(AuthAuthenticated(
            userId: response.user!.id,
            userName: response.user!.fullName,
            role: userRole,
            user: response.user,
          ));
          await _registerDeviceToken(FcmService().deviceToken);
          await _initFirebaseAuth();
        } else {
          emit(AuthError(response.message ?? 'فشلت عملية الدخول'));
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
          UserRole.admin => 'Admin',
          UserRole.doctor => 'Doctor',
          UserRole.receptionist => 'Receptionist',
          UserRole.patient => 'Patient',
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
    String? cityId,
  }) async {
    emit(const AuthLoading());
    if (_authRepository == null) {
      emit(const AuthError('API غير متاح'));
      return;
    }
    try {
      final request = RegisterPatientRequest(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        cityId: cityId,
      );
      final response = await _authRepository.registerPatient(request);
      if (response.isAuthenticated && response.user != null) {
        _emitAuthenticated(response.user!);
        await _registerDeviceToken(FcmService().deviceToken);
        await _initFirebaseAuth();
      } else {
        emit(AuthError(response.message ?? 'فشلت عملية التسجيل'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerDoctor({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? cityId,
    required String specializationId, required int experienceMonths,
  }) async {
    emit(const AuthLoading());
    if (_authRepository == null) {
      emit(const AuthError('API غير متاح'));
      return;
    }
    try {
      final request = RegisterDoctorRequest(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        cityId: cityId,
        specializationId: specializationId, experienceMonths: experienceMonths,
      );
      final response = await _authRepository.registerDoctor(request);
      if (response.isAuthenticated && response.user != null) {
        _emitAuthenticated(response.user!);
        await _registerDeviceToken(FcmService().deviceToken);
        await _initFirebaseAuth();
      } else {
        emit(AuthState(pendingMessage: response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerReceptionist({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? cityId,
    String? shiftStart, String? shiftEnd,
  }) async {
    emit(const AuthLoading());
    if (_authRepository == null) {
      emit(const AuthError('API غير متاح'));
      return;
    }
    try {
      final request = RegisterReceptionistRequest(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        cityId: cityId,
        shiftStart: shiftStart, shiftEnd: shiftEnd,
      );
      final response = await _authRepository.registerReceptionist(request);
      if (response.isAuthenticated && response.user != null) {
        _emitAuthenticated(response.user!);
        await _registerDeviceToken(FcmService().deviceToken);
        await _initFirebaseAuth();
      } else {
        emit(AuthState(pendingMessage: response.message));
      }
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
    await FcmService().deleteToken();
    await FirebaseAuthService().signOut();
    emit(const AuthState(isAuthenticated: false));
  }

  Future<void> getFirebaseToken() async {
    if (_authRepository == null) return;
    try {
      final result = await _authRepository.getFirebaseToken();
      emit(state.copyWith(firebaseToken: result));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
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

  @override
  Future<void> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }
}
