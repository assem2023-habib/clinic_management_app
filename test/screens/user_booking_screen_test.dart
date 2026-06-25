import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_bloc.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/user_booking_screen.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'package:firebase_core_platform_interface/test.dart';

class MockDoctorRepository extends Mock implements DoctorRepository {}

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

DoctorEntity _createDoctor({String id = 'doc-1'}) {
  return DoctorEntity(
    id: id,
    firstName: 'خالد',
    lastName: 'سليمان',
    username: 'drkhaled',
    email: 'khaled@test.com',
    gender: 'male',
  );
}

Widget buildTestWidget({
  required AuthCubit authCubit,
  required DoctorRepository doctorRepository,
  required AppointmentRepository appointmentRepository,
}) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    routes: {
      AppRoutes.appointmentConfirmation: (_) => const Scaffold(
        body: Center(child: Text('Confirmation Screen')),
      ),
    },
    home: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DoctorRepository>.value(value: doctorRepository),
        RepositoryProvider<AppointmentRepository>.value(value: appointmentRepository),
      ],
      child: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const UserBookingScreen(doctorId: 'doc-1'),
      ),
    ),
  );
}

UserBookingBloc _getBloc(WidgetTester tester) {
  return BlocProvider.of<UserBookingBloc>(
    tester.element(find.byType(Scaffold)),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  group('UserBookingScreen', () {
    testWidgets('renders loading skeleton initially', (tester) async {
      final authCubit = AuthCubit();
      authCubit.emit(const AuthAuthenticated(
        userId: 'p1', userName: 'Test', role: UserRole.patient,
      ));
      final doctorRepo = MockDoctorRepository();
      final appointmentRepo = MockAppointmentRepository();
      when(() => doctorRepo.getDoctorById(any())).thenAnswer((_) async => _createDoctor());
      when(() => appointmentRepo.watchRtdbAppointments(any()))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestWidget(
        authCubit: authCubit,
        doctorRepository: doctorRepo,
        appointmentRepository: appointmentRepo,
      ));

      expect(find.byType(SkeletonList), findsOneWidget);

      _getBloc(tester).close();
      authCubit.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders patient-only lock screen for non-patient role', (tester) async {
      final authCubit = AuthCubit();
      authCubit.emit(const AuthAuthenticated(
        userId: 'd1', userName: 'Doctor', role: UserRole.doctor,
      ));
      final doctorRepo = MockDoctorRepository();
      final appointmentRepo = MockAppointmentRepository();
      when(() => doctorRepo.getDoctorById(any())).thenAnswer((_) async => _createDoctor());
      when(() => appointmentRepo.watchRtdbAppointments(any()))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestWidget(
        authCubit: authCubit,
        doctorRepository: doctorRepo,
        appointmentRepository: appointmentRepo,
      ));
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
      expect(find.text(AppStrings.bookingPatientOnly), findsOneWidget);

      _getBloc(tester).close();
      authCubit.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders full booking UI for patient role when loaded', (tester) async {
      final authCubit = AuthCubit();
      authCubit.emit(const AuthAuthenticated(
        userId: 'p1', userName: 'Test', role: UserRole.patient,
      ));
      final doctorRepo = MockDoctorRepository();
      final appointmentRepo = MockAppointmentRepository();
      when(() => doctorRepo.getDoctorById(any())).thenAnswer((_) async => _createDoctor());
      when(() => appointmentRepo.watchRtdbAppointments(any()))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestWidget(
        authCubit: authCubit,
        doctorRepository: doctorRepo,
        appointmentRepository: appointmentRepo,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text(AppStrings.bookingTitle), findsOneWidget);
      expect(find.textContaining('خالد سليمان'), findsOneWidget);
      expect(find.text(AppStrings.bookingConfirm), findsOneWidget);

      _getBloc(tester).close();
      authCubit.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('shows error snackbar on error state', (tester) async {
      final authCubit = AuthCubit();
      authCubit.emit(const AuthAuthenticated(
        userId: 'p1', userName: 'Test', role: UserRole.patient,
      ));
      final doctorRepo = MockDoctorRepository();
      final appointmentRepo = MockAppointmentRepository();
      when(() => doctorRepo.getDoctorById(any())).thenAnswer((_) async => null);
      when(() => appointmentRepo.watchRtdbAppointments(any()))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestWidget(
        authCubit: authCubit,
        doctorRepository: doctorRepo,
        appointmentRepository: appointmentRepo,
      ));
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);

      _getBloc(tester).close();
      authCubit.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('navigates to confirmation on confirmed state', (tester) async {
      final authCubit = AuthCubit();
      authCubit.emit(const AuthAuthenticated(
        userId: 'p1', userName: 'Test', role: UserRole.patient,
      ));
      final doctorRepo = MockDoctorRepository();
      final appointmentRepo = MockAppointmentRepository();
      when(() => doctorRepo.getDoctorById(any())).thenAnswer((_) async => _createDoctor());
      when(() => appointmentRepo.watchRtdbAppointments(any()))
          .thenAnswer((_) => const Stream.empty());
      when(() => appointmentRepo.requestAppointment(
        any(),
        preferredDate: any(named: 'preferredDate'),
        reason: any(named: 'reason'),
      )).thenAnswer((_) async => const AppointmentEntity(
        id: 'new-apt',
        status: AppointmentStatus.requested,
      ));

      await tester.pumpWidget(buildTestWidget(
        authCubit: authCubit,
        doctorRepository: doctorRepo,
        appointmentRepository: appointmentRepo,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('08:00 - 08:30').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final bloc = _getBloc(tester);

      await tester.tap(find.text(AppStrings.bookingConfirm));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Confirmation Screen'), findsOneWidget);

      bloc.close();
      authCubit.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
