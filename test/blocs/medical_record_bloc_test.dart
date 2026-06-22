import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';

class MockMedicalRecordRepository extends Mock implements MedicalRecordRepository {}

void main() {
  late MedicalRecordBloc bloc;
  late MockMedicalRecordRepository mockRepo;

  setUp(() {
    mockRepo = MockMedicalRecordRepository();
    bloc = MedicalRecordBloc(mockRepo);
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with MedicalRecordInitial', () {
      expect(bloc.state, isA<MedicalRecordInitial>());
    });
  });

  group('MedicalRecordLoadAll', () {
    test('emits Loading then Loaded with records', () async {
      final records = [
        const MedicalRecordEntity(id: '1', patientId: 'p1', diagnosis: 'Cold'),
      ];
      when(() => mockRepo.getAllRecords(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => records);

      final expected = [isA<MedicalRecordLoading>(), isA<MedicalRecordLoaded>()];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const MedicalRecordLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as MedicalRecordLoaded;
      expect(state.records.length, 1);
      expect(state.hasMore, false);
    });

    test('emits MedicalRecordError on failure', () async {
      when(() => mockRepo.getAllRecords(page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(Exception('fail'));
      bloc.add(const MedicalRecordLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state, isA<MedicalRecordError>());
    });
  });

  group('MedicalRecordLoadMore', () {
    test('appends more records and sets hasMore when >= limit', () async {
      final page1 = List.generate(20, (i) => MedicalRecordEntity(
        id: 'r$i', patientId: 'p1', diagnosis: 'D${i % 3}',
      ));
      final page2 = List.generate(5, (i) => MedicalRecordEntity(
        id: 'r${i + 20}', patientId: 'p2', diagnosis: 'E',
      ));

      when(() => mockRepo.getAllRecords(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((invocation) async {
        final page = invocation.namedArguments[#page] as int;
        return page == 1 ? page1 : page2;
      });

      bloc.add(const MedicalRecordLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as MedicalRecordLoaded).records.length, 20);
      expect((bloc.state as MedicalRecordLoaded).hasMore, true);

      bloc.add(const MedicalRecordLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as MedicalRecordLoaded;
      expect(state.records.length, 25);
      expect(state.hasMore, false);
    });

    test('does nothing when state is not MedicalRecordLoaded', () {
      bloc.add(const MedicalRecordLoadMore());
      expect(bloc.state, isA<MedicalRecordInitial>());
    });

    test('sets isLoadingMore immediately after LoadMore event', () async {
      when(() => mockRepo.getAllRecords(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => [
        const MedicalRecordEntity(id: '1', patientId: 'p1', diagnosis: 'A'),
      ]);
      bloc.add(const MedicalRecordLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllRecords(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });
      bloc.add(const MedicalRecordLoadMore());
      await Future.delayed(const Duration(milliseconds: 10));
      expect((bloc.state as MedicalRecordLoaded).isLoadingMore, true);
    });

    test('maintains existing records on error', () async {
      when(() => mockRepo.getAllRecords(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => [
        const MedicalRecordEntity(id: '1', patientId: 'p1', diagnosis: 'A'),
      ]);
      bloc.add(const MedicalRecordLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllRecords(page: 2, limit: 20)).thenThrow(Exception('fail'));
      bloc.add(const MedicalRecordLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as MedicalRecordLoaded;
      expect(state.records.length, 1);
      expect(state.isLoadingMore, false);
    });
  });
}
