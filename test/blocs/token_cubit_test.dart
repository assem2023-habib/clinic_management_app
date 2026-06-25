import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/presentation/blocs/token/token_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late TokenCubit cubit;

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = TokenCubit(authRepository: authRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('TokenCubit - getFirebaseToken', () {
    test('initial state has no token and not loading', () {
      expect(cubit.state.firebaseToken, isNull);
      expect(cubit.state.isLoading, false);
      expect(cubit.state.error, isNull);
    });

    test('emits loading then firebaseToken on success', () async {
      const tokenResult = {'firebase_token': 'custom-token-123'};
      when(() => authRepository.getFirebaseToken()).thenAnswer((_) async => tokenResult);

      final expected = [
        const TokenState(isLoading: true),
        const TokenState(isLoading: false, firebaseToken: {'firebase_token': 'custom-token-123'}),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      await cubit.getFirebaseToken();
    });

    test('emits loading then error on failure', () async {
      when(() => authRepository.getFirebaseToken()).thenThrow(Exception('Token error'));

      final expected = [
        const TokenState(isLoading: true),
        const TokenState(isLoading: false, error: 'Exception: Token error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      await cubit.getFirebaseToken();
    });
  });
}
