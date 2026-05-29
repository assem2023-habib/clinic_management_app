import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/weak_connection/weak_connection_screen.dart';

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
  group('WeakConnectionScreen', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.text(AppStrings.wcTitle), findsOneWidget);
      expect(find.text(AppStrings.wcMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders wifi_off icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders waiting button (disabled)', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.text(AppStrings.wcWaiting), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders retry button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.text(AppStrings.wcRetry), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders signal strength meter', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.text(AppStrings.wcSignalStrength), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders refresh icon on retry button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders CircularProgressIndicator in waiting button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(buildTestWidget(
        WeakConnectionScreen(onRetry: () => retried = true),
      ));
      await tester.pump();

      await tester.scrollUntilVisible(find.text(AppStrings.wcRetry), 100);
      await tester.tap(find.text(AppStrings.wcRetry));
      expect(retried, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('waiting button is disabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, AppStrings.wcWaiting));
      expect(button.onPressed, isNull);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('does not crash when onRetry is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WeakConnectionScreen()));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.wcRetry), 100);
      await tester.tap(find.text(AppStrings.wcRetry));
      await tester.pump();
      expect(find.text(AppStrings.wcTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
