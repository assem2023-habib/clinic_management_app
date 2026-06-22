import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

void main() {
  late PatientBloc bloc;
  late MockPatientRepository mockRepo;

  setUp(() {
    mockRepo = MockPatientRepository();
    bloc = PatientBloc(mockRepo);
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with PatientInitial', () {
      expect(bloc.state, isA<PatientInitial>());
    });
  });

  group('PatientLoadAll', () {
    test('emits Loading then Loaded with patients', () async {
      final patients = [
        PatientEntity(id: '1', firstName: 'A', lastName: 'B', username: 'u', email: 'e@t.com', gender: 'male'),
      ];
      when(() => mockRepo.getAllPatients(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => patients);

      final expected = [isA<PatientLoading>(), isA<PatientLoaded>()];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const PatientLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as PatientLoaded;
      expect(state.patients.length, 1);
      expect(state.hasMore, false);
    });

    test('emits PatientError on failure', () async {
      when(() => mockRepo.getAllPatients(page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(Exception('fail'));
      bloc.add(const PatientLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state, isA<PatientError>());
    });
  });

  group('PatientLoadMore', () {
    test('appends more patients and sets hasMore when >= limit', () async {
      final page1 = List.generate(20, (i) => PatientEntity(
        id: 'p$i', firstName: 'A', lastName: 'B', username: 'u$i', email: '$i@t.com', gender: 'male',
      ));
      final page2 = List.generate(5, (i) => PatientEntity(
        id: 'p${i + 20}', firstName: 'C', lastName: 'D', username: 'u${i + 20}', email: '${i + 20}@t.com', gender: 'male',
      ));

      when(() => mockRepo.getAllPatients(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((invocation) async {
        final page = invocation.namedArguments[#page] as int;
        return page == 1 ? page1 : page2;
      });

      bloc.add(const PatientLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as PatientLoaded).patients.length, 20);
      expect((bloc.state as PatientLoaded).hasMore, true);

      bloc.add(const PatientLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as PatientLoaded;
      expect(state.patients.length, 25);
      expect(state.hasMore, false);
    });

    test('does nothing when state is not PatientLoaded', () {
      bloc.add(PatientLoadMore());
      expect(bloc.state, isA<PatientInitial>());
    });

    test('sets isLoadingMore immediately after LoadMore event', () async {
      final many = List.generate(20, (i) => PatientEntity(
        id: 'p$i', firstName: 'A', lastName: 'B', username: 'u$i', email: '$i@t.com', gender: 'male',
      ));
      when(() => mockRepo.getAllPatients(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => many);
      bloc.add(const PatientLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllPatients(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });
      bloc.add(PatientLoadMore());
      await Future.delayed(const Duration(milliseconds: 10));
      expect((bloc.state as PatientLoaded).isLoadingMore, true);
    });

    test('maintains existing patients on error', () async {
      final patients = [PatientEntity(id: '1', firstName: 'A', lastName: 'B', username: 'u', email: 'e@t.com', gender: 'male')];
      when(() => mockRepo.getAllPatients(page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer((_) async => patients);
      bloc.add(const PatientLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllPatients(page: 2, limit: 20)).thenThrow(Exception('fail'));

      bloc.add(const PatientLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const PatientLoadMore(page: 2));
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as PatientLoaded;
      expect(state.patients.length, 1);
      expect(state.isLoadingMore, false);
    });
  });
}
