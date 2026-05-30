import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';
import 'package:clinic_management_app/data/models/review_model.dart';
import 'package:clinic_management_app/data/models/doctor_schedule_model.dart';
import 'package:clinic_management_app/data/models/rating_model.dart';

class MockDataSource implements DataSource {
  final List<CountryModel> _countries = [
    const CountryModel(id: 'sy', nameEn: 'Syria', nameAr: 'سُورِيَا', code: 'SY', flag: '🇸🇾'),
    const CountryModel(id: 'eg', nameEn: 'Egypt', nameAr: 'مِصْرُ', code: 'EG', flag: '🇪🇬'),
    const CountryModel(id: 'sa', nameEn: 'Saudi Arabia', nameAr: 'السُّعُودِيَّةُ', code: 'SA', flag: '🇸🇦'),
  ];
  final List<CityModel> _cities = [
    const CityModel(id: 'sy-1', nameEn: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    const CityModel(id: 'sa-1', nameEn: 'Riyadh', nameAr: 'الرِّيَاضُ', countryId: 'sa'),
    const CityModel(id: 'eg-1', nameEn: 'Cairo', nameAr: 'القَاهِرَةُ', countryId: 'eg'),
  ];
  final List<DoctorModel> _doctors = [];
  final List<PatientModel> _patients = [];
  final List<ReviewModel> _reviews = [];
  final List<DoctorScheduleModel> _schedules = [];
  final List<AppointmentModel> _appointments = [];
  final List<MedicalRecordModel> _medicalRecords = [];
  final List<RatingModel> _ratings = [];

  @override
  List<DoctorModel> get allDoctors => List.unmodifiable(_doctors);
  @override
  List<PatientModel> get allPatients => List.unmodifiable(_patients);
  @override
  List<AppointmentModel> get allAppointments => List.unmodifiable(_appointments);
  @override
  List<MedicalRecordModel> get allMedicalRecords => List.unmodifiable(_medicalRecords);

  @override
  DoctorModel? doctorById(String id) {
    try { return _doctors.firstWhere((d) => d.id == id); } catch (_) { return null; }
  }
  @override
  PatientModel? patientById(String id) {
    try { return _patients.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }
  @override
  void addDoctor(DoctorModel doctor) => _doctors.add(doctor);
  @override
  void updateDoctor(DoctorModel doctor) {
    final i = _doctors.indexWhere((d) => d.id == doctor.id);
    if (i != -1) _doctors[i] = doctor;
  }
  @override
  void deleteDoctor(String id) => _doctors.removeWhere((d) => d.id == id);
  @override
  List<DoctorModel> searchDoctors(String query) => _doctors.where((d) => '${d.firstName} ${d.lastName}'.contains(query)).toList();
  @override
  void addPatient(PatientModel patient) => _patients.add(patient);
  @override
  void updatePatient(PatientModel patient) {
    final i = _patients.indexWhere((p) => p.id == patient.id);
    if (i != -1) _patients[i] = patient;
  }
  @override
  void deletePatient(String id) => _patients.removeWhere((p) => p.id == id);
  @override
  List<PatientModel> searchPatients(String query) => _patients.where((p) => '${p.firstName} ${p.lastName}'.contains(query)).toList();
  @override
  void addAppointment(AppointmentModel appointment) => _appointments.add(appointment);
  @override
  void updateAppointment(AppointmentModel appointment) {
    final i = _appointments.indexWhere((a) => a.id == appointment.id);
    if (i != -1) _appointments[i] = appointment;
  }
  @override
  void deleteAppointment(String id) => _appointments.removeWhere((a) => a.id == id);
  @override
  List<AppointmentModel> appointmentsByDate(DateTime date) => _appointments.where((a) => a.appointmentDate == date.toIso8601String().substring(0, 10)).toList();
  @override
  List<AppointmentModel> appointmentsByPatient(String patientId) => _appointments.where((a) {
    final p = a.patient;
    return p != null && p['id'] == patientId;
  }).toList();
  @override
  int get todayAppointmentCount => appointmentsByDate(DateTime.now()).length;
  @override
  void addMedicalRecord(MedicalRecordModel record) => _medicalRecords.add(record);
  @override
  List<CountryModel> get allCountries => List.unmodifiable(_countries);
  @override
  List<CityModel> get allCities => List.unmodifiable(_cities);
  @override
  List<CityModel> citiesByCountry(String countryId) => _cities.where((c) => c.countryId == countryId).toList();
  @override
  List<CityModel> searchCities(String query, {String? countryId}) {
    var r = _cities.where((c) => c.nameEn.contains(query) || c.nameAr.contains(query));
    if (countryId != null) r = r.where((c) => c.countryId == countryId);
    return r.toList();
  }
  @override
  List<ReviewModel> getDoctorReviews(String doctorId) => List.unmodifiable(_reviews);
  @override
  List<DoctorScheduleModel> getDoctorSlots(String doctorId, DateTime month) => _schedules.where((s) => s.id.startsWith('${doctorId}_')).toList();
  @override
  void addReview(String doctorId, ReviewModel review) => _reviews.add(review);
  @override
  void toggleSlotAvailability(String slotId) {
    final i = _schedules.indexWhere((s) => s.id == slotId);
    if (i != -1) {
      _schedules[i] = DoctorScheduleModel(id: _schedules[i].id, dayOfWeek: _schedules[i].dayOfWeek, startTime: _schedules[i].startTime, endTime: _schedules[i].endTime, isActive: !_schedules[i].isActive);
    }
  }

  @override
  List<RatingModel> get allRatings => List.unmodifiable(_ratings);
  @override
  void addRating(RatingModel rating) => _ratings.add(rating);
  @override
  void updateRating(RatingModel rating) {
    final i = _ratings.indexWhere((r) => r.id == rating.id);
    if (i != -1) _ratings[i] = rating;
  }
  @override
  void deleteRating(String id) => _ratings.removeWhere((r) => r.id == id);

  @override
  DashboardData getDashboardData() => DashboardData(
    users: UsersStats(
      total: 150, doctors: 25, patients: 100, receptionists: 10, admins: 5,
      active: 140, inactive: 10, newToday: 3, newThisWeek: 15, newThisMonth: 50,
    ),
    appointments: AppointmentsStats(
      total: 500, today: 12, thisWeek: 60, thisMonth: 200,
      byStatus: {'pending': 30, 'confirmed': 100, 'completed': 350, 'cancelled': 20},
    ),
    patients: PatientsStats(total: 100, newThisMonth: 15, registeredToday: 3),
    doctors: const DoctorsStats(total: 25),
    totalMedicalRecords: 300,
    totalPrescriptions: 450,
    specializations: SpecializationsStats(
      total: 15,
      top: [
        const SpecializationCount(name: 'Cardiology', doctorsCount: 5),
        const SpecializationCount(name: 'Dermatology', doctorsCount: 3),
      ],
    ),
    ratings: const RatingsStats(average: 4.2, total: 80),
  );
}
