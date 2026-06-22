import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_event.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_state.dart';

class MockFileRepository extends Mock implements FileRepository {}

void main() {
  late FileBloc bloc;
  late MockFileRepository mockRepo;

  setUp(() {
    mockRepo = MockFileRepository();
    bloc = FileBloc(mockRepo);
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with FileInitial', () {
      expect(bloc.state, isA<FileInitial>());
    });
  });

  group('FileLoadAll', () {
    test('emits Loading then Loaded with files', () async {
      final files = [
        const FileEntity(id: '1', originalName: 'test.pdf', mimeType: 'application/pdf', size: 100, fileCategory: FileCategory.document, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1'),
      ];
      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => files);

      final expected = [isA<FileLoading>(), isA<FileLoaded>()];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const FileLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as FileLoaded;
      expect(state.files.length, 1);
      expect(state.hasMore, false);
    });

    test('emits FileError on failure', () async {
      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(Exception('fail'));
      bloc.add(const FileLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state, isA<FileError>());
    });
  });

  group('FileLoadMore', () {
    test('appends more files and sets hasMore when >= limit', () async {
      final page1 = List.generate(20, (i) => const FileEntity(
        id: 'f', originalName: 'a.pdf', mimeType: 'application/pdf', size: 100, fileCategory: FileCategory.document, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1',
      ));
      final page2 = List.generate(5, (i) => const FileEntity(
        id: 'g', originalName: 'b.pdf', mimeType: 'application/pdf', size: 200, fileCategory: FileCategory.labResult, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr2', userId: 'u2',
      ));

      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((invocation) async {
        final page = invocation.namedArguments[#page] as int;
        return page == 1 ? page1 : page2;
      });

      bloc.add(const FileLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as FileLoaded).files.length, 20);
      expect((bloc.state as FileLoaded).hasMore, true);

      bloc.add(const FileLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as FileLoaded;
      expect(state.files.length, 25);
      expect(state.hasMore, false);
    });

    test('does nothing when state is not FileLoaded', () {
      bloc.add(const FileLoadMore());
      expect(bloc.state, isA<FileInitial>());
    });

    test('sets isLoadingMore immediately after LoadMore event', () async {
      final many = List.generate(20, (i) => FileEntity(
        id: 'f$i', originalName: 'a.pdf', mimeType: 'application/pdf', size: 100, fileCategory: FileCategory.document, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1',
      ));
      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => many);
      bloc.add(const FileLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });
      bloc.add(const FileLoadMore());
      await Future.delayed(const Duration(milliseconds: 10));
      expect((bloc.state as FileLoaded).isLoadingMore, true);
    });

    test('maintains existing files on error', () async {
      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => [
        const FileEntity(id: '1', originalName: 'a.pdf', mimeType: 'application/pdf', size: 100, fileCategory: FileCategory.document, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1'),
      ]);
      bloc.add(const FileLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getFiles(mine: any(named: 'mine'), page: 2, limit: 20)).thenThrow(Exception('fail'));
      bloc.add(const FileLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as FileLoaded;
      expect(state.files.length, 1);
      expect(state.isLoadingMore, false);
    });
  });
}
