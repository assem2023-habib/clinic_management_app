enum ErrorType { network, rateLimit, serverError, timeout, unknown }

class AppFailure {
  final String message;
  final ErrorType type;

  const AppFailure(this.message, {this.type = ErrorType.unknown});
}
