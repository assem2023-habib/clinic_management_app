import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/screens/profile/change_password_screen.dart';

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
      home: Builder(
        builder: (context) => Scaffold(
          body: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      ),
    );
  }

  testWidgets('renders all fields and button', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text('تَغْيِيرُ كَلِمَةِ السِّرِّ'), findsWidgets);
    expect(find.text('كَلِمَةُ السِّرِّ الحَالِيَّةُ'), findsOneWidget);
    expect(find.text('كَلِمَةُ السِّرِّ الجَدِيدَةُ'), findsOneWidget);
    expect(find.text('تَأْكِيدُ كَلِمَةِ السِّرِّ الجَدِيدَةِ'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    final visibilityIcons = find.byIcon(Icons.visibility_rounded);
    expect(visibilityIcons, findsNWidgets(3));
    await tester.tap(visibilityIcons.first);
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off_rounded), findsAtLeast(1));
  });

  testWidgets('shows snackbar on password mismatch', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    final oldField = find.widgetWithText(TextFormField, 'كَلِمَةُ السِّرِّ الحَالِيَّةُ');
    await tester.enterText(oldField, 'oldpass');
    final newField = find.widgetWithText(TextFormField, 'كَلِمَةُ السِّرِّ الجَدِيدَةُ');
    await tester.enterText(newField, 'newpass1');
    final confirmField = find.widgetWithText(TextFormField, 'تَأْكِيدُ كَلِمَةِ السِّرِّ الجَدِيدَةِ');
    await tester.enterText(confirmField, 'newpass2');
    await tester.tap(find.text('حِفْظُ'));
    await tester.pump();
    expect(find.text('كَلِمَتَا السِّرِّ غَيْرُ مُتَطَابِقَتَيْنِ'), findsOneWidget);
  });

  testWidgets('calls changePassword on valid submit', (tester) async {
    when(() => authRepository.changePassword(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget());
    final oldField = find.widgetWithText(TextFormField, 'كَلِمَةُ السِّرِّ الحَالِيَّةُ');
    await tester.enterText(oldField, 'oldpass');
    final newField = find.widgetWithText(TextFormField, 'كَلِمَةُ السِّرِّ الجَدِيدَةُ');
    await tester.enterText(newField, 'newpass1');
    final confirmField = find.widgetWithText(TextFormField, 'تَأْكِيدُ كَلِمَةِ السِّرِّ الجَدِيدَةِ');
    await tester.enterText(confirmField, 'newpass1');
    await tester.tap(find.text('حِفْظُ'));
    await tester.pump();
    verify(() => authRepository.changePassword('oldpass', 'newpass1')).called(1);
  });

  testWidgets('shows snackbar on success', (tester) async {
    when(() => authRepository.changePassword(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget());
    final oldField = find.widgetWithText(TextFormField, 'كَلِمَةُ السِّرِّ الحَالِيَّةُ');
    await tester.enterText(oldField, 'old');
    final newField = find.widgetWithText(TextFormField, 'كَلِمَةُ السِّرِّ الجَدِيدَةُ');
    await tester.enterText(newField, 'new12345');
    final confirmField = find.widgetWithText(TextFormField, 'تَأْكِيدُ كَلِمَةِ السِّرِّ الجَدِيدَةِ');
    await tester.enterText(confirmField, 'new12345');
    await tester.tap(find.text('حِفْظُ'));
    await tester.pump();
    cubit.emit(cubit.state.copyWith(isSaving: false, passwordChanged: true));
    await tester.pump();
    expect(find.text('تَمَّ تَغْيِيرُ كَلِمَةِ السِّرِّ بِنَجَاحٍ'), findsOneWidget);
  });
}
