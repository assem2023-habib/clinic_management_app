import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/specialization_model.dart';
import 'package:clinic_management_app/data/repositories/doctor_repository_impl.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/screens/search_doctors/search_doctors_screen.dart';

Widget buildTestWidget() {
  final mockDataSource = MockDataSource();
  mockDataSource.addDoctor(DoctorModel(
    id: '1',
    firstName: 'أحمد',
    lastName: 'الرشيد',
    username: 'ahmad.rasheed',
    email: 'ahmad@test.com',
    gender: 'male',
    specialization: const SpecializationModel(
      id: '1', slug: 'cardiology',
      name: {'en': 'Cardiology', 'ar': 'القلب'},
    ),
    rating: 4.9,
  ));
  mockDataSource.addDoctor(DoctorModel(
    id: '2',
    firstName: 'سارة',
    lastName: 'المنصور',
    username: 'sara.almansour',
    email: 'sara@test.com',
    gender: 'female',
    specialization: const SpecializationModel(
      id: '2', slug: 'neurology',
      name: {'en': 'Neurology', 'ar': 'الأعصاب'},
    ),
    rating: 4.8,
  ));
  final repository = DoctorRepositoryImpl(mockDataSource, mockDataSource);
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<DoctorRepository>.value(value: repository),
    ],
    child: BlocProvider(
      create: (_) => DoctorBloc(repository)..add(DoctorLoadAll()),
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        routes: {
          AppRoutes.dashboard: (_) => const Scaffold(body: Text('Dashboard Screen')),
          AppRoutes.appointments: (_) => const Scaffold(body: Text('Appointments Screen')),
          AppRoutes.profile: (_) => const Scaffold(body: Text('Profile Screen')),
          AppRoutes.userBooking: (_) => const Scaffold(body: Text('User Booking Screen')),
        },
        home: const SearchDoctorsScreen(),
      ),
    ),
  );
}

void main() {
  group('SearchDoctorsScreen', () {
    testWidgets('renders title and search hint', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.sdTitle), findsOneWidget);
      expect(find.text(AppStrings.sdSearchHint), findsOneWidget);
    });

    testWidgets('renders filter chips', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.sdFilterAll), findsOneWidget);
      expect(find.text(AppStrings.sdFilterCardiology), findsWidgets);
      expect(find.text(AppStrings.sdFilterNeurology), findsWidgets);
      expect(find.text(AppStrings.sdFilterDental), findsOneWidget);
    });

    testWidgets('renders doctor cards after loading', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('أحمد الرشيد'), findsOneWidget);
      expect(find.text('سارة المنصور'), findsOneWidget);
    });

    testWidgets('filters doctors by search query', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'سارة');
      await tester.pumpAndSettle();

      expect(find.text('سارة المنصور'), findsOneWidget);
      expect(find.text('أحمد الرشيد'), findsNothing);
    });

    testWidgets('shows results count', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining(AppStrings.sdResultsCount), findsOneWidget);
    });

    testWidgets('filters by specialty chip', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.sdFilterCardiology).first);
      await tester.pumpAndSettle();

      expect(find.text('أحمد الرشيد'), findsOneWidget);
      expect(find.text('سارة المنصور'), findsNothing);
    });

    testWidgets('shows empty state when no results', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzznotfound');
      await tester.pumpAndSettle();

      expect(find.text('لم يتم العثور على أطباء'), findsOneWidget);
    });

    testWidgets('book appointment navigates', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final bookButton = find.widgetWithText(ElevatedButton, AppStrings.sdBookAppointment).first;
      await tester.ensureVisible(bookButton);
      await tester.pumpAndSettle();
      await tester.tap(bookButton);
      await tester.pumpAndSettle();

      expect(find.text('User Booking Screen'), findsOneWidget);
    });

    testWidgets('renders back button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('renders doctor ratings', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('4.9'), findsWidgets);
      expect(find.byIcon(Icons.star_rounded), findsWidgets);
    });
  });
}
