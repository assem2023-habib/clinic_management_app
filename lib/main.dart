import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clinic_management_app/core/di/injection_container.dart';
import 'package:clinic_management_app/core/services/fcm_service.dart';
import 'package:clinic_management_app/core/theme/app_theme.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/data/repositories/appointment_repository.dart';
import 'package:clinic_management_app/data/repositories/doctor_repository.dart';
import 'package:clinic_management_app/data/repositories/patient_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/screens/appointments/appointments_screen.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:clinic_management_app/presentation/screens/doctors/doctors_screen.dart';
import 'package:clinic_management_app/presentation/screens/login/login_screen.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/medical_records_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/role_selection_screen.dart';
import 'package:clinic_management_app/presentation/screens/patients/patients_screen.dart';
import 'package:clinic_management_app/presentation/screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FcmService().initialize();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => DoctorRepository()),
        RepositoryProvider(create: (_) => PatientRepository()),
        RepositoryProvider(create: (_) => AppointmentRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => OnboardingCubit()),
          BlocProvider(create: (context) => DoctorBloc(RepositoryProvider.of<DoctorRepository>(context))),
          BlocProvider(create: (context) => PatientBloc(RepositoryProvider.of<PatientRepository>(context))),
          BlocProvider(create: (context) => AppointmentBloc(RepositoryProvider.of<AppointmentRepository>(context))),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => MaterialApp(
            title: 'Clinic Management',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
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
              AppRoutes.settings: (_) => const SettingsScreen(),
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
