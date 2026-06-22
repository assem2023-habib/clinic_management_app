import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/data/datasources/remote/file_remote_datasource.dart';
import 'package:clinic_management_app/data/repositories/file_repository_impl.dart';
import 'package:clinic_management_app/data/models/file_model.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_state.dart';

class MockFileDataSource extends Mock implements FileRemoteDataSource {}

FileRepository _createRepo(FileRemoteDataSource ds) => FileRepositoryImpl(remoteDataSource: ds);

final _mockFiles = [
  FileModel(id: '1', originalName: 'lab_result.pdf', mimeType: 'application/pdf', size: 204800, fileCategory: FileCategory.labResult, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1', createdAt: DateTime(2025, 11, 15)),
  FileModel(id: '2', originalName: 'blood_test.pdf', mimeType: 'application/pdf', size: 1126400, fileCategory: FileCategory.labResult, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1', createdAt: DateTime(2025, 11, 10)),
  FileModel(id: '3', originalName: 'chest_xray.jpg', mimeType: 'image/jpeg', size: 6081740, fileCategory: FileCategory.xray, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr2', userId: 'u1', createdAt: DateTime(2025, 10, 28)),
  FileModel(id: '4', originalName: 'prescription_nov.pdf', mimeType: 'application/pdf', size: 614400, fileCategory: FileCategory.prescription, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1', createdAt: DateTime(2025, 11, 20)),
  FileModel(id: '5', originalName: 'liver_function.pdf', mimeType: 'application/pdf', size: 1887436, fileCategory: FileCategory.labResult, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr3', userId: 'u1', createdAt: DateTime(2025, 9, 5)),
  FileModel(id: '6', originalName: 'mri_knee.dcm', mimeType: 'application/dicom', size: 12897484, fileCategory: FileCategory.xray, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr3', userId: 'u1', createdAt: DateTime(2025, 8, 12)),
  FileModel(id: '7', originalName: 'invoice_nov.pdf', mimeType: 'application/pdf', size: 307200, fileCategory: FileCategory.document, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1', createdAt: DateTime(2025, 11, 15)),
  FileModel(id: '8', originalName: 'urinalysis.pdf', mimeType: 'application/pdf', size: 921600, fileCategory: FileCategory.labResult, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr2', userId: 'u1', createdAt: DateTime(2025, 11, 22)),
];

void main() {
  late DownloadFileBloc bloc;
  late MockFileDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockFileDataSource();
    when(() => mockDataSource.getFiles(mine: any(named: 'mine'), page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => _mockFiles);
    bloc = DownloadFileBloc(_createRepo(mockDataSource));
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
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.state, isA<DownloadFileLoaded>());
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.length, 8);
      expect(loaded.activeCategory, 'all');
      expect(loaded.hasMore, false);
    });
  });

  group('DownloadFileLoadMore', () {
    test('appends more files', () async {
      final page2 = [
        FileModel(id: '9', originalName: 'extra.pdf', mimeType: 'application/pdf', size: 100, fileCategory: FileCategory.document, uploadStatus: FileUploadStatus.completed, medicalRecordId: 'mr1', userId: 'u1', createdAt: DateTime(2026, 1, 1)),
      ];
      when(() => mockDataSource.getFiles(mine: any(named: 'mine'), page: 2, limit: any(named: 'limit'))).thenAnswer((_) async => page2);

      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const DownloadFileLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 100));
      final state = bloc.state as DownloadFileLoaded;
      expect(state.files.length, 9);
    });

    test('does nothing when state is not DownloadFileLoaded', () {
      bloc.add(const DownloadFileLoadMore());
      expect(bloc.state, isA<DownloadFileInitial>());
    });

    test('sets isLoadingMore immediately after LoadMore event', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.state, isA<DownloadFileLoaded>());

      when(() => mockDataSource.getFiles(mine: any(named: 'mine'), page: 2, limit: any(named: 'limit'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });
      bloc.add(const DownloadFileLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 10));
      expect((bloc.state as DownloadFileLoaded).isLoadingMore, true);
    });

    test('maintains existing files on error', () async {
      when(() => mockDataSource.getFiles(mine: any(named: 'mine'), page: 2, limit: any(named: 'limit'))).thenThrow(Exception('fail'));

      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const DownloadFileLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 100));
      final state = bloc.state as DownloadFileLoaded;
      expect(state.files.length, 8);
      expect(state.isLoadingMore, false);
    });
  });

  group('DownloadFileFilterCategory', () {
    test('filters files by category', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const DownloadFileFilterCategory('lab_result'));
      await Future(() {});
      expect(bloc.state, isA<DownloadFileLoaded>());
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.activeCategory, 'lab_result');
      expect(loaded.files.every((f) => f.category == 'lab_result'), true);
    });
  });

  group('DownloadFileSearch', () {
    test('filters files by search query', () async {
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const DownloadFileSearch('lab'));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.length, 4);
    });
  });

  group('DownloadFileDelete', () {
    test('removes file from list', () async {
      when(() => mockDataSource.deleteFile('1')).thenAnswer((_) async {});
      bloc.add(const DownloadFileLoadAll());
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const DownloadFileDelete('1'));
      await Future(() {});
      final loaded = bloc.state as DownloadFileLoaded;
      expect(loaded.files.any((f) => f.id == '1'), false);
      expect(loaded.files.length, 7);
    });
  });
}
