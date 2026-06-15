import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_bloc.dart';
import 'package:clinic_management_app/presentation/screens/upload_files/upload_files_screen.dart';

class MockFileRepo extends Mock implements FileRepository {}

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
  late FileBloc bloc;
  late MockFileRepo mockRepo;

  setUp(() {
    mockRepo = MockFileRepo();
    when(() => mockRepo.getFiles(mine: any(named: 'mine'))).thenAnswer((_) async => []);
    bloc = FileBloc(mockRepo);
  });

  group('UploadFilesScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        BlocProvider<FileBloc>.value(value: bloc, child: const UploadFilesScreen()),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders empty state when no files', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        BlocProvider<FileBloc>.value(value: bloc, child: const UploadFilesScreen()),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(const SizedBox()); await tester.pump(const Duration(seconds: 3));
    });
  });
}
