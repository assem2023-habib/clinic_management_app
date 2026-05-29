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
import 'package:clinic_management_app/data/repositories/location_repository_impl.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/location/location_cubit.dart';
import 'package:clinic_management_app/presentation/screens/appointments/appointments_screen.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:clinic_management_app/presentation/screens/doctors/doctors_screen.dart';
import 'package:clinic_management_app/presentation/screens/doctors/doctor_profile_screen.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/user_booking_screen.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/appointment_confirmation_screen.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/presentation/screens/rating/rating_screen.dart';
import 'package:clinic_management_app/presentation/screens/services/services_screen.dart';
import 'package:clinic_management_app/presentation/screens/search_doctors/search_doctors_screen.dart';
import 'package:clinic_management_app/presentation/screens/offline/offline_screen.dart';
import 'package:clinic_management_app/presentation/screens/notification/notification_screen.dart';
import 'package:clinic_management_app/presentation/screens/weak_connection/weak_connection_screen.dart';
import 'package:clinic_management_app/presentation/screens/rate_limit/rate_limit_screen.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/screens/download_files/download_files_screen.dart';
import 'package:clinic_management_app/presentation/screens/login/login_screen.dart';
import 'package:clinic_management_app/presentation/screens/server_error/server_error_screen.dart';
import 'package:clinic_management_app/presentation/screens/service_stopped/service_stopped_screen.dart';
import 'package:clinic_management_app/presentation/screens/forbidden/forbidden_screen.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/medical_records_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/role_selection_screen.dart';
import 'package:clinic_management_app/presentation/screens/patients/patients_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_patient_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_doctor_screen.dart';

import 'package:clinic_management_app/presentation/screens/profile/profile_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/change_password_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/delete_account_screen.dart';
import 'package:clinic_management_app/presentation/screens/settings/settings_screen.dart';
import 'package:clinic_management_app/presentation/screens/splash_screen.dart';

Route<dynamic> _buildRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.05, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(begin: 0.5, end: 1.0).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
  }

  @override
  Widget build(BuildContext context) {
    final mockDataSource = MockDataSource();
    final apiService = ApiService();
    ApiService.onRateLimit = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.rateLimit);
    ApiService.onNetworkError = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.offline);
    ApiService.onServerError = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.serverError);
    ApiService.onForbidden = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.forbidden);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DoctorRepository>(create: (_) => DoctorRepositoryImpl(mockDataSource)),
        RepositoryProvider<PatientRepository>(create: (_) => PatientRepositoryImpl(mockDataSource)),
        RepositoryProvider<AppointmentRepository>(create: (_) => AppointmentRepositoryImpl(mockDataSource)),
        RepositoryProvider<MedicalRecordRepository>(create: (_) => MedicalRecordRepositoryImpl(mockDataSource)),
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl(AuthRemoteDataSource(apiService), apiService)),
        RepositoryProvider<LocationRepository>(create: (_) => LocationRepositoryImpl(mockDataSource)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => OnboardingCubit()),
          BlocProvider(create: (context) => DoctorBloc(RepositoryProvider.of<DoctorRepository>(context))),
          BlocProvider(create: (context) => PatientBloc(RepositoryProvider.of<PatientRepository>(context))),
          BlocProvider(create: (context) => AppointmentBloc(RepositoryProvider.of<AppointmentRepository>(context))),
          BlocProvider(create: (context) => MedicalRecordBloc(RepositoryProvider.of<MedicalRecordRepository>(context))),
          BlocProvider(create: (context) => DoctorProfileBloc(RepositoryProvider.of<DoctorRepository>(context))),
          BlocProvider(create: (context) => ProfileCubit(authRepository: RepositoryProvider.of<AuthRepository>(context))),
          BlocProvider(create: (context) => LocationCubit(locationRepository: RepositoryProvider.of<LocationRepository>(context))..loadCountries()),
          BlocProvider(create: (_) => RatingBloc()),
          BlocProvider(create: (_) => DownloadFileBloc()),
          BlocProvider(create: (_) => NotificationBloc()),
        ],
        child: ListenableBuilder(
          listenable: _themeProvider,
          builder: (context, _) => MaterialApp(
            title: 'Clinic Management',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeProvider.themeMode,
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            onGenerateRoute: (settings) {
              Widget screen;
              switch (settings.name) {
                case AppRoutes.roleSelection:
                  screen = const RoleSelectionScreen();
                case AppRoutes.onboarding:
                  screen = const OnboardingScreen();
                case AppRoutes.login:
                  screen = LoginScreen();
                case AppRoutes.dashboard:
                  screen = DashboardScreen(themeProvider: _themeProvider);
                case AppRoutes.doctors:
                  screen = const DoctorsScreen();
                case AppRoutes.patients:
                  screen = const PatientsScreen();
                case AppRoutes.appointments:
                  screen = const AppointmentsScreen();
                case AppRoutes.medicalRecords:
                  screen = const MedicalRecordsScreen();
                case AppRoutes.settings:
                  screen = SettingsScreen(themeProvider: _themeProvider);
                case AppRoutes.registerPatient:
                  screen = const RegisterPatientScreen();
                case AppRoutes.registerDoctor:
                  screen = const RegisterDoctorScreen();
                case AppRoutes.profile:
                  screen = const ProfileScreen();
                case AppRoutes.changePassword:
                  screen = const ChangePasswordScreen();
                case AppRoutes.doctorProfile:
                  final doctorId = settings.arguments as String? ?? '';
                  screen = DoctorProfileScreen(doctorId: doctorId);
                case AppRoutes.userBooking:
                  final bookingDoctorId = settings.arguments as String? ?? '';
                  screen = UserBookingScreen(doctorId: bookingDoctorId);
                case AppRoutes.appointmentConfirmation:
                  final confirmationData = settings.arguments as ConfirmationData;
                  screen = AppointmentConfirmationScreen(data: confirmationData);
                case AppRoutes.deleteAccount:
                  screen = const DeleteAccountScreen();
                case AppRoutes.rating:
                  final ratingDoctorId = settings.arguments as String?;
                  screen = RatingScreen(doctorId: ratingDoctorId);
                case AppRoutes.searchDoctors:
                  screen = const SearchDoctorsScreen();
                case AppRoutes.services:
                  screen = const ServicesScreen();
                case AppRoutes.notifications:
                  screen = const NotificationScreen();
                case AppRoutes.weakConnection:
                  screen = const WeakConnectionScreen();
                case AppRoutes.offline:
                  screen = const OfflineScreen();
                case AppRoutes.rateLimit:
                  screen = const RateLimitScreen();
                case AppRoutes.downloadFiles:
                  screen = const DownloadFilesScreen();
                case AppRoutes.serviceStopped:
                  screen = const ServiceStoppedScreen();
                case AppRoutes.serverError:
                  screen = const ServerErrorScreen();
                case AppRoutes.forbidden:
                  screen = const ForbiddenScreen();
                default:
                  screen = const RoleSelectionScreen();
              }
              return _buildRoute(screen);
            },
          ),
        ),
      ),
    );
  }
}


