import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/session_expired/session_expired_screen.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    routes: {
      AppRoutes.dashboard: (_) => const Scaffold(body: Text('Dashboard Screen')),
      AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
    },
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: child,
    ),
  );
}

void main() {
  group('SessionExpiredScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.text(AppStrings.sesTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.text(AppStrings.sesMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders all three buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.text(AppStrings.sesLogin), findsOneWidget);
      expect(find.text(AppStrings.sesGoHome), findsOneWidget);
      expect(find.text(AppStrings.sesCloseApp), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders footer', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.text(AppStrings.sesFooter), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders timer_off icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.byIcon(Icons.timer_off_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders lock badge icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onLogin when login tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        SessionExpiredScreen(onLogin: () => called = true),
      ));
      await tester.tap(find.text(AppStrings.sesLogin));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onGoHome when go home tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        SessionExpiredScreen(onGoHome: () => called = true),
      ));
      await tester.tap(find.text(AppStrings.sesGoHome));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onCloseApp when close app tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        SessionExpiredScreen(onCloseApp: () => called = true),
      ));
      await tester.tap(find.text(AppStrings.sesCloseApp));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('navigates to login by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      await tester.tap(find.text(AppStrings.sesLogin));
      await tester.pump();
      await tester.pump();
      expect(find.text('Login Screen'), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('navigates to dashboard by default on go home', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      await tester.tap(find.text(AppStrings.sesGoHome));
      await tester.pump();
      await tester.pump();
      expect(find.text('Dashboard Screen'), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders CustomPaint for particles and rotating glow', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SessionExpiredScreen()));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
