import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';

class MockDoctorRepository extends Mock implements DoctorRepository {}

void main() {
  late DoctorBloc bloc;
  late MockDoctorRepository mockRepo;

  setUp(() {
    mockRepo = MockDoctorRepository();
    bloc = DoctorBloc(mockRepo);
  });

  tearDown(() {
    bloc.close();
  });

  group('initial state', () {
    test('starts with DoctorInitial', () {
      expect(bloc.state, isA<DoctorInitial>());
    });
  });

  group('DoctorLoadAll', () {
    test('emits Loading then Loaded with doctors', () async {
      final doctors = [
        DoctorEntity(id: '1', firstName: 'John', lastName: 'Doe', username: 'jd', email: 'j@t.com', gender: 'male'),
      ];
      when(() => mockRepo.getAllDoctors(specializationId: any(named: 'specializationId'), page: any(named: 'page'))).thenAnswer((_) async => doctors);

      final expected = [isA<DoctorLoading>(), isA<DoctorLoaded>()];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const DoctorLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as DoctorLoaded;
      expect(state.doctors.length, 1);
      expect(state.hasMore, false);
    });

    test('emits DoctorError on failure', () async {
      when(() => mockRepo.getAllDoctors(specializationId: any(named: 'specializationId'), page: any(named: 'page'))).thenThrow(Exception('fail'));
      bloc.add(const DoctorLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state, isA<DoctorError>());
    });
  });

  group('DoctorLoadMore', () {
    test('appends more doctors and sets hasMore when >= 20', () async {
      final page1 = List.generate(20, (i) => DoctorEntity(
        id: 'p$i', firstName: 'A', lastName: 'B', username: 'u$i', email: '$i@t.com', gender: 'male',
      ));
      final page2 = List.generate(5, (i) => DoctorEntity(
        id: 'p${i + 20}', firstName: 'C', lastName: 'D', username: 'u${i + 20}', email: '${i + 20}@t.com', gender: 'male',
      ));

      when(() => mockRepo.getAllDoctors(specializationId: any(named: 'specializationId'), page: any(named: 'page'))).thenAnswer((invocation) async {
        final page = invocation.namedArguments[#page] as int;
        return page == 1 ? page1 : page2;
      });

      bloc.add(const DoctorLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as DoctorLoaded).doctors.length, 20);
      expect((bloc.state as DoctorLoaded).hasMore, true);

      bloc.add(const DoctorLoadMore());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as DoctorLoaded;
      expect(state.doctors.length, 25);
      expect(state.hasMore, false);
    });

    test('does nothing when state is not DoctorLoaded', () {
      bloc.add(const DoctorLoadMore());
      expect(bloc.state, isA<DoctorInitial>());
    });

    test('sets isLoadingMore immediately after LoadMore event', () async {
      final many = List.generate(20, (i) => DoctorEntity(
        id: 'p$i', firstName: 'A', lastName: 'B', username: 'u$i', email: '$i@t.com', gender: 'male',
      ));
      when(() => mockRepo.getAllDoctors(specializationId: any(named: 'specializationId'), page: any(named: 'page'))).thenAnswer((_) async => many);
      bloc.add(const DoctorLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      when(() => mockRepo.getAllDoctors(page: any(named: 'page'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });
      bloc.add(const DoctorLoadMore());
      await Future.delayed(const Duration(milliseconds: 10));
      expect((bloc.state as DoctorLoaded).isLoadingMore, true);
    });

    test('does nothing when hasMore is false', () async {
      final doctors = [DoctorEntity(id: '1', firstName: 'A', lastName: 'B', username: 'u', email: 'e@t.com', gender: 'male')];
      when(() => mockRepo.getAllDoctors(specializationId: any(named: 'specializationId'), page: any(named: 'page'))).thenAnswer((_) async => doctors);
      bloc.add(const DoctorLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const DoctorLoadMore());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as DoctorLoaded).doctors.length, 1);
    });

    test('maintains existing doctors on error', () async {
      when(() => mockRepo.getAllDoctors(specializationId: any(named: 'specializationId'), page: any(named: 'page'))).thenAnswer((_) async => List.generate(20, (i) => DoctorEntity(
        id: 'p$i', firstName: 'A', lastName: 'B', username: 'u$i', email: '$i@t.com', gender: 'male',
      )));
      bloc.add(const DoctorLoadAll());
      await Future.delayed(const Duration(milliseconds: 50));
      expect((bloc.state as DoctorLoaded).doctors.length, 20);

      when(() => mockRepo.getAllDoctors(page: any(named: 'page'))).thenThrow(Exception('fail'));
      bloc.add(const DoctorLoadMore());
      await Future.delayed(const Duration(milliseconds: 50));
      final state = bloc.state as DoctorLoaded;
      expect(state.doctors.length, 20);
      expect(state.isLoadingMore, false);
      expect(state.hasMore, true);
    });
  });
}
