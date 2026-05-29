import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';

void main() {
  group('DownloadFileEntity', () {
    final entity = DownloadFileEntity(
      id: '1',
      name: 'التقرير الطبي',
      type: 'PDF',
      category: 'report',
      sizeInMb: 2.4,
      date: DateTime(2025, 11, 15),
      status: DownloadStatus.none,
      progress: 0.0,
    );

    test('supports value equality', () {
      final same = DownloadFileEntity(
        id: '1',
        name: 'التقرير الطبي',
        type: 'PDF',
        category: 'report',
        sizeInMb: 2.4,
        date: DateTime(2025, 11, 15),
        status: DownloadStatus.none,
        progress: 0.0,
      );
      expect(entity, equals(same));
    });

    test('not equal when id differs', () {
      final other = DownloadFileEntity(
        id: '2',
        name: 'تحليل الدم',
        type: 'PDF',
        category: 'lab',
        sizeInMb: 1.1,
        date: DateTime(2025, 11, 10),
        status: DownloadStatus.completed,
        progress: 1.0,
      );
      expect(entity, isNot(equals(other)));
    });

    test('props contains all fields', () {
      expect(entity.props, containsAll(['1', 'التقرير الطبي', 'PDF', 'report', 2.4, DownloadStatus.none, 0.0]));
    });

    test('uses default values for status and progress', () {
      final minimal = DownloadFileEntity(
        id: '3',
        name: 'أشعة الصدر',
        type: 'JPG',
        category: 'imaging',
        sizeInMb: 5.8,
        date: DateTime(2025, 10, 28),
      );
      expect(minimal.status, DownloadStatus.none);
      expect(minimal.progress, 0.0);
    });

    group('copyWith', () {
      test('returns same object when no args', () {
        expect(entity.copyWith(), equals(entity));
      });

      test('updates status and progress', () {
        final updated = entity.copyWith(status: DownloadStatus.downloading, progress: 0.5);
        expect(updated.status, DownloadStatus.downloading);
        expect(updated.progress, 0.5);
        expect(updated.id, entity.id);
      });

      test('updates name', () {
        final updated = entity.copyWith(name: 'تقرير جديد');
        expect(updated.name, 'تقرير جديد');
        expect(updated.id, entity.id);
      });
    });
  });

  group('DownloadStatus', () {
    test('has all expected values', () {
      expect(DownloadStatus.values, hasLength(4));
      expect(DownloadStatus.values, containsAll([DownloadStatus.none, DownloadStatus.downloading, DownloadStatus.completed, DownloadStatus.error]));
    });
  });
}
