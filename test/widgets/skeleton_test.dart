import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

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

/// flutter_animate creates pending timers in tests via FakeAsync.
/// Disposing the widget and pumping extra time lets them fire and not reschedule.
Future<void> disposeAnimatedWidget(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 3));
}

void main() {
  group('SkeletonBox', () {
    testWidgets('renders with default dimensions', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonBox()));
      expect(find.byType(SkeletonBox), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });

    testWidgets('renders with custom dimensions', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SkeletonBox(width: 100, height: 50, borderRadius: 8),
      ));
      expect(find.byType(SkeletonBox), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });
  });

  group('SkeletonCircle', () {
    testWidgets('renders with default radius', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonCircle()));
      expect(find.byType(SkeletonCircle), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });

    testWidgets('renders with custom radius', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonCircle(radius: 40)));
      expect(find.byType(SkeletonCircle), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });
  });

  group('SkeletonLine', () {
    testWidgets('renders with default height', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonLine()));
      expect(find.byType(SkeletonLine), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });

    testWidgets('renders with custom height', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonLine(height: 20)));
      expect(find.byType(SkeletonLine), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });
  });

  group('SkeletonCard', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonCard()));
      expect(find.byType(SkeletonCard), findsOneWidget);
      await disposeAnimatedWidget(tester);
    });
  });

  group('SkeletonList', () {
    testWidgets('renders default count', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonList()));
      expect(find.byType(SkeletonCard), findsNWidgets(5));
      await disposeAnimatedWidget(tester);
    });

    testWidgets('renders custom count', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonList(count: 3)));
      expect(find.byType(SkeletonCard), findsNWidgets(3));
      await disposeAnimatedWidget(tester);
    });
  });

  group('SkeletonProfile', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SkeletonProfile()));
      expect(find.byType(SkeletonProfile), findsOneWidget);
      expect(find.byType(SkeletonCircle), findsAtLeast(1));
      expect(find.byType(SkeletonLine), findsAtLeast(6));
      await disposeAnimatedWidget(tester);
    });
  });
}
