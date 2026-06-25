import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/auth_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';

class RegistrationState extends Equatable {
  final bool isLoading;
  final String? error;
  final UserEntity? registeredUser;
  final String? pendingMessage;

  const RegistrationState({this.isLoading = false, this.error, this.registeredUser, this.pendingMessage});

  RegistrationState copyWith({bool? isLoading, String? error, UserEntity? registeredUser, String? pendingMessage}) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      registeredUser: registeredUser ?? this.registeredUser,
      pendingMessage: pendingMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, registeredUser, pendingMessage];
}

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository? _authRepository;

  RegistrationCubit({AuthRepository? authRepository})
      : _authRepository = authRepository,
        super(const RegistrationState());

  Future<void> registerPatient({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? cityId,
  }) async {
    emit(const RegistrationState(isLoading: true));
    if (_authRepository == null) {
      emit(const RegistrationState(error: 'API not available'));
      return;
    }
    try {
      final request = RegisterPatientRequestEntity(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        cityId: cityId,
      );
      final response = await _authRepository.registerPatient(request);
      if (response.isAuthenticated && response.user != null) {
        emit(RegistrationState(registeredUser: response.user));
      } else {
        emit(RegistrationState(error: response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(RegistrationState(error: e.toString()));
    }
  }

  Future<void> registerDoctor({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? cityId,
    required String specializationId, required int experienceMonths,
  }) async {
    emit(const RegistrationState(isLoading: true));
    if (_authRepository == null) {
      emit(const RegistrationState(error: 'API not available'));
      return;
    }
    try {
      final request = RegisterDoctorRequestEntity(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        cityId: cityId,
        specializationId: specializationId, experienceMonths: experienceMonths,
      );
      final response = await _authRepository.registerDoctor(request);
      if (response.isAuthenticated && response.user != null) {
        emit(RegistrationState(registeredUser: response.user));
      } else {
        emit(RegistrationState(pendingMessage: response.message));
      }
    } catch (e) {
      emit(RegistrationState(error: e.toString()));
    }
  }

  Future<void> registerReceptionist({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? cityId,
    String? shiftStart, String? shiftEnd,
  }) async {
    emit(const RegistrationState(isLoading: true));
    if (_authRepository == null) {
      emit(const RegistrationState(error: 'API not available'));
      return;
    }
    try {
      final request = RegisterReceptionistRequestEntity(
        firstName: firstName, lastName: lastName, username: username,
        email: email, password: password, phone: phone, address: address,
        gender: gender, birthdayDate: birthdayDate,
        cityId: cityId,
        shiftStart: shiftStart, shiftEnd: shiftEnd,
      );
      final response = await _authRepository.registerReceptionist(request);
      if (response.isAuthenticated && response.user != null) {
        emit(RegistrationState(registeredUser: response.user));
      } else {
        emit(RegistrationState(pendingMessage: response.message));
      }
    } catch (e) {
      emit(RegistrationState(error: e.toString()));
    }
  }

  void reset() => emit(const RegistrationState());
}
