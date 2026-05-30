class LoginRequest {
  final String email;
  final String password;
  final String? deviceFingerprint;

  const LoginRequest({
    required this.email,
    required this.password,
    this.deviceFingerprint,
  });

  Map<String, dynamic> toMap() => {
    'email': email,
    'password': password,
    if (deviceFingerprint != null) 'device_fingerprint': deviceFingerprint,
  };
}
