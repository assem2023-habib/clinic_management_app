import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/patient_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/prescription_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/rbac_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/supervision_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/receptionist_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/doctor_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/notification_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/medical_record_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/location_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/image_remote_datasource.dart';
import 'package:clinic_management_app/data/datasources/remote/rating_remote_datasource.dart';
import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/core/services/appointment_rtdb_service.dart';
import 'package:clinic_management_app/data/repositories/doctor_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/patient_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/prescription_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/rbac_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/supervision_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/user_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/specialization_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/receptionist_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/appointment_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/medical_record_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/image_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/auth_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/location_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/rating_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/dashboard_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/notification_repository_impl.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';
import 'package:clinic_management_app/domain/repositories/rating_repository.dart';
import 'package:clinic_management_app/domain/repositories/dashboard_repository.dart';
import 'package:clinic_management_app/domain/repositories/notification_repository.dart';
import 'package:clinic_management_app/domain/repositories/prescription_repository.dart';
import 'package:clinic_management_app/domain/repositories/rbac_repository.dart';
import 'package:clinic_management_app/domain/repositories/supervision_repository.dart';
import 'package:clinic_management_app/domain/repositories/user_repository.dart';
import 'package:clinic_management_app/domain/repositories/receptionist_repository.dart';
import 'package:clinic_management_app/domain/repositories/specialization_repository.dart';
import 'package:clinic_management_app/domain/repositories/image_repository.dart';
import 'package:clinic_management_app/presentation/blocs/prescription/prescription_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/rbac/rbac_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/supervision/supervision_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/receptionist/receptionist_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/profile/profile_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/location/location_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_bloc.dart';
import 'package:clinic_management_app/data/datasources/remote/file_remote_datasource.dart';
import 'package:clinic_management_app/data/repositories/file_repository_impl.dart';
import 'package:clinic_management_app/domain/repositories/file_repository.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';

class AppProviders {
  static List<RepositoryProvider> repositoryProviders({
    required ApiService apiService,
    required MockDataSource mockDataSource,
  }) {
    return [
      RepositoryProvider<DoctorRepository>(create: (_) => DoctorRepositoryImpl(mockDataSource,
        remoteDataSource: DoctorRemoteDataSource(apiService),
      )),
      RepositoryProvider<PatientRepository>(create: (_) => PatientRepositoryImpl(mockDataSource,
        remoteDataSource: PatientRemoteDataSource(apiService),
      )),
      RepositoryProvider<AppointmentRepository>(create: (_) => AppointmentRepositoryImpl(
        mockDataSource,
        remoteDataSource: AppointmentRemoteDataSource(apiService),
        rtdbService: AppointmentRtdbService(FirebaseDatabase.instance),
      )),
      RepositoryProvider<MedicalRecordRepository>(create: (_) => MedicalRecordRepositoryImpl(
        remoteDataSource: MedicalRecordRemoteDataSource(apiService),
      )),
      RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl(AuthRemoteDataSource(apiService), apiService)),
      RepositoryProvider<LocationRepository>(create: (_) => LocationRepositoryImpl(mockDataSource,
        remoteDataSource: LocationRemoteDataSource(apiService),
      )),
      RepositoryProvider<RatingRepository>(create: (_) => RatingRepositoryImpl(
        localDataSource: mockDataSource,
        remoteDataSource: RatingRemoteDataSource(apiService),
      )),
      RepositoryProvider<DashboardRepository>(create: (_) => DashboardRepositoryImpl(
        localDataSource: mockDataSource,
        remoteDataSource: DashboardRemoteDataSource(apiService),
      )),
      RepositoryProvider<NotificationRepository>(create: (_) => NotificationRepositoryImpl(
        remoteDataSource: NotificationRemoteDataSource(apiService),
      )),
      RepositoryProvider<PrescriptionRepository>(create: (_) => PrescriptionRepositoryImpl(
        remoteDataSource: PrescriptionRemoteDataSource(apiService),
      )),
      RepositoryProvider<RbacRepository>(create: (_) => RbacRepositoryImpl(
        remoteDataSource: RbacRemoteDataSource(apiService),
      )),
      RepositoryProvider<SupervisionRepository>(create: (_) => SupervisionRepositoryImpl(
        remoteDataSource: SupervisionRemoteDataSource(apiService),
      )),
      RepositoryProvider<UserRepository>(create: (_) => UserRepositoryImpl(
        remoteDataSource: UserRemoteDataSource(apiService),
      )),
      RepositoryProvider<SpecializationRepository>(create: (_) => SpecializationRepositoryImpl(
        remoteDataSource: DoctorRemoteDataSource(apiService),
      )),
      RepositoryProvider<ReceptionistRepository>(create: (_) => ReceptionistRepositoryImpl(
        remoteDataSource: ReceptionistRemoteDataSource(apiService),
      )),
      RepositoryProvider<ImageRepository>(create: (_) => ImageRepositoryImpl(
        remoteDataSource: ImageRemoteDataSource(apiService),
      )),
      RepositoryProvider<FileRepository>(create: (_) => FileRepositoryImpl(
        remoteDataSource: FileRemoteDataSource(apiService),
      )),
    ];
  }

  static List<BlocProvider> blocProviders(BuildContext context) {
    return [
      BlocProvider<AuthCubit>(create: (ctx) => AuthCubit(authRepository: RepositoryProvider.of<AuthRepository>(ctx))),
      BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
      BlocProvider<DoctorBloc>(create: (ctx) => DoctorBloc(RepositoryProvider.of<DoctorRepository>(ctx))),
      BlocProvider<PatientBloc>(create: (ctx) => PatientBloc(RepositoryProvider.of<PatientRepository>(ctx))),
      BlocProvider<AppointmentBloc>(create: (ctx) => AppointmentBloc(RepositoryProvider.of<AppointmentRepository>(ctx))),
      BlocProvider<MedicalRecordBloc>(create: (ctx) => MedicalRecordBloc(RepositoryProvider.of<MedicalRecordRepository>(ctx))),
      BlocProvider<DoctorProfileBloc>(create: (ctx) => DoctorProfileBloc(RepositoryProvider.of<DoctorRepository>(ctx))),
      BlocProvider<ProfileCubit>(create: (ctx) => ProfileCubit(authRepository: RepositoryProvider.of<AuthRepository>(ctx))),
      BlocProvider<LocationCubit>(create: (ctx) => LocationCubit(locationRepository: RepositoryProvider.of<LocationRepository>(ctx))..loadCountries()),
      BlocProvider<DashboardBloc>(create: (ctx) => DashboardBloc(RepositoryProvider.of<DashboardRepository>(ctx))),
      BlocProvider<RatingBloc>(create: (ctx) => RatingBloc(repository: RepositoryProvider.of<RatingRepository>(ctx))),
      BlocProvider<DownloadFileBloc>(create: (ctx) => DownloadFileBloc(RepositoryProvider.of<FileRepository>(ctx))),
      BlocProvider<FileBloc>(create: (ctx) => FileBloc(RepositoryProvider.of<FileRepository>(ctx))),
      BlocProvider<NotificationBloc>(create: (ctx) => NotificationBloc(RepositoryProvider.of<NotificationRepository>(ctx))),
      BlocProvider<PrescriptionBloc>(create: (ctx) => PrescriptionBloc(RepositoryProvider.of<PrescriptionRepository>(ctx))),
      BlocProvider<RbacBloc>(create: (ctx) => RbacBloc(RepositoryProvider.of<RbacRepository>(ctx))),
      BlocProvider<SupervisionBloc>(create: (ctx) => SupervisionBloc(RepositoryProvider.of<SupervisionRepository>(ctx))),
      BlocProvider<ReceptionistBloc>(create: (ctx) => ReceptionistBloc(RepositoryProvider.of<ReceptionistRepository>(ctx))),
      BlocProvider<UserBloc>(create: (ctx) => UserBloc(RepositoryProvider.of<UserRepository>(ctx))),
    ];
  }
}
