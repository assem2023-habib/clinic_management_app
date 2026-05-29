import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/service_stopped/service_stopped_screen.dart';

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
  group('ServiceStoppedScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.text(AppStrings.ssTitle), findsOneWidget);
    });

    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.text(AppStrings.ssMessage), findsOneWidget);
    });

    testWidgets('renders OFFLINE status badge', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.text(AppStrings.ssStatusOffline), findsOneWidget);
    });

    testWidgets('renders retry and go home buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.text(AppStrings.ssRetry), findsOneWidget);
      expect(find.text(AppStrings.ssGoHome), findsOneWidget);
    });

    testWidgets('renders error code', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.text(AppStrings.ssErrorCode), findsOneWidget);
    });

    testWidgets('renders cloud_off icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
    });

    testWidgets('renders construction badge', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.construction_rounded), findsOneWidget);
    });

    testWidgets('renders refresh and home icons on buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(buildTestWidget(
        ServiceStoppedScreen(onRetry: () => retried = true),
      ));
      await tester.pump();

      await tester.tap(find.text(AppStrings.ssRetry));
      expect(retried, true);
    });

    testWidgets('navigates to dashboard on go home', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.ssGoHome));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });

    testWidgets('renders CustomPaint for particles', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServiceStoppedScreen()));
      await tester.pump();

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
