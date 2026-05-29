import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/server_error/server_error_screen.dart';

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
  group('ServerErrorScreen', () {
    testWidgets('renders title, message and icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServerErrorScreen()));

      expect(find.text(AppStrings.seTitle), findsOneWidget);
      expect(find.text(AppStrings.seMessage), findsOneWidget);
      expect(find.byIcon(Icons.dns_rounded), findsOneWidget);
    });

    testWidgets('renders retry button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServerErrorScreen()));

      expect(find.text(AppStrings.seRetry), findsOneWidget);
    });

    testWidgets('renders go home button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServerErrorScreen()));

      expect(find.text(AppStrings.seGoHome), findsOneWidget);
    });

    testWidgets('renders status chips', (tester) async {
      await tester.pumpWidget(buildTestWidget(const ServerErrorScreen()));

      expect(find.text(AppStrings.seServerBusy), findsOneWidget);
      expect(find.text(AppStrings.seTryAgain), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(buildTestWidget(
        ServerErrorScreen(onRetry: () => retried = true),
      ));

      await tester.scrollUntilVisible(find.text(AppStrings.seRetry), 100);
      await tester.tap(find.text(AppStrings.seRetry));
      expect(retried, true);
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
          child: const ServerErrorScreen(),
        ),
      ));

      await tester.scrollUntilVisible(find.text(AppStrings.seGoHome), 100);
      await tester.tap(find.text(AppStrings.seGoHome));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });
  });
}
