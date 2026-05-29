import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/offline/offline_screen.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    routes: {
      AppRoutes.dashboard: (_) => const Scaffold(body: Text('Dashboard Screen')),
    },
    home: child,
  );
}

void main() {
  group('OfflineScreen', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.text(AppStrings.olTitle), findsOneWidget);
      expect(find.text(AppStrings.olMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders app name in header', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.text(AppStrings.appName), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders back button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders retry button with refresh icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.text(AppStrings.olRetry), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders show cached button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.text(AppStrings.olShowCached), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders status details', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.text(AppStrings.olSignalLost), findsOneWidget);
      expect(find.text(AppStrings.olServerUnreachable), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.dns_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders fallback icon when network image fails', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.signal_cellular_off_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(buildTestWidget(
        OfflineScreen(onRetry: () => retried = true),
      ));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.olRetry), 100);
      await tester.tap(find.text(AppStrings.olRetry));
      expect(retried, true);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('does not crash when onRetry is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.olRetry), 100);
      await tester.tap(find.text(AppStrings.olRetry));
      await tester.pump();
      expect(find.text(AppStrings.olTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onShowCached when provided', (tester) async {
      var cached = false;
      await tester.pumpWidget(buildTestWidget(
        OfflineScreen(onShowCached: () => cached = true),
      ));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.olShowCached), 100);
      await tester.tap(find.text(AppStrings.olShowCached));
      expect(cached, true);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('navigates to dashboard when show cached tapped with no callback', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OfflineScreen()));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.olShowCached), 100);
      await tester.tap(find.text(AppStrings.olShowCached));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Dashboard Screen'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
