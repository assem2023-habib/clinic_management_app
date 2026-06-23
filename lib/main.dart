import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/core/config/api_config.dart';
import 'package:clinic_management_app/core/services/fcm_service.dart';
import 'package:clinic_management_app/core/services/cache_service.dart';
import 'package:clinic_management_app/core/di/providers.dart';
import 'package:clinic_management_app/core/theme/app_theme.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/language/language_cubit.dart';
import 'package:clinic_management_app/presentation/screens/splash_screen.dart';
import 'package:clinic_management_app/presentation/screens/login/login_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/role_selection_screen.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:clinic_management_app/presentation/screens/doctors/doctors_screen.dart';
import 'package:clinic_management_app/presentation/screens/doctors/doctor_profile_screen.dart';
import 'package:clinic_management_app/presentation/screens/patients/patients_screen.dart';
import 'package:clinic_management_app/presentation/screens/appointments/appointments_screen.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/medical_records_screen.dart';
import 'package:clinic_management_app/presentation/screens/settings/settings_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/profile_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/change_password_screen.dart';
import 'package:clinic_management_app/presentation/screens/profile/delete_account_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_patient_screen.dart';
import 'package:clinic_management_app/presentation/screens/register/register_doctor_screen.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/user_booking_screen.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/appointment_confirmation_screen.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/presentation/screens/appointments/my_appointments_screen.dart';
import 'package:clinic_management_app/presentation/screens/rating/rating_screen.dart';
import 'package:clinic_management_app/presentation/screens/search_doctors/search_doctors_screen.dart';
import 'package:clinic_management_app/presentation/screens/services/services_screen.dart';
import 'package:clinic_management_app/presentation/screens/notification/notification_screen.dart';
import 'package:clinic_management_app/presentation/screens/download_files/download_files_screen.dart';
import 'package:clinic_management_app/presentation/screens/upload_files/upload_files_screen.dart';
import 'package:clinic_management_app/presentation/screens/offline/offline_screen.dart';
import 'package:clinic_management_app/presentation/screens/weak_connection/weak_connection_screen.dart';
import 'package:clinic_management_app/presentation/screens/rate_limit/rate_limit_screen.dart';
import 'package:clinic_management_app/presentation/screens/server_error/server_error_screen.dart';
import 'package:clinic_management_app/presentation/screens/forbidden/forbidden_screen.dart';
import 'package:clinic_management_app/presentation/screens/session_expired/session_expired_screen.dart';
import 'package:clinic_management_app/presentation/screens/suspended/suspended_screen.dart';
import 'package:clinic_management_app/presentation/screens/unauthorized/unauthorized_screen.dart';
import 'package:clinic_management_app/presentation/screens/service_stopped/service_stopped_screen.dart';
import 'package:clinic_management_app/presentation/screens/patient_welcome/patient_welcome_screen.dart';
import 'package:clinic_management_app/presentation/screens/supervision/supervision_requests_screen.dart';

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
  await Hive.initFlutter();
  await CacheService.init();
  await Firebase.initializeApp();
  await FcmService().initialize();
  runApp(const MyApp());
}

class _FcmWatcher extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  const _FcmWatcher({required this.child, required this.navigatorKey});

  @override
  State<_FcmWatcher> createState() => _FcmWatcherState();
}

class _FcmWatcherState extends State<_FcmWatcher> {
  @override
  void initState() {
    super.initState();
    FcmService().messageStream.addListener(_onNewMessage);
    FcmService().tapStream.addListener(_onTap);
  }

  void _onNewMessage() {
    if (!mounted) return;
    context.read<NotificationBloc>().add(const NotificationLoadAll());
  }

  void _onTap() {
    if (!mounted) return;
    final message = FcmService().tapStream.value;
    if (message == null) return;
    final data = message.data;
    final navigator = widget.navigatorKey.currentState;
    if (navigator == null) return;
    final type = data['topic'] ?? data['type'] ?? '';
    if (type.contains('appointment')) {
      navigator.pushNamed(AppRoutes.myAppointments);
    } else {
      navigator.pushNamed(AppRoutes.notifications);
    }
  }

  @override
  void dispose() {
    FcmService().messageStream.removeListener(_onNewMessage);
    FcmService().tapStream.removeListener(_onTap);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
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
    final apiService = ApiService(baseUrl: ApiConfig.apiUrl);
    ApiService.onRateLimit = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.rateLimit);
    ApiService.onNetworkError = () => _navigatorKey.currentState?.pushNamed(AppRoutes.offline);
    ApiService.onServerError = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.serverError);
    ApiService.onForbidden = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.forbidden);
    ApiService.onSuspended = () => _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.suspended);
    ApiService.onSessionExpired = () {
      _navigatorKey.currentState?.pushReplacementNamed(AppRoutes.unauthorized);
    };
    return MultiRepositoryProvider(
      providers: AppProviders.repositoryProviders(
        apiService: apiService,
        mockDataSource: mockDataSource,
      ),
      child: MultiBlocProvider(
        providers: [
          ...AppProviders.blocProviders(context),
          BlocProvider(create: (_) => LanguageCubit()),
        ],
        child: _FcmWatcher(
          navigatorKey: _navigatorKey,
          child: ListenableBuilder(
          listenable: _themeProvider,
          builder: (context, _) => BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) => MaterialApp(
            title: 'Clinic Management',
            locale: locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
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
                  final args = settings.arguments;
                  if (args is Map && args['isAppRating'] == true) {
                    screen = const RatingScreen(isAppRating: true);
                  } else {
                    final ratingDoctorId = args as String?;
                    screen = RatingScreen(doctorId: ratingDoctorId);
                  }
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
                case AppRoutes.sessionExpired:
                  screen = const SessionExpiredScreen();
                case AppRoutes.suspended:
                  screen = const SuspendedScreen();
                case AppRoutes.unauthorized:
                  screen = const UnauthorizedScreen();
                case AppRoutes.uploadFiles:
                  screen = const UploadFilesScreen();
                case AppRoutes.patientWelcome:
                  screen = const PatientWelcomeScreen();
                case AppRoutes.supervisionRequests:
                  screen = const SupervisionRequestsScreen();
                case AppRoutes.myAppointments:
                  screen = const MyAppointmentsScreen();
                default:
                  screen = const RoleSelectionScreen();
              }
              return _buildRoute(screen);
            },
          ),
        ),
      ),
      ),
      ),
    );
  }
}


