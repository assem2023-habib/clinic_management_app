import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late ProfileCubit cubit;

  const testUser = UserEntity(
    id: 'u1',
    firstName: 'أحمد',
    lastName: 'محمد',
    username: 'ahmed_m',
    email: 'ahmed@test.com',
    gender: 'male',
  );

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = ProfileCubit(authRepository: authRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProfileCubit - loadProfile', () {
    test('initial state is ProfileState with no user', () {
      expect(cubit.state.user, isNull);
      expect(cubit.state.isLoading, false);
    });

    test('emits loading then success on loadProfile', () async {
      when(() => authRepository.getProfile()).thenAnswer((_) async => testUser);

      final expected = [
        const ProfileState(isLoading: true),
        const ProfileState(isLoading: false, user: testUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.loadProfile();
    });

    test('emits loading then error on loadProfile failure', () async {
      when(() => authRepository.getProfile()).thenThrow(Exception('Network error'));

      final expected = [
        const ProfileState(isLoading: true),
        const ProfileState(isLoading: false, error: 'Exception: Network error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.loadProfile();
    });
  });

  group('ProfileCubit - updateProfile', () {
    test('emits saving then user on updateProfile', () async {
      when(() => authRepository.updateProfile(any())).thenAnswer((_) async => testUser);

      final expected = [
        const ProfileState(isSaving: true),
        const ProfileState(isSaving: false, user: testUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.updateProfile({'first_name': 'أحمد'});
    });
  });

  group('ProfileCubit - changePassword', () {
    test('emits saving then passwordChanged on success', () async {
      when(() => authRepository.changePassword(any(), any())).thenAnswer((_) async {});

      final expected = [
        const ProfileState(isSaving: true),
        const ProfileState(isSaving: false, passwordChanged: true),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.changePassword('old', 'new');
    });

    test('emits saving then error on failure', () async {
      when(() => authRepository.changePassword(any(), any())).thenThrow(Exception('Wrong password'));

      final expected = [
        const ProfileState(isSaving: true),
        const ProfileState(isSaving: false, error: 'Exception: Wrong password'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.changePassword('old', 'wrong');
    });
  });

  group('ProfileCubit - deleteAccount', () {
    test('emits saving then accountDeleted on success', () async {
      when(() => authRepository.deleteAccount(any())).thenAnswer((_) async {});

      final expected = [
        const ProfileState(isSaving: true),
        const ProfileState(isSaving: false, accountDeleted: true),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.deleteAccount('password');
    });

    test('emits saving then error on failure', () async {
      when(() => authRepository.deleteAccount(any())).thenThrow(Exception('Wrong password'));

      final expected = [
        const ProfileState(isSaving: true),
        const ProfileState(isSaving: false, error: 'Exception: Wrong password'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.deleteAccount('wrong');
    });
  });

  group('ProfileCubit - clearError', () {
    test('clears error from state', () {
      cubit = ProfileCubit(authRepository: authRepository);
      cubit.emit(const ProfileState(error: 'Some error'));
      cubit.clearError();
      expect(cubit.state.error, isNull);
    });
  });
}
