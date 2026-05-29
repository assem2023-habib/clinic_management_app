import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_state.dart';

void main() {
  late DownloadFileBloc bloc;

  setUp(() {
    bloc = DownloadFileBloc();
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with DownloadFileInitial', () {
      expect(bloc.state, isA<DownloadFileInitial>());
    });
  });

  group('DownloadFileLoadAll', () {
    test('emits Loading then Loaded with files', () async {
      final expected = [
        isA<DownloadFileLoading>(),
        isA<DownloadFileLoaded>(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));
      expect(bloc.state, isA<DownloadFileLoaded>());
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.length, 8);
      expect(loaded.activeCategory, 'all');
    });
  });

  group('DownloadFileFilterCategory', () {
    test('filters files by category', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileFilterCategory('lab'));
      await Future(() {});
      expect(bloc.state, isA<DownloadFileLoaded>());
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.activeCategory, 'lab');
      expect(loaded.files.every((f) => f.category == 'lab'), true);
    });

    test('shows all files when filter is all', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileFilterCategory('imaging'));
      await Future(() {});
      bloc.add(const DownloadFileFilterCategory('all'));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.length, 8);
    });
  });

  group('DownloadFileSearch', () {
    test('filters files by search query', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileSearch('تحليل'));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.length, 3);
    });

    test('shows all files when query is empty', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileSearch(''));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.length, 8);
    });
  });

  group('DownloadFileStart and DownloadFileComplete', () {
    test('starts download and updates status', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileStart('1'));
      await Future(() {});
      final afterStart = bloc.state as DownloadFileLoaded;
      final file1 = afterStart.files.firstWhere((f) => f.id == '1');
      expect(file1.status, DownloadStatus.downloading);
    });

    test('completes download and updates status', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileStart('1'));
      await Future(() {});
      bloc.add(const DownloadFileComplete('1'));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      final file1 = loaded.files.firstWhere((f) => f.id == '1');
      expect(file1.status, DownloadStatus.completed);
      expect(file1.progress, 1.0);
    });
  });

  group('DownloadFileUpdateProgress', () {
    test('updates progress of a downloading file', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileStart('1'));
      await Future(() {});
      bloc.add(const DownloadFileUpdateProgress('1', 0.3));
      await Future(() {});
      bloc.add(const DownloadFileUpdateProgress('1', 0.7));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      final file1 = loaded.files.firstWhere((f) => f.id == '1');
      expect(file1.progress, 0.7);
    });
  });

  group('DownloadFileDelete', () {
    test('removes file from list', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 700));

      bloc.add(const DownloadFileDelete('1'));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.any((f) => f.id == '1'), false);
      expect(loaded.files.length, 7);
    });
  });
}
