import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/suspended/suspended_screen.dart';

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
  group('SuspendedScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.spTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.spMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders reason label and value', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.spReasonLabel), findsOneWidget);
      expect(find.text(AppStrings.spReasonValue), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders both action buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.spContactSupport), findsOneWidget);
      expect(find.text(AppStrings.spLogout), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders footer', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.text(AppStrings.spFooter), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders gpp_maybe icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.gpp_maybe_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders support_agent icon on button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.support_agent_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders logout icon on button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onContactSupport when support tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        SuspendedScreen(onContactSupport: () => called = true),
      ));
      await tester.pump();
      await tester.tap(find.text(AppStrings.spContactSupport));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onLogout when logout tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        SuspendedScreen(onLogout: () => called = true),
      ));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.spLogout), 100);
      await tester.tap(find.text(AppStrings.spLogout));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders CustomPaint for moving particles', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders arrow_back back button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SuspendedScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
