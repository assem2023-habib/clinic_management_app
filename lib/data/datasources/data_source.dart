import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';
import 'package:clinic_management_app/data/models/review_model.dart';
import 'package:clinic_management_app/data/models/doctor_schedule_model.dart';

abstract class DataSource {
  List<DoctorModel> get allDoctors;
  List<PatientModel> get allPatients;
  List<AppointmentModel> get allAppointments;
  List<MedicalRecordModel> get allMedicalRecords;

  DoctorModel? doctorById(String id);
  PatientModel? patientById(String id);

  void addDoctor(DoctorModel doctor);
  void updateDoctor(DoctorModel doctor);
  void deleteDoctor(String id);
  List<DoctorModel> searchDoctors(String query);

  void addPatient(PatientModel patient);
  void updatePatient(PatientModel patient);
  void deletePatient(String id);
  List<PatientModel> searchPatients(String query);

  void addAppointment(AppointmentModel appointment);
  void updateAppointment(AppointmentModel appointment);
  void deleteAppointment(String id);
  List<AppointmentModel> appointmentsByDate(DateTime date);
  List<AppointmentModel> appointmentsByPatient(String patientId);
  int get todayAppointmentCount;

  void addMedicalRecord(MedicalRecordModel record);

  List<CountryModel> get allCountries;
  List<CityModel> get allCities;
  List<CityModel> citiesByCountry(String countryId);
  List<CityModel> searchCities(String query, {String? countryId});

  List<ReviewModel> getDoctorReviews(String doctorId);
  List<DoctorScheduleModel> getDoctorSlots(String doctorId, DateTime month);
  void addReview(String doctorId, ReviewModel review);
  void toggleSlotAvailability(String slotId);
}
