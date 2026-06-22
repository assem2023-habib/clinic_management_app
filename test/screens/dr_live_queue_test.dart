import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/screens/doctor_appointments/widgets/dr_live_queue.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

class MockDoctorRepository extends Mock implements DoctorRepository {}

class StubAuthCubit extends Cubit<AuthState> implements AuthCubit {
  StubAuthCubit() : super(const AuthState());

  @override
  Future<void> checkAuthStatus() async {}

  @override
  Future<void> login(String email, String password, {UserRole? role}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> registerPatient({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? phone,
    String? address,
    required String gender,
    String? birthdayDate,
    String? cityId,
  }) async {}

  @override
  Future<void> registerDoctor({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? phone,
    String? address,
    required String gender,
    String? birthdayDate,
    String? cityId,
    required String specializationId,
    required int experienceMonths,
  }) async {}

  @override
  Future<void> registerReceptionist({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? phone,
    String? address,
    required String gender,
    String? birthdayDate,
    String? cityId,
    String? shiftStart,
    String? shiftEnd,
  }) async {}

  @override
  Future<void> getFirebaseToken() async {}
}

AppointmentEntity _createAppointment({
  String id = 'apt-1',
  AppointmentStatus status = AppointmentStatus.scheduled,
  String patientName = 'مريض 1',
  String timeSlot = '10:00',
  String? date,
}) {
  return AppointmentEntity(
    id: id,
    status: status,
    patientName: patientName,
    timeSlot: timeSlot,
    date: date ?? DateTime.now().toIso8601String().substring(0, 10),
  );
}

Widget createTestWidget({
  required AuthCubit authCubit,
  required AppointmentBloc appointmentBloc,
  required DoctorBloc doctorBloc,
}) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<AppointmentBloc>.value(value: appointmentBloc),
        BlocProvider<DoctorBloc>.value(value: doctorBloc),
      ],
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: DrLiveQueue(),
      ),
    ),
  );
}

void main() {
  late MockAppointmentRepository mockAppointmentRepo;
  late MockDoctorRepository mockDoctorRepo;

  setUp(() {
    mockAppointmentRepo = MockAppointmentRepository();
    mockDoctorRepo = MockDoctorRepository();
  });

  group('DrLiveQueue', () {
    testWidgets('dispatches WatchRtdb on init', (tester) async {
      final authCubit = StubAuthCubit();
      authCubit.emit(
        const AuthState(userId: 'doc-1', userName: 'د. أحمد', role: UserRole.doctor),
      );

      when(() => mockAppointmentRepo.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      final appointmentBloc = AppointmentBloc(mockAppointmentRepo);
      final doctorBloc = DoctorBloc(mockDoctorRepo);

      await tester.pumpWidget(createTestWidget(
        authCubit: authCubit,
        appointmentBloc: appointmentBloc,
        doctorBloc: doctorBloc,
      ));
      await tester.pump();

      verify(() => mockAppointmentRepo.watchRtdbAppointments('doc-1')).called(1);

      addTearDown(() {
        appointmentBloc.close();
        doctorBloc.close();
      });
    });

    testWidgets('renders greeting card with doctor name from AuthCubit', (tester) async {
      final authCubit = StubAuthCubit();
      authCubit.emit(
        const AuthState(userId: 'doc-1', userName: 'د. أحمد', role: UserRole.doctor),
      );

      when(() => mockAppointmentRepo.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      final appointmentBloc = AppointmentBloc(mockAppointmentRepo);
      final doctorBloc = DoctorBloc(mockDoctorRepo);

      await tester.pumpWidget(createTestWidget(
        authCubit: authCubit,
        appointmentBloc: appointmentBloc,
        doctorBloc: doctorBloc,
      ));
      await tester.pump();

      expect(find.textContaining('د. أحمد'), findsOneWidget);

      addTearDown(() {
        appointmentBloc.close();
        doctorBloc.close();
      });
    });

    testWidgets('renders stats cards', (tester) async {
      final authCubit = StubAuthCubit();
      authCubit.emit(
        const AuthState(userId: 'doc-1', userName: 'د. أحمد', role: UserRole.doctor),
      );

      when(() => mockAppointmentRepo.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      final appointmentBloc = AppointmentBloc(mockAppointmentRepo);
      final doctorBloc = DoctorBloc(mockDoctorRepo);

      appointmentBloc.emit(AppointmentLoaded([
        _createAppointment(status: AppointmentStatus.scheduled),
        _createAppointment(
          id: 'apt-2',
          status: AppointmentStatus.scheduled,
          patientName: 'مريض 2',
          timeSlot: '11:00',
        ),
      ]));

      await tester.pumpWidget(createTestWidget(
        authCubit: authCubit,
        appointmentBloc: appointmentBloc,
        doctorBloc: doctorBloc,
      ));
      await tester.pump();

      expect(find.text(AppStrings.daTotalApptsToday), findsOneWidget);
      expect(find.text(AppStrings.daPatientsWaiting), findsOneWidget);
      expect(find.text(AppStrings.daAvailableDoctors), findsOneWidget);

      addTearDown(() {
        appointmentBloc.close();
        doctorBloc.close();
      });
    });

    testWidgets('renders queue list with appointments', (tester) async {
      final authCubit = StubAuthCubit();
      authCubit.emit(
        const AuthState(userId: 'doc-1', userName: 'د. أحمد', role: UserRole.doctor),
      );

      when(() => mockAppointmentRepo.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      final today = DateTime.now().toIso8601String().substring(0, 10);
      final appointmentBloc = AppointmentBloc(mockAppointmentRepo);
      final doctorBloc = DoctorBloc(mockDoctorRepo);

      appointmentBloc.emit(AppointmentLoaded([
        _createAppointment(
          id: 'apt-1',
          status: AppointmentStatus.scheduled,
          patientName: 'مريض 1',
          timeSlot: '10:00',
          date: today,
        ),
        _createAppointment(
          id: 'apt-2',
          status: AppointmentStatus.inProgress,
          patientName: 'مريض 2',
          timeSlot: '09:00',
          date: today,
        ),
        _createAppointment(
          id: 'apt-3',
          status: AppointmentStatus.cancelled,
          patientName: 'مريض 3',
          timeSlot: '11:00',
          date: today,
        ),
      ]));

      await tester.pumpWidget(createTestWidget(
        authCubit: authCubit,
        appointmentBloc: appointmentBloc,
        doctorBloc: doctorBloc,
      ));
      await tester.pump();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pump();

      expect(find.text(AppStrings.daLiveQueue), findsOneWidget);
      expect(find.text('مريض 1'), findsOneWidget);
      expect(find.text('مريض 2'), findsOneWidget);
      expect(find.text('مريض 3'), findsOneWidget);

      addTearDown(() {
        appointmentBloc.close();
        doctorBloc.close();
      });
    });

    testWidgets('renders empty state when no appointments', (tester) async {
      final authCubit = StubAuthCubit();
      authCubit.emit(
        const AuthState(userId: 'doc-1', userName: 'د. أحمد', role: UserRole.doctor),
      );

      when(() => mockAppointmentRepo.watchRtdbAppointments('doc-1'))
          .thenAnswer((_) => const Stream.empty());

      final appointmentBloc = AppointmentBloc(mockAppointmentRepo);
      final doctorBloc = DoctorBloc(mockDoctorRepo);

      appointmentBloc.emit(AppointmentLoaded([]));

      await tester.pumpWidget(createTestWidget(
        authCubit: authCubit,
        appointmentBloc: appointmentBloc,
        doctorBloc: doctorBloc,
      ));
      await tester.pump();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -100));
      await tester.pump();

      expect(find.byIcon(Icons.event_busy_rounded), findsOneWidget);
      expect(find.text(AppStrings.daNoApptsToday), findsOneWidget);

      addTearDown(() {
        appointmentBloc.close();
        doctorBloc.close();
      });
    });
  });
}
