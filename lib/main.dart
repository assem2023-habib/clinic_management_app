import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/core/services/fcm_service.dart';
import 'package:clinic_management_app/core/theme/app_theme.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:clinic_management_app/data/repositories/doctor_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/patient_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/appointment_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/medical_record_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/auth_repository_impl.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/screens/appointments/appointments_screen.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:clinic_management_app/presentation/screens/doctors/doctors_screen.dart';
import 'package:clinic_management_app/presentation/screens/login/login_screen.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/medical_records_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/role_selection_screen.dart';
import 'package:clinic_management_app/presentation/screens/patients/patients_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_patient_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_doctor_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_receptionist_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/profile_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/change_password_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/delete_account_screen.dart';
import 'package:clinic_management_app/presentation/screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FcmService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
  }

  @override
  Widget build(BuildContext context) {
    final mockDataSource = MockDataSource();
    final apiService = ApiService();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DoctorRepository>(create: (_) => DoctorRepositoryImpl(mockDataSource)),
        RepositoryProvider<PatientRepository>(create: (_) => PatientRepositoryImpl(mockDataSource)),
        RepositoryProvider<AppointmentRepository>(create: (_) => AppointmentRepositoryImpl(mockDataSource)),
        RepositoryProvider<MedicalRecordRepository>(create: (_) => MedicalRecordRepositoryImpl(mockDataSource)),
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl(AuthRemoteDataSource(apiService), apiService)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => OnboardingCubit()),
          BlocProvider(create: (context) => DoctorBloc(RepositoryProvider.of<DoctorRepository>(context))),
          BlocProvider(create: (context) => PatientBloc(RepositoryProvider.of<PatientRepository>(context))),
          BlocProvider(create: (context) => AppointmentBloc(RepositoryProvider.of<AppointmentRepository>(context))),
          BlocProvider(create: (context) => MedicalRecordBloc(RepositoryProvider.of<MedicalRecordRepository>(context))),
          BlocProvider(create: (context) => ProfileCubit(authRepository: RepositoryProvider.of<AuthRepository>(context))),
        ],
        child: ListenableBuilder(
          listenable: _themeProvider,
          builder: (context, _) => MaterialApp(
            title: 'Clinic Management',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const _SplashScreen(),
            routes: {
              AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
              AppRoutes.onboarding: (_) => const OnboardingScreen(),
              AppRoutes.login: (_) => LoginScreen(),
              AppRoutes.dashboard: (_) => const DashboardScreen(),
              AppRoutes.doctors: (_) => const DoctorsScreen(),
              AppRoutes.patients: (_) => const PatientsScreen(),
              AppRoutes.appointments: (_) => const AppointmentsScreen(),
              AppRoutes.medicalRecords: (_) => const MedicalRecordsScreen(),
              AppRoutes.settings: (_) => SettingsScreen(themeProvider: _themeProvider),
              AppRoutes.registerPatient: (_) => const RegisterPatientScreen(),
              AppRoutes.registerDoctor: (_) => const RegisterDoctorScreen(),
              AppRoutes.registerReceptionist: (_) => const RegisterReceptionistScreen(),
              AppRoutes.profile: (_) => const ProfileScreen(),
              AppRoutes.changePassword: (_) => const ChangePasswordScreen(),
              AppRoutes.deleteAccount: (_) => const DeleteAccountScreen(),
            },
          ),
        ),
      ),
    );
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final cubit = context.read<OnboardingCubit>();
    await cubit.loadOnboardingStatus();
    final state = cubit.state;

    if (!mounted) return;

    if (state.completed) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
