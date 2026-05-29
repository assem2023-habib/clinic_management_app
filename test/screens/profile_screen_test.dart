import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/screens/profile/profile_screen.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

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
    when(() => authRepository.getProfile()).thenAnswer((_) async => testUser);
    cubit = ProfileCubit(authRepository: authRepository);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      routes: {
        AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
        AppRoutes.changePassword: (_) => const Scaffold(body: Text('Change Password Screen')),
        AppRoutes.deleteAccount: (_) => const Scaffold(body: Text('Delete Account Screen')),
      },
      home: BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: const ProfileScreen(),
      ),
    );
  }

  testWidgets('shows loading then user info', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(SkeletonProfile), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('المَلَفُّ الشَّخْصِيُّ'), findsOneWidget);
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('محمد'), findsOneWidget);
  });

  testWidgets('shows error and retry on failure', (tester) async {
    when(() => authRepository.getProfile()).thenThrow(Exception('Network error'));
    cubit = ProfileCubit(authRepository: authRepository);

    await tester.pumpWidget(
      MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: BlocProvider<ProfileCubit>.value(
          value: cubit,
          child: const ProfileScreen(),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('تَعَذَّرَ تَحْمِيلُ المَلَفِّ'), findsOneWidget);
    expect(find.text('إِعَادَةُ المُحَاوَلَةِ'), findsOneWidget);
  });

  testWidgets('shows action buttons', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('تَغْيِيرُ كَلِمَةِ السِّرِّ'),
      find.byType(SingleChildScrollView),
      const Offset(0, -200),
    );
    expect(find.text('تَغْيِيرُ كَلِمَةِ السِّرِّ'), findsOneWidget);
    expect(find.text('حَذْفُ الحِسَابِ'), findsOneWidget);
  });

  testWidgets('shows edit dialog on tap info tile', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('أحمد'));
    await tester.pump();
    expect(find.textContaining('الاسْمُ الأَوَّلُ'), findsAtLeast(1));
  });

  testWidgets('accepts delete', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    final scrollable = find.byType(SingleChildScrollView);
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حَذْفُ الحِسَابِ'));
    await tester.pump();
    expect(find.textContaining('مُتَأَكِّدٌ'), findsOneWidget);
    await tester.tap(find.text('تَأْكِيدُ الحَذْفِ'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Account Screen'), findsOneWidget);
  });
}
