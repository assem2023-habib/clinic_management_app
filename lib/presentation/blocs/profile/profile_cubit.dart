import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';

class ProfileState extends Equatable {
  final UserEntity? user;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final bool passwordChanged;
  final bool accountDeleted;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.passwordChanged = false,
    this.accountDeleted = false,
  });

  ProfileState copyWith({
    UserEntity? user,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool? passwordChanged,
    bool? accountDeleted,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      passwordChanged: passwordChanged ?? this.passwordChanged,
      accountDeleted: accountDeleted ?? this.accountDeleted,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, isSaving, error, passwordChanged, accountDeleted];
}

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _authRepository.getProfile();
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final user = await _authRepository.updateProfile(data);
      emit(state.copyWith(isSaving: false, user: user));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(state.copyWith(isSaving: true, error: null, passwordChanged: false));
    try {
      await _authRepository.changePassword(oldPassword, newPassword);
      emit(state.copyWith(isSaving: false, passwordChanged: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> deleteAccount(String password) async {
    emit(state.copyWith(isSaving: true, error: null, accountDeleted: false));
    try {
      await _authRepository.deleteAccount(password);
      emit(state.copyWith(isSaving: false, accountDeleted: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  void clearError() => emit(state.copyWith(error: null));
}
