import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/forbidden/forbidden_screen.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    routes: {
      AppRoutes.dashboard: (_) => const Scaffold(body: Text('Dashboard Screen')),
    },
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: child,
    ),
  );
}

void main() {
  group('ForbiddenScreen', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ForbiddenScreen()));
      expect(find.text(AppStrings.fbTitle), findsOneWidget);
      expect(find.text(AppStrings.fbMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ForbiddenScreen()));
      expect(find.text(AppStrings.appName), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders shield icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ForbiddenScreen()));
      expect(find.byIcon(Icons.shield_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders go home button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ForbiddenScreen()));
      expect(find.text(AppStrings.fbGoHome), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders contact support button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ForbiddenScreen()));
      expect(find.text(AppStrings.fbContactSupport), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onContactSupport when support button is tapped', (tester) async {
      var contacted = false;
      await tester.pumpWidget(buildTestWidget(
        ForbiddenScreen(onContactSupport: () => contacted = true),
      ));

      await tester.scrollUntilVisible(find.text(AppStrings.fbContactSupport), 100);
      await tester.tap(find.text(AppStrings.fbContactSupport));
      expect(contacted, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('navigates to dashboard on go home', (tester) async {
      await tester.pumpWidget(MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        routes: {
          AppRoutes.dashboard: (_) => const Scaffold(body: Text('Dashboard Screen')),
        },
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const ForbiddenScreen(),
        ),
      ));

      await tester.scrollUntilVisible(find.text(AppStrings.fbGoHome), 100);
      await tester.tap(find.text(AppStrings.fbGoHome));
      await tester.pump();
      await tester.pump();
      expect(find.text('Dashboard Screen'), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
