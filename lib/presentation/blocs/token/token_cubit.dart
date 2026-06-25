import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/core/services/fcm_service.dart';
import 'package:clinic_management_app/core/services/firebase_auth_service.dart';

class TokenState extends Equatable {
  final Map<String, String>? firebaseToken;
  final bool isLoading;
  final String? error;

  const TokenState({this.firebaseToken, this.isLoading = false, this.error});

  TokenState copyWith({
    Map<String, String>? firebaseToken,
    bool? isLoading,
    String? error,
  }) {
    return TokenState(
      firebaseToken: firebaseToken,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [firebaseToken, isLoading, error];
}

class TokenCubit extends Cubit<TokenState> {
  final AuthRepository _authRepository;
  StreamSubscription<String>? _tokenSubscription;

  TokenCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const TokenState());

  void _ensureTokenSubscription() {
    if (_tokenSubscription != null) return;
    try {
      _tokenSubscription = FcmService().onTokenRefresh.listen((newToken) {
        _registerDeviceToken(newToken);
      });
    } catch (_) {}
  }

  Future<void> _registerDeviceToken(String? token) async {
    if (token == null || token.isEmpty) return;
    try {
      await _authRepository.updateDeviceToken(token);
    } catch (_) {}
  }

  Future<void> initFirebaseAuth() async {
    _ensureTokenSubscription();
    try {
      final result = await _authRepository.getFirebaseToken();
      final customToken = result['firebase_token'];
      if (customToken != null && customToken.isNotEmpty) {
        await FirebaseAuthService().signInWithCustomToken(customToken);
      }
    } catch (_) {}
  }

  Future<void> getFirebaseToken() async {
    _ensureTokenSubscription();
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _authRepository.getFirebaseToken();
      emit(state.copyWith(isLoading: false, firebaseToken: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> registerDeviceToken(String? token) async {
    _ensureTokenSubscription();
    await _registerDeviceToken(token);
  }

  Future<void> deleteToken() async {
    await FcmService().deleteToken();
  }

  Future<void> firebaseSignOut() async {
    await FirebaseAuthService().signOut();
  }

  @override
  Future<void> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }
}
