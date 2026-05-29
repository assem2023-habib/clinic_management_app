import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/errors/error_types.dart';

void main() {
  group('ErrorType', () {
    test('has all expected values', () {
      expect(ErrorType.values, hasLength(5));
      expect(ErrorType.values, containsAll([
        ErrorType.network,
        ErrorType.rateLimit,
        ErrorType.serverError,
        ErrorType.timeout,
        ErrorType.unknown,
      ]));
    });
  });

  group('AppFailure', () {
    test('creates with message and default type', () {
      const failure = AppFailure('Something went wrong');
      expect(failure.message, 'Something went wrong');
      expect(failure.type, ErrorType.unknown);
    });

    test('creates with message and custom type', () {
      const failure = AppFailure('Rate limit exceeded', type: ErrorType.rateLimit);
      expect(failure.message, 'Rate limit exceeded');
      expect(failure.type, ErrorType.rateLimit);
    });

    test('creates with network error type', () {
      const failure = AppFailure('No internet', type: ErrorType.network);
      expect(failure.message, 'No internet');
      expect(failure.type, ErrorType.network);
    });

    test('supports value equality', () {
      const a = AppFailure('Error msg', type: ErrorType.serverError);
      const b = AppFailure('Error msg', type: ErrorType.serverError);
      expect(a, equals(b));
    });

    test('not equal when message differs', () {
      const a = AppFailure('Error A');
      const b = AppFailure('Error B');
      expect(a, isNot(equals(b)));
    });

    test('not equal when type differs', () {
      const a = AppFailure('Error', type: ErrorType.timeout);
      const b = AppFailure('Error', type: ErrorType.network);
      expect(a, isNot(equals(b)));
    });
  });
}
