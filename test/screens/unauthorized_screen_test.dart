import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/unauthorized/unauthorized_screen.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: child,
    ),
  );
}

void main() {
  group('UnauthorizedScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders login button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaLogin), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders go home button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaGoHome), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders footer', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaFooter), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders lock icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders encryption data node', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaEncryption), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders data protection node', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaDataProtection), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders secure protocol node', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.uaSecureProtocol), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders arrow_forward back button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onLogin when login tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        UnauthorizedScreen(onLogin: () => called = true),
      ));
      await tester.pump();
      await tester.tap(find.text(AppStrings.uaLogin));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onGoHome when go home tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        UnauthorizedScreen(onGoHome: () => called = true),
      ));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.uaGoHome), 100);
      await tester.tap(find.text(AppStrings.uaGoHome));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders CustomPaint for particles', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders login icon on button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.login_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders home icon on button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UnauthorizedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
