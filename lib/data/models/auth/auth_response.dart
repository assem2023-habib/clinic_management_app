import 'package:clinic_management_app/data/models/user_model.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
  final UserModel? user;
  final String? message;

  const AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.user,
    this.message,
  });

  bool get isAuthenticated => accessToken != null;

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    if (data == null) {
      return AuthResponse(message: map['message'] as String?);
    }
    final dataMap = data as Map<String, dynamic>;
    return AuthResponse(
      accessToken: dataMap['access_token'] as String?,
      refreshToken: dataMap['refresh_token'] as String?,
      expiresIn: dataMap['expires_in'] as int?,
      tokenType: dataMap['token_type'] as String? ?? 'Bearer',
      user: dataMap['user'] != null
          ? UserModel.fromMap(dataMap['user'] as Map<String, dynamic>)
          : null,
      message: map['message'] as String?,
    );
  }
}
