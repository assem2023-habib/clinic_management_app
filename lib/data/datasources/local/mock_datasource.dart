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
import 'package:clinic_management_app/domain/entities/dashboard_data.dart';

class MockDataSource implements DataSource {
  final List<CountryModel> _countries = [
    const CountryModel(id: 'sy', nameEn: 'Syria', nameAr: 'سُورِيَا', code: 'SY', flag: '🇸🇾'),
    const CountryModel(id: 'eg', nameEn: 'Egypt', nameAr: 'مِصْرُ', code: 'EG', flag: '🇪🇬'),
    const CountryModel(id: 'sa', nameEn: 'Saudi Arabia', nameAr: 'السُّعُودِيَّةُ', code: 'SA', flag: '🇸🇦'),
    const CountryModel(id: 'iq', nameEn: 'Iraq', nameAr: 'الْعِرَاقُ', code: 'IQ', flag: '🇮🇶'),
    const CountryModel(id: 'jo', nameEn: 'Jordan', nameAr: 'الْأُرْدُنُّ', code: 'JO', flag: '🇯🇴'),
    const CountryModel(id: 'lb', nameEn: 'Lebanon', nameAr: 'لُبْنَانُ', code: 'LB', flag: '🇱🇧'),
    const CountryModel(id: 'ps', nameEn: 'Palestine', nameAr: 'فِلَسْطِينُ', code: 'PS', flag: '🇵🇸'),
    const CountryModel(id: 'ye', nameEn: 'Yemen', nameAr: 'الْيَمَنُ', code: 'YE', flag: '🇾🇪'),
    const CountryModel(id: 'om', nameEn: 'Oman', nameAr: 'عُمَانُ', code: 'OM', flag: '🇴🇲'),
    const CountryModel(id: 'ae', nameEn: 'UAE', nameAr: 'الْإِمَارَاتُ', code: 'AE', flag: '🇦🇪'),
    const CountryModel(id: 'qa', nameEn: 'Qatar', nameAr: 'قَطَرُ', code: 'QA', flag: '🇶🇦'),
    const CountryModel(id: 'bh', nameEn: 'Bahrain', nameAr: 'الْبَحْرَيْنُ', code: 'BH', flag: '🇧🇭'),
    const CountryModel(id: 'kw', nameEn: 'Kuwait', nameAr: 'الْكُوَيْتُ', code: 'KW', flag: '🇰🇼'),
    const CountryModel(id: 'ly', nameEn: 'Libya', nameAr: 'لِيبِيَا', code: 'LY', flag: '🇱🇾'),
    const CountryModel(id: 'tn', nameEn: 'Tunisia', nameAr: 'تُونِسُ', code: 'TN', flag: '🇹🇳'),
    const CountryModel(id: 'dz', nameEn: 'Algeria', nameAr: 'الْجَزَائِرُ', code: 'DZ', flag: '🇩🇿'),
    const CountryModel(id: 'ma', nameEn: 'Morocco', nameAr: 'الْمَغْرِبُ', code: 'MA', flag: '🇲🇦'),
    const CountryModel(id: 'sd', nameEn: 'Sudan', nameAr: 'السُّودَانُ', code: 'SD', flag: '🇸🇩'),
    const CountryModel(id: 'so', nameEn: 'Somalia', nameAr: 'الصُّومَالُ', code: 'SO', flag: '🇸🇴'),
    const CountryModel(id: 'mr', nameEn: 'Mauritania', nameAr: 'مُورِيتَانِيَا', code: 'MR', flag: '🇲🇷'),
    const CountryModel(id: 'dj', nameEn: 'Djibouti', nameAr: 'جِيبُوتِي', code: 'DJ', flag: '🇩🇯'),
    const CountryModel(id: 'km', nameEn: 'Comoros', nameAr: 'جُزُرُ القَمَرِ', code: 'KM', flag: '🇰🇲'),
  ];
  final List<CityModel> _cities = [
    const CityModel(id: 'sy-1', nameEn: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    const CityModel(id: 'sy-2', nameEn: 'Aleppo', nameAr: 'حَلَبُ', countryId: 'sy'),
    const CityModel(id: 'sy-3', nameEn: 'Homs', nameAr: 'حِمْصُ', countryId: 'sy'),
    const CityModel(id: 'sy-4', nameEn: 'Daraa', nameAr: 'دَرْعَا', countryId: 'sy'),
    const CityModel(id: 'eg-1', nameEn: 'Cairo', nameAr: 'القَاهِرَةُ', countryId: 'eg'),
    const CityModel(id: 'eg-2', nameEn: 'Alexandria', nameAr: 'الإِسْكَنْدَرِيَّةُ', countryId: 'eg'),
    const CityModel(id: 'eg-3', nameEn: 'Dahab', nameAr: 'دَهَبُ', countryId: 'eg'),
    const CityModel(id: 'sa-1', nameEn: 'Riyadh', nameAr: 'الرِّيَاضُ', countryId: 'sa'),
    const CityModel(id: 'sa-2', nameEn: 'Jeddah', nameAr: 'جِدَّةُ', countryId: 'sa'),
    const CityModel(id: 'sa-3', nameEn: 'Mecca', nameAr: 'مَكَّةُ', countryId: 'sa'),
    const CityModel(id: 'sa-4', nameEn: 'Medina', nameAr: 'المَدِينَةُ', countryId: 'sa'),
    const CityModel(id: 'sa-5', nameEn: 'Dammam', nameAr: 'الدَّمَّامُ', countryId: 'sa'),
    const CityModel(id: 'iq-1', nameEn: 'Baghdad', nameAr: 'بَغْدَادُ', countryId: 'iq'),
    const CityModel(id: 'iq-2', nameEn: 'Basra', nameAr: 'البَصْرَةُ', countryId: 'iq'),
    const CityModel(id: 'iq-3', nameEn: 'Mosul', nameAr: 'المَوْصِلُ', countryId: 'iq'),
    const CityModel(id: 'iq-4', nameEn: 'Erbil', nameAr: 'أَرْبِيلُ', countryId: 'iq'),
    const CityModel(id: 'jo-1', nameEn: 'Amman', nameAr: 'عَمَّانُ', countryId: 'jo'),
    const CityModel(id: 'jo-2', nameEn: 'Zarqa', nameAr: 'الزَّرْقَاءُ', countryId: 'jo'),
    const CityModel(id: 'jo-3', nameEn: 'Irbid', nameAr: 'إِرْبِدُ', countryId: 'jo'),
    const CityModel(id: 'lb-1', nameEn: 'Beirut', nameAr: 'بَيْرُوتُ', countryId: 'lb'),
    const CityModel(id: 'lb-2', nameEn: 'Tripoli', nameAr: 'طَرَابُلُسُ', countryId: 'lb'),
    const CityModel(id: 'lb-3', nameEn: 'Sidon', nameAr: 'صَيْدَا', countryId: 'lb'),
    const CityModel(id: 'ps-1', nameEn: 'Jerusalem', nameAr: 'القُدْسُ', countryId: 'ps'),
    const CityModel(id: 'ps-2', nameEn: 'Gaza', nameAr: 'غَزَّةُ', countryId: 'ps'),
    const CityModel(id: 'ps-3', nameEn: 'Ramallah', nameAr: 'رَامُ اللهِ', countryId: 'ps'),
    const CityModel(id: 'ye-1', nameEn: 'Sanaa', nameAr: 'صَنْعَاءُ', countryId: 'ye'),
    const CityModel(id: 'ye-2', nameEn: 'Aden', nameAr: 'عَدَنُ', countryId: 'ye'),
    const CityModel(id: 'ye-3', nameEn: 'Taiz', nameAr: 'تَعِزُّ', countryId: 'ye'),
    const CityModel(id: 'ae-1', nameEn: 'Abu Dhabi', nameAr: 'أَبُو ظَبْيٍ', countryId: 'ae'),
    const CityModel(id: 'ae-2', nameEn: 'Dubai', nameAr: 'دُبَيٌّ', countryId: 'ae'),
    const CityModel(id: 'ae-3', nameEn: 'Sharjah', nameAr: 'الشَّارِقَةُ', countryId: 'ae'),
    const CityModel(id: 'qa-1', nameEn: 'Doha', nameAr: 'الدَّوْحَةُ', countryId: 'qa'),
    const CityModel(id: 'qa-2', nameEn: 'Al Rayyan', nameAr: 'الرَّيَّانُ', countryId: 'qa'),
    const CityModel(id: 'bh-1', nameEn: 'Manama', nameAr: 'المَنَامَةُ', countryId: 'bh'),
    const CityModel(id: 'bh-2', nameEn: 'Riffa', nameAr: 'الرِّفَاعُ', countryId: 'bh'),
    const CityModel(id: 'kw-1', nameEn: 'Kuwait City', nameAr: 'مَدِينَةُ الكُوَيْتِ', countryId: 'kw'),
    const CityModel(id: 'kw-2', nameEn: 'Al Ahmadi', nameAr: 'الأَحْمَدِيُّ', countryId: 'kw'),
    const CityModel(id: 'ly-1', nameEn: 'Tripoli', nameAr: 'طَرَابُلُسُ', countryId: 'ly'),
    const CityModel(id: 'ly-2', nameEn: 'Benghazi', nameAr: 'بَنْغَازِي', countryId: 'ly'),
    const CityModel(id: 'tn-1', nameEn: 'Tunis', nameAr: 'تُونِسُ', countryId: 'tn'),
    const CityModel(id: 'tn-2', nameEn: 'Sfax', nameAr: 'صَفَاقِسُ', countryId: 'tn'),
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
    return p != null && p.id == patientId;
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
  List<DoctorScheduleModel> getDoctorSlots(String doctorId, DateTime month) {
    final cached = _schedules.where((s) => s.id.startsWith('${doctorId}_')).toList();
    if (cached.isNotEmpty) return cached;
    final days = ['sunday','monday','tuesday','wednesday','thursday'];
    final schedules = days.map((d) => DoctorScheduleModel(
      id: '${doctorId}_$d',
      dayOfWeek: d,
      startTime: '09:00',
      endTime: '17:00',
      isActive: true,
    )).toList();
    _schedules.addAll(schedules);
    return schedules;
  }
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
