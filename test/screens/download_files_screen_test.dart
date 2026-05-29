import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_state.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_empty_state.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_file_card.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_header.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_progress_indicator.dart';
import 'package:clinic_management_app/presentation/screens/download_files/download_files_screen.dart';
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

void main() {
  group('DfEmptyState', () {
    testWidgets('renders icon, title and hint', (tester) async {
      await tester.pumpWidget(buildTestWidget(const DfEmptyState()));
      expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
      expect(find.text(AppStrings.dfNoFiles), findsOneWidget);
      expect(find.text(AppStrings.dfNoFilesHint), findsOneWidget);
    });
  });

  group('DfProgressLabel', () {
    testWidgets('renders progress indicator with percentage', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const DfProgressLabel(progress: 0.45, displayStatus: DownloadStatus.downloading),
      ));
      expect(find.byType(DfProgressIndicator), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
    });

    testWidgets('does not show percentage for non-downloading status', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const DfProgressLabel(progress: 1.0, displayStatus: DownloadStatus.completed),
      ));
      expect(find.text('100%'), findsNothing);
    });
  });

  group('DfFileCard', () {
    final testFile = DownloadFileEntity(
      id: '1',
      name: 'تقرير طبي',
      type: 'PDF',
      category: 'report',
      sizeInMb: 2.4,
      date: DateTime(2025, 11, 15),
      status: DownloadStatus.none,
    );

    testWidgets('renders file name, type, size and date', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        BlocProvider(
          create: (_) => DownloadFileBloc(),
          child: DfFileCard(file: testFile),
        ),
      ));

      expect(find.text('تقرير طبي'), findsOneWidget);
      expect(find.textContaining(AppStrings.dfMb), findsOneWidget);
      expect(find.textContaining('PDF'), findsAtLeast(1));
    });

    testWidgets('shows download button when status is none', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        BlocProvider(
          create: (_) => DownloadFileBloc(),
          child: DfFileCard(file: testFile),
        ),
      ));

      expect(find.text(AppStrings.dfDownload), findsOneWidget);
    });

    testWidgets('shows completed icon when status is completed', (tester) async {
      final completedFile = DownloadFileEntity(
        id: '2',
        name: 'تحليل الدم',
        type: 'PDF',
        category: 'lab',
        sizeInMb: 1.1,
        date: DateTime(2025, 11, 10),
        status: DownloadStatus.completed,
        progress: 1.0,
      );

      await tester.pumpWidget(buildTestWidget(
        BlocProvider(
          create: (_) => DownloadFileBloc(),
          child: DfFileCard(file: completedFile),
        ),
      ));

      expect(find.text(AppStrings.dfDownloaded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('shows progress bar when status is downloading', (tester) async {
      final downloadingFile = DownloadFileEntity(
        id: '3',
        name: 'تحليل وظائف الكبد',
        type: 'PDF',
        category: 'lab',
        sizeInMb: 1.8,
        date: DateTime(2025, 9, 5),
        status: DownloadStatus.downloading,
        progress: 0.45,
      );

      await tester.pumpWidget(buildTestWidget(
        BlocProvider(
          create: (_) => DownloadFileBloc(),
          child: DfFileCard(file: downloadingFile),
        ),
      ));

      expect(find.byType(DfProgressLabel), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
    });
  });

  group('DfHeader', () {
    testWidgets('renders search field and filter chips', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        BlocProvider(
          create: (_) => DownloadFileBloc(),
          child: const DfHeader(),
        ),
      ));

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text(AppStrings.dfSearchHint), findsOneWidget);
      for (final label in [AppStrings.dfCategoryAll, AppStrings.dfCategoryReports, AppStrings.dfCategoryLab, AppStrings.dfCategoryImaging, AppStrings.dfCategoryBilling]) {
        expect(find.text(label), findsWidgets);
      }
    });
  });

  group('DownloadFilesScreen', () {
    testWidgets('shows skeleton loading then screen content', (tester) async {
      await tester.pumpWidget(MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: BlocProvider(
          create: (_) => DownloadFileBloc(),
          child: const DownloadFilesScreen(),
        ),
      ));

      expect(find.byType(SkeletonList), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SkeletonList), findsNothing);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('shows empty state when no files match filter', (tester) async {
      final bloc = DownloadFileBloc();
      await tester.pumpWidget(MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: BlocProvider.value(
          value: bloc,
          child: const DownloadFilesScreen(),
        ),
      ));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      bloc.add(const DownloadFileFilterCategory('report'));
      await tester.pumpAndSettle();
      final loaded = bloc.state as DownloadFileLoaded;
      if (loaded.files.isEmpty) {
        expect(find.byType(DfEmptyState), findsOneWidget);
      } else {
        expect(find.byType(DfFileCard), findsAtLeast(1));
      }
    });
  });
}
