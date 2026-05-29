import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/rate_limit/rate_limit_screen.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: child,
  );
}

void main() {
  group('RateLimitScreen', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      expect(find.text(AppStrings.rlTitle), findsOneWidget);
      expect(find.text(AppStrings.rlMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('renders shield icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('renders waiting timer label', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      expect(find.text(AppStrings.rlWaitingTimer), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('shows ready state when no retryAfter', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      expect(find.text(AppStrings.rlReadyNow), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('renders retry button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      expect(find.text(AppStrings.rlRetry), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('renders contact support link', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      expect(find.text(AppStrings.rlContactSupport), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('retry button is enabled when no countdown', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, AppStrings.rlRetry),
      );
      expect(button.onPressed, isNotNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('retry button is disabled during countdown', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const RateLimitScreen(retryAfterSeconds: 30)),
      );
      await tester.pump();
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, AppStrings.rlRetry),
      );
      expect(button.onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('shows countdown seconds when retryAfterSeconds provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const RateLimitScreen(retryAfterSeconds: 30)),
      );
      await tester.pump();
      expect(find.text('30 ${AppStrings.rlSecond}'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('calls onRetry when retry button tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        buildTestWidget(RateLimitScreen(onRetry: () => retried = true)),
      );
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.rlRetry), 100);
      await tester.tap(find.text(AppStrings.rlRetry));
      expect(retried, true);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('does not crash when onRetry is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.rlRetry), 100);
      await tester.tap(find.text(AppStrings.rlRetry));
      await tester.pump();
      expect(find.text(AppStrings.rlTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('calls onContactSupport when link tapped', (tester) async {
      var contacted = false;
      await tester.pumpWidget(
        buildTestWidget(
          RateLimitScreen(onContactSupport: () => contacted = true),
        ),
      );
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.rlContactSupport), 100);
      await tester.tap(find.text(AppStrings.rlContactSupport));
      expect(contacted, true);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('does not crash when onContactSupport is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const RateLimitScreen()));
      await tester.pump();
      await tester.scrollUntilVisible(find.text(AppStrings.rlContactSupport), 100);
      await tester.tap(find.text(AppStrings.rlContactSupport));
      await tester.pump();
      expect(find.text(AppStrings.rlTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('countdown progresses and enables button', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const RateLimitScreen(retryAfterSeconds: 2)),
      );
      await tester.pump();

      expect(find.text('2 ${AppStrings.rlSecond}'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('1 ${AppStrings.rlSecond}'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text(AppStrings.rlReadyNow), findsOneWidget);

      await tester.scrollUntilVisible(find.text(AppStrings.rlRetry), 100);
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, AppStrings.rlRetry),
      );
      expect(button.onPressed, isNotNull);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
