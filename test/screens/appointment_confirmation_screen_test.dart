import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/appointment_confirmation_screen.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';

Widget buildTestWidget(AuthCubit cubit, ConfirmationData data) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    routes: {
      AppRoutes.appointments: (_) => const Scaffold(body: Text('Appointments Screen')),
    },
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: cubit,
        child: AppointmentConfirmationScreen(data: data),
      ),
    ),
  );
}

void main() {
  group('AppointmentConfirmationScreen', () {
    setUpAll(() async {
      setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    const specialization = SpecializationEntity(
      id: 'spec1',
      slug: 'cardiology',
      name: {'ar': 'أمراض القلب', 'en': 'Cardiology'},
    );

    const doctor = DoctorEntity(
      id: 'doc1',
      firstName: 'أحمد',
      lastName: 'علي',
      username: 'ahmed_ali',
      email: 'ahmed@test.com',
      gender: 'male',
      specialization: specialization,
      clinicName: 'العيادة المركزية',
      clinicAddress: 'شارع الجمهورية',
    );

    final confirmationData = ConfirmationData(
      appointmentId: 'apt1',
      doctor: doctor,
      date: DateTime(2026, 6, 22),
      timeSlot: '10:30',
      patientName: 'محمد',
    );

    testWidgets('renders patient confirmation UI when role is patient', (tester) async {
      final cubit = AuthCubit();
      addTearDown(cubit.close);
      await cubit.login('test', 'test', role: UserRole.patient);
      await tester.pumpWidget(buildTestWidget(cubit, confirmationData));
      await tester.pump();
      expect(find.text(AppStrings.confirmationPatientTitle), findsOneWidget);
      expect(find.text(AppStrings.confirmationPatientSubtitle), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_top_rounded), findsOneWidget);
    });

    testWidgets('renders doctor confirmation UI when role is doctor', (tester) async {
      final cubit = AuthCubit();
      addTearDown(cubit.close);
      await cubit.login('test', 'test', role: UserRole.doctor);
      await tester.pumpWidget(buildTestWidget(cubit, confirmationData));
      await tester.pump();
      expect(find.text(AppStrings.confirmationDoctorTitle), findsOneWidget);
      expect(find.text(AppStrings.confirmationDoctorSubtitle), findsOneWidget);
    });

    testWidgets('renders details card with doctor info', (tester) async {
      final cubit = AuthCubit();
      addTearDown(cubit.close);
      await cubit.login('test', 'test', role: UserRole.patient);
      await tester.pumpWidget(buildTestWidget(cubit, confirmationData));
      await tester.pump();
      expect(find.text('أحمد علي'), findsOneWidget);
      expect(find.text('أمراض القلب'), findsOneWidget);
      expect(find.text(AppStrings.historyLabel), findsOneWidget);
      expect(find.text(AppStrings.timeLabel), findsOneWidget);
      expect(find.text(AppStrings.location), findsOneWidget);
    });

    testWidgets('renders instructions section', (tester) async {
      final cubit = AuthCubit();
      addTearDown(cubit.close);
      await cubit.login('test', 'test', role: UserRole.patient);
      await tester.pumpWidget(buildTestWidget(cubit, confirmationData));
      await tester.pump();
      expect(find.text(AppStrings.importantInstructions), findsOneWidget);
      expect(find.text(AppStrings.instructionArriveEarly), findsOneWidget);
      expect(find.text(AppStrings.instructionBringId), findsOneWidget);
    });

    testWidgets('shows snackbar when add to calendar is tapped', (tester) async {
      final cubit = AuthCubit();
      addTearDown(cubit.close);
      await cubit.login('test', 'test', role: UserRole.patient);
      await tester.pumpWidget(buildTestWidget(cubit, confirmationData));
      await tester.pump();
      await tester.tap(find.text(AppStrings.addToCalendar));
      await tester.pump();
      expect(find.text(AppStrings.addedToCalendar), findsOneWidget);
    });

    testWidgets('navigates to appointments on primary button tap', (tester) async {
      final cubit = AuthCubit();
      addTearDown(cubit.close);
      await cubit.login('test', 'test', role: UserRole.patient);
      await tester.pumpWidget(buildTestWidget(cubit, confirmationData));
      await tester.pump();
      await tester.tap(find.text(AppStrings.goToMyAppointments));
      await tester.pumpAndSettle();
      expect(find.text('Appointments Screen'), findsOneWidget);
    });
  });
}
