import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/upload_files/upload_files_screen.dart';

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
  group('UploadFilesScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders active upload label', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufActiveUploadLabel), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders recent uploads label', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufRecentUploadsLabel), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders view all button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufViewAll), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders cancel upload button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufCancelUpload), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders security title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufSecurityTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders security message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufSecurityMessage), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders bottom nav tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text(AppStrings.ufNavDashboard), findsOneWidget);
      expect(find.text(AppStrings.ufNavRecords), findsOneWidget);
      expect(find.text(AppStrings.ufNavUpload), findsOneWidget);
      expect(find.text(AppStrings.ufNavProfile), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders file names', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.text('Radiology_Report_Oct_2023.pdf'), findsOneWidget);
      expect(find.text('Blood Test Results.pdf'), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders arrow_back back button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders CustomPaint for particles', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadFilesScreen()));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onBack when back button tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        UploadFilesScreen(onBack: () => called = true),
      ));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calls onViewAll when view all tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(buildTestWidget(
        UploadFilesScreen(onViewAll: () => called = true),
      ));
      await tester.pump();
      await tester.tap(find.text(AppStrings.ufViewAll));
      expect(called, true);
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
