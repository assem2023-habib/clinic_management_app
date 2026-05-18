import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
  });

  AuthState copyWith({bool? isAuthenticated, String? userId, String? userName}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, userId, userName];
}

class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required super.userId, required super.userName});
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

  void login(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      emit(AuthAuthenticated(userId: 'admin1', userName: 'Admin User'));
    } else {
      emit(const AuthState(isAuthenticated: false));
    }
  }

  void logout() {
    emit(const AuthState(isAuthenticated: false));
  }
}
