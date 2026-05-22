import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/screens/profile/delete_account_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late ProfileCubit cubit;

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = ProfileCubit(authRepository: authRepository);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      routes: {
        AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
      },
      home: BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: const DeleteAccountScreen(),
      ),
    );
  }

  testWidgets('renders warning and password field', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text('حَذْفُ الحِسَابِ'), findsAtLeast(1));
    expect(find.text('تَحْذِيرٌ: هَذَا الإِجْرَاءُ نِهَائِيٌّ'), findsOneWidget);
    expect(find.text('أَدْخِلْ كَلِمَةَ السِّرِّ لِلتَّأْكِيدِ'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
  });

  testWidgets('shows snackbar on empty password', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.widgetWithText(ElevatedButton, 'حَذْفُ الحِسَابِ'));
    await tester.pump();
    expect(find.text('يَجِبُ إِدْخَالُ كَلِمَةِ السِّرِّ لِتَأْكِيدِ الحَذْفِ'), findsOneWidget);
  });

  testWidgets('calls deleteAccount and navigates on success', (tester) async {
    when(() => authRepository.deleteAccount(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(
      find.widgetWithText(TextFormField, 'أَدْخِلْ كَلِمَةَ السِّرِّ لِلتَّأْكِيدِ'),
      'mypassword',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'حَذْفُ الحِسَابِ'));
    await tester.pump();
    verify(() => authRepository.deleteAccount('mypassword')).called(1);
    cubit.emit(cubit.state.copyWith(isSaving: true));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    cubit.emit(cubit.state.copyWith(isSaving: false, accountDeleted: true));
    await tester.pump();
    expect(find.text('Login Screen'), findsAtLeast(1));
  });
}
