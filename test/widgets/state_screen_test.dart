import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/state_screen/state_screen.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('StateScreen', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StateScreen(
          showAppBar: false,
          title: 'Test Title',
          message: 'Test Message',
        ),
      ));

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StateScreen(
          showAppBar: false,
          title: 'Title',
          message: 'Message',
          icon: Icons.wifi_off_rounded,
        ),
      ));

      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });

    testWidgets('renders primary action button', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        StateScreen(
          showAppBar: false,
          title: 'Title',
          message: 'Message',
          primaryAction: const StateAction(
            label: 'إعادة المحاولة',
            icon: Icons.refresh_rounded,
            onTap: null,
          ),
        ),
      ));

      expect(find.text('إعادة المحاولة'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'إعادة المحاولة'));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders secondary action button', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        StateScreen(
          showAppBar: false,
          title: 'Title',
          message: 'Message',
          primaryAction: const StateAction(
            label: 'Primary',
            onTap: null,
          ),
          secondaryAction: const StateAction(
            label: 'العودة للرئيسية',
            isPrimary: false,
            onTap: null,
          ),
        ),
      ));

      expect(find.text('العودة للرئيسية'), findsOneWidget);
    });

    testWidgets('renders status chips', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StateScreen(
          showAppBar: false,
          title: 'Title',
          message: 'Message',
          statusChips: [
            StatusChip(icon: Icons.wifi_off_rounded, label: 'انقطع الاتصال'),
            StatusChip(icon: Icons.dns_rounded, label: 'الخادم غير متاح'),
          ],
        ),
      ));

      expect(find.text('انقطع الاتصال'), findsOneWidget);
      expect(find.text('الخادم غير متاح'), findsOneWidget);
    });

    testWidgets('renders bottom widget', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StateScreen(
          showAppBar: false,
          title: 'Title',
          message: 'Message',
          bottomWidget: Text('Bottom Widget'),
        ),
      ));

      expect(find.text('Bottom Widget'), findsOneWidget);
    });

    testWidgets('renders with app bar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const StateScreen(
            showAppBar: true,
            appBarTitle: 'تطبيق العيادة',
            title: 'Title',
            message: 'Message',
          ),
        ),
      ));

      expect(find.text('تطبيق العيادة'), findsOneWidget);
    });

    testWidgets('primary button is disabled when onTap is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StateScreen(
          showAppBar: false,
          title: 'Title',
          message: 'Message',
          primaryAction: StateAction(
            label: 'إعادة المحاولة',
            onTap: null,
          ),
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'إعادة المحاولة'));
      expect(button.onPressed, isNull);
    });
  });

  group('OfflineScreen style integration', () {
    testWidgets('renders offline illustration icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StateScreen(
          showAppBar: false,
          title: AppStrings.olTitle,
          message: AppStrings.olMessage,
          icon: Icons.wifi_off_rounded,
          primaryAction: StateAction(
            label: AppStrings.olRetry,
            icon: Icons.refresh_rounded,
          ),
        ),
      ));

      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.text(AppStrings.olTitle), findsOneWidget);
      expect(find.text(AppStrings.olMessage), findsOneWidget);
    });
  });
}
