import 'package:get_it/get_it.dart';
import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/data/repositories/doctor_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/patient_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/appointment_repository_impl.dart';
import 'package:clinic_management_app/data/repositories/medical_record_repository_impl.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/domain/usecases/doctor/get_doctors.dart';
import 'package:clinic_management_app/domain/usecases/doctor/search_doctors.dart';
import 'package:clinic_management_app/domain/usecases/doctor/add_doctor.dart';
import 'package:clinic_management_app/domain/usecases/doctor/update_doctor.dart';
import 'package:clinic_management_app/domain/usecases/doctor/delete_doctor.dart';
import 'package:clinic_management_app/domain/usecases/patient/get_patients.dart';
import 'package:clinic_management_app/domain/usecases/patient/search_patients.dart';
import 'package:clinic_management_app/domain/usecases/patient/add_patient.dart';
import 'package:clinic_management_app/domain/usecases/patient/update_patient.dart';
import 'package:clinic_management_app/domain/usecases/patient/delete_patient.dart';
import 'package:clinic_management_app/domain/usecases/appointment/get_appointments.dart';
import 'package:clinic_management_app/domain/usecases/appointment/get_appointments_by_date.dart';
import 'package:clinic_management_app/domain/usecases/appointment/add_appointment.dart';
import 'package:clinic_management_app/domain/usecases/appointment/update_appointment.dart';
import 'package:clinic_management_app/domain/usecases/appointment/delete_appointment.dart';
import 'package:clinic_management_app/domain/usecases/medical_record/get_medical_records.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // DataSource
  sl.registerLazySingleton<MockDataSource>(() => MockDataSource());

  // Repositories
  sl.registerLazySingleton<DoctorRepository>(() => DoctorRepositoryImpl(sl()));
  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryImpl(sl()));
  sl.registerLazySingleton<AppointmentRepository>(() => AppointmentRepositoryImpl(sl()));
  sl.registerLazySingleton<MedicalRecordRepository>(() => MedicalRecordRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => GetDoctors(sl()));
  sl.registerLazySingleton(() => SearchDoctors(sl()));
  sl.registerLazySingleton(() => AddDoctor(sl()));
  sl.registerLazySingleton(() => UpdateDoctor(sl()));
  sl.registerLazySingleton(() => DeleteDoctor(sl()));
  sl.registerLazySingleton(() => GetPatients(sl()));
  sl.registerLazySingleton(() => SearchPatients(sl()));
  sl.registerLazySingleton(() => AddPatient(sl()));
  sl.registerLazySingleton(() => UpdatePatient(sl()));
  sl.registerLazySingleton(() => DeletePatient(sl()));
  sl.registerLazySingleton(() => GetAppointments(sl()));
  sl.registerLazySingleton(() => GetAppointmentsByDate(sl()));
  sl.registerLazySingleton(() => AddAppointment(sl()));
  sl.registerLazySingleton(() => UpdateAppointment(sl()));
  sl.registerLazySingleton(() => DeleteAppointment(sl()));
  sl.registerLazySingleton(() => GetMedicalRecords(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit());
  sl.registerFactory(() => OnboardingCubit());
  sl.registerFactory(() => ThemeProvider());
}
