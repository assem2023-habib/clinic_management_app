import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class MockDataSource implements DataSource {
  final List<CountryModel> _countries = [
    const CountryModel(id: 'sy', name: 'Syria', nameAr: 'سُورِيَا', code: 'SY', phoneCode: '+963', flag: '🇸🇾'),
    const CountryModel(id: 'eg', name: 'Egypt', nameAr: 'مِصْرُ', code: 'EG', phoneCode: '+20', flag: '🇪🇬'),
    const CountryModel(id: 'sa', name: 'Saudi Arabia', nameAr: 'السُّعُودِيَّةُ', code: 'SA', phoneCode: '+966', flag: '🇸🇦'),
    const CountryModel(id: 'ae', name: 'UAE', nameAr: 'الإِمَارَاتُ', code: 'AE', phoneCode: '+971', flag: '🇦🇪'),
    const CountryModel(id: 'qa', name: 'Qatar', nameAr: 'قَطَرُ', code: 'QA', phoneCode: '+974', flag: '🇶🇦'),
    const CountryModel(id: 'kw', name: 'Kuwait', nameAr: 'الكُوَيْتُ', code: 'KW', phoneCode: '+965', flag: '🇰🇼'),
    const CountryModel(id: 'jo', name: 'Jordan', nameAr: 'الأُرْدُنُّ', code: 'JO', phoneCode: '+962', flag: '🇯🇴'),
    const CountryModel(id: 'lb', name: 'Lebanon', nameAr: 'لُبْنَانُ', code: 'LB', phoneCode: '+961', flag: '🇱🇧'),
    const CountryModel(id: 'ps', name: 'Palestine', nameAr: 'فِلَسْطِينُ', code: 'PS', phoneCode: '+970', flag: '🇵🇸'),
    const CountryModel(id: 'iq', name: 'Iraq', nameAr: 'العِرَاقُ', code: 'IQ', phoneCode: '+964', flag: '🇮🇶'),
    const CountryModel(id: 'ye', name: 'Yemen', nameAr: 'اليَمَنُ', code: 'YE', phoneCode: '+967', flag: '🇾🇪'),
    const CountryModel(id: 'ly', name: 'Libya', nameAr: 'لِيبِيَا', code: 'LY', phoneCode: '+218', flag: '🇱🇾'),
    const CountryModel(id: 'tn', name: 'Tunisia', nameAr: 'تُونِسُ', code: 'TN', phoneCode: '+216', flag: '🇹🇳'),
    const CountryModel(id: 'dz', name: 'Algeria', nameAr: 'الجَزَائِرُ', code: 'DZ', phoneCode: '+213', flag: '🇩🇿'),
    const CountryModel(id: 'ma', name: 'Morocco', nameAr: 'المَغْرِبُ', code: 'MA', phoneCode: '+212', flag: '🇲🇦'),
    const CountryModel(id: 'sd', name: 'Sudan', nameAr: 'السُّودَانُ', code: 'SD', phoneCode: '+249', flag: '🇸🇩'),
    const CountryModel(id: 'om', name: 'Oman', nameAr: 'عُمَانُ', code: 'OM', phoneCode: '+968', flag: '🇴🇲'),
    const CountryModel(id: 'bh', name: 'Bahrain', nameAr: 'البَحْرَيْنُ', code: 'BH', phoneCode: '+973', flag: '🇧🇭'),
    const CountryModel(id: 'us', name: 'United States', nameAr: 'الوِلَايَاتُ المُتَّحِدَةُ', code: 'US', phoneCode: '+1', flag: '🇺🇸'),
    const CountryModel(id: 'gb', name: 'United Kingdom', nameAr: 'المَمْلَكَةُ المُتَّحِدَةُ', code: 'GB', phoneCode: '+44', flag: '🇬🇧'),
    const CountryModel(id: 'fr', name: 'France', nameAr: 'فَرَنْسَا', code: 'FR', phoneCode: '+33', flag: '🇫🇷'),
    const CountryModel(id: 'de', name: 'Germany', nameAr: 'أَلْمَانِيَا', code: 'DE', phoneCode: '+49', flag: '🇩🇪'),
  ];

  final List<CityModel> _cities = [
    const CityModel(id: 'sy-1', name: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    const CityModel(id: 'sy-2', name: 'Aleppo', nameAr: 'حَلَبُ', countryId: 'sy'),
    const CityModel(id: 'sy-3', name: 'Homs', nameAr: 'حِمْصُ', countryId: 'sy'),
    const CityModel(id: 'sy-4', name: 'Latakia', nameAr: 'اللَّاذِقِيَّةُ', countryId: 'sy'),
    const CityModel(id: 'eg-1', name: 'Cairo', nameAr: 'القَاهِرَةُ', countryId: 'eg'),
    const CityModel(id: 'eg-2', name: 'Alexandria', nameAr: 'الإِسْكَنْدَرِيَّةُ', countryId: 'eg'),
    const CityModel(id: 'eg-3', name: 'Giza', nameAr: 'الجِيزَةُ', countryId: 'eg'),
    const CityModel(id: 'sa-1', name: 'Riyadh', nameAr: 'الرِّيَاضُ', countryId: 'sa'),
    const CityModel(id: 'sa-2', name: 'Jeddah', nameAr: 'جِدَّةُ', countryId: 'sa'),
    const CityModel(id: 'sa-3', name: 'Mecca', nameAr: 'مَكَّةُ المُكَرَّمَةُ', countryId: 'sa'),
    const CityModel(id: 'sa-4', name: 'Medina', nameAr: 'المَدِينَةُ المُنَوَّرَةُ', countryId: 'sa'),
    const CityModel(id: 'sa-5', name: 'Dammam', nameAr: 'الدَّمَّامُ', countryId: 'sa'),
    const CityModel(id: 'ae-1', name: 'Dubai', nameAr: 'دُبَيٌّ', countryId: 'ae'),
    const CityModel(id: 'ae-2', name: 'Abu Dhabi', nameAr: 'أَبُو ظَبْيٍ', countryId: 'ae'),
    const CityModel(id: 'ae-3', name: 'Sharjah', nameAr: 'الشَّارِقَةُ', countryId: 'ae'),
    const CityModel(id: 'qa-1', name: 'Doha', nameAr: 'الدَّوْحَةُ', countryId: 'qa'),
    const CityModel(id: 'kw-1', name: 'Kuwait City', nameAr: 'مَدِينَةُ الكُوَيْتِ', countryId: 'kw'),
    const CityModel(id: 'jo-1', name: 'Amman', nameAr: 'عَمَّانُ', countryId: 'jo'),
    const CityModel(id: 'jo-2', name: 'Irbid', nameAr: 'إِرْبِدُ', countryId: 'jo'),
    const CityModel(id: 'lb-1', name: 'Beirut', nameAr: 'بَيْرُوتُ', countryId: 'lb'),
    const CityModel(id: 'lb-2', name: 'Tripoli', nameAr: 'طَرَابُلُسُ', countryId: 'lb'),
    const CityModel(id: 'ps-1', name: 'Jerusalem', nameAr: 'القُدْسُ', countryId: 'ps'),
    const CityModel(id: 'ps-2', name: 'Ramallah', nameAr: 'رَامُ اللَّهِ', countryId: 'ps'),
    const CityModel(id: 'ps-3', name: 'Gaza', nameAr: 'غَزَّةُ', countryId: 'ps'),
    const CityModel(id: 'iq-1', name: 'Baghdad', nameAr: 'بَغْدَادُ', countryId: 'iq'),
    const CityModel(id: 'iq-2', name: 'Basra', nameAr: 'البَصْرَةُ', countryId: 'iq'),
    const CityModel(id: 'iq-3', name: 'Erbil', nameAr: 'أَرْبِيلُ', countryId: 'iq'),
    const CityModel(id: 'tn-1', name: 'Tunis', nameAr: 'تُونِسُ', countryId: 'tn'),
    const CityModel(id: 'dz-1', name: 'Algiers', nameAr: 'الجَزَائِرُ', countryId: 'dz'),
    const CityModel(id: 'ma-1', name: 'Rabat', nameAr: 'الرِّبَاطُ', countryId: 'ma'),
    const CityModel(id: 'ma-2', name: 'Casablanca', nameAr: 'الدَّارُ البَيْضَاءُ', countryId: 'ma'),
    const CityModel(id: 'us-1', name: 'New York', nameAr: 'نِيُويُورْكُ', countryId: 'us'),
    const CityModel(id: 'us-2', name: 'Washington DC', nameAr: 'وَاشِنْطُنُ', countryId: 'us'),
    const CityModel(id: 'gb-1', name: 'London', nameAr: 'لَنْدَنُ', countryId: 'gb'),
    const CityModel(id: 'fr-1', name: 'Paris', nameAr: 'بَارِيسُ', countryId: 'fr'),
    const CityModel(id: 'de-1', name: 'Berlin', nameAr: 'بَرْلِينُ', countryId: 'de'),
  ];

  final List<DoctorModel> _doctors = [
    const DoctorModel(id: 'd1', name: 'د. أحمد الرشيد', specialty: 'قلب', phone: '+966-50-123-4567', email: 'ahmed@clinic.com', isAvailable: true),
    const DoctorModel(id: 'd2', name: 'د. سارة المنصور', specialty: 'جلدية', phone: '+966-50-234-5678', email: 'sara@clinic.com', isAvailable: true),
    const DoctorModel(id: 'd3', name: 'د. خالد العتيبي', specialty: 'عظام', phone: '+966-50-345-6789', email: 'khalid@clinic.com', isAvailable: false),
    const DoctorModel(id: 'd4', name: 'د. نورة الحربي', specialty: 'أطفال', phone: '+966-50-456-7890', email: 'noura@clinic.com', isAvailable: true),
    const DoctorModel(id: 'd5', name: 'د. فيصل القحطاني', specialty: 'أعصاب', phone: '+966-50-567-8901', email: 'faisal@clinic.com', isAvailable: true),
  ];

  final List<PatientModel> _patients = [
    PatientModel(id: 'p1', name: 'محمد علي', age: 35, gender: Gender.male, phone: '+966-55-111-2222', email: 'mohammed@email.com', address: 'الرياض', bloodType: 'A+', registeredDate: DateTime(2024, 1, 15)),
    PatientModel(id: 'p2', name: 'فاطمة حسن', age: 28, gender: Gender.female, phone: '+966-55-222-3333', email: 'fatima@email.com', address: 'جدة', bloodType: 'B+', registeredDate: DateTime(2024, 2, 20)),
    PatientModel(id: 'p3', name: 'عمر عبدالله', age: 45, gender: Gender.male, phone: '+966-55-333-4444', email: 'omar@email.com', address: 'الدمام', bloodType: 'O+', registeredDate: DateTime(2024, 3, 10)),
    PatientModel(id: 'p4', name: 'عائشة خليل', age: 52, gender: Gender.female, phone: '+966-55-444-5555', email: 'aisha@email.com', address: 'مكة المكرمة', bloodType: 'AB+', registeredDate: DateTime(2024, 4, 5)),
    PatientModel(id: 'p5', name: 'يوسف إبراهيم', age: 12, gender: Gender.male, phone: '+966-55-555-6666', email: 'yusuf@email.com', address: 'المدينة المنورة', bloodType: 'A-', registeredDate: DateTime(2024, 5, 18)),
  ];

  final List<AppointmentModel> _appointments = [];
  final List<MedicalRecordModel> _medicalRecords = [];

  MockDataSource() {
    final now = DateTime.now();
    _appointments.addAll([
      AppointmentModel(id: 'a1', patientId: 'p1', patientName: 'محمد علي', doctorId: 'd1', doctorName: 'د. أحمد الرشيد', date: DateTime(now.year, now.month, now.day, 9, 0), timeSlot: '09:00 - 09:30', status: AppointmentStatus.scheduled, notes: 'كشف دوري'),
      AppointmentModel(id: 'a2', patientId: 'p2', patientName: 'فاطمة حسن', doctorId: 'd2', doctorName: 'د. سارة المنصور', date: DateTime(now.year, now.month, now.day, 10, 0), timeSlot: '10:00 - 10:30', status: AppointmentStatus.inProgress),
      AppointmentModel(id: 'a3', patientId: 'p3', patientName: 'عمر عبدالله', doctorId: 'd3', doctorName: 'د. خالد العتيبي', date: DateTime(now.year, now.month, now.day + 1, 11, 0), timeSlot: '11:00 - 11:30', status: AppointmentStatus.scheduled, notes: 'متابعة'),
      AppointmentModel(id: 'a4', patientId: 'p4', patientName: 'عائشة خليل', doctorId: 'd4', doctorName: 'د. نورة الحربي', date: DateTime(now.year, now.month, now.day - 1, 14, 0), timeSlot: '02:00 - 02:30', status: AppointmentStatus.completed, notes: 'تم العلاج'),
      AppointmentModel(id: 'a5', patientId: 'p5', patientName: 'يوسف إبراهيم', doctorId: 'd4', doctorName: 'د. نورة الحربي', date: DateTime(now.year, now.month, now.day + 2, 15, 0), timeSlot: '03:00 - 03:30', status: AppointmentStatus.scheduled, notes: 'تطعيم'),
      AppointmentModel(id: 'a6', patientId: 'p1', patientName: 'محمد علي', doctorId: 'd5', doctorName: 'د. فيصل القحطاني', date: DateTime(now.year, now.month, now.day - 2, 16, 0), timeSlot: '04:00 - 04:30', status: AppointmentStatus.cancelled, notes: 'إلغاء من المريض'),
    ]);
    _medicalRecords.addAll([
      MedicalRecordModel(id: 'mr1', patientId: 'p1', patientName: 'محمد علي', doctorId: 'd1', doctorName: 'د. أحمد الرشيد', visitDate: DateTime(2024, 6, 15), diagnosis: 'ارتفاع ضغط الدم', prescription: 'أملوديبين 5مغ - مرة يومياً', notes: 'مراقبة الضغط أسبوعياً'),
      MedicalRecordModel(id: 'mr2', patientId: 'p2', patientName: 'فاطمة حسن', doctorId: 'd2', doctorName: 'د. سارة المنصور', visitDate: DateTime(2024, 7, 20), diagnosis: 'حساسية جلدية', prescription: 'كريم مضاد للهيستامين - مرتين يومياً', notes: 'تجنب التعرض للشمس'),
      MedicalRecordModel(id: 'mr3', patientId: 'p3', patientName: 'عمر عبدالله', doctorId: 'd3', doctorName: 'د. خالد العتيبي', visitDate: DateTime(2024, 8, 10), diagnosis: 'آلام مفصل الركبة', prescription: 'إيبوبروفين 400مغ - عند الحاجة', notes: 'ينصح بالعلاج الطبيعي'),
      MedicalRecordModel(id: 'mr4', patientId: 'p4', patientName: 'عائشة خليل', doctorId: 'd4', doctorName: 'د. نورة الحربي', visitDate: DateTime(2024, 9, 5), diagnosis: 'السكري من النوع 2', prescription: 'ميتفورمين 500مغ - مرتين يومياً', notes: 'تم توفير خطة غذائية، متابعة بعد 3 أشهر'),
      MedicalRecordModel(id: 'mr5', patientId: 'p5', patientName: 'يوسف إبراهيم', doctorId: 'd4', doctorName: 'د. نورة الحربي', visitDate: DateTime(2024, 10, 18), diagnosis: 'نزلة برد', prescription: 'شراب فيتامين سي - 5مل يومياً'),
    ]);
  }

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
  List<DoctorModel> searchDoctors(String query) =>
      _doctors.where((d) => d.name.contains(query) || d.specialty.contains(query)).toList();

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
  List<PatientModel> searchPatients(String query) =>
      _patients.where((p) => p.name.contains(query)).toList();

  @override
  void addAppointment(AppointmentModel appointment) => _appointments.add(appointment);
  @override
  void addMedicalRecord(MedicalRecordModel record) => _medicalRecords.add(record);
  @override
  void updateAppointment(AppointmentModel appointment) {
    final i = _appointments.indexWhere((a) => a.id == appointment.id);
    if (i != -1) _appointments[i] = appointment;
  }
  @override
  void deleteAppointment(String id) => _appointments.removeWhere((a) => a.id == id);
  @override
  List<AppointmentModel> appointmentsByDate(DateTime date) =>
      _appointments.where((a) =>
          a.date.year == date.year && a.date.month == date.month && a.date.day == date.day).toList();
  @override
  List<AppointmentModel> appointmentsByPatient(String patientId) =>
      _appointments.where((a) => a.patientId == patientId).toList();
  @override
  int get todayAppointmentCount {
    final now = DateTime.now();
    return _appointments.where((a) =>
        a.date.year == now.year && a.date.month == now.month && a.date.day == now.day).length;
  }

  @override
  List<CountryModel> get allCountries => List.unmodifiable(_countries);

  @override
  List<CityModel> get allCities => List.unmodifiable(_cities);

  @override
  List<CityModel> citiesByCountry(String countryId) =>
      _cities.where((c) => c.countryId == countryId).toList();

  @override
  List<CityModel> searchCities(String query, {String? countryId}) {
    var result = _cities.where((c) =>
        c.name.toLowerCase().contains(query.toLowerCase()) ||
        c.nameAr.contains(query));
    if (countryId != null) {
      result = result.where((c) => c.countryId == countryId);
    }
    return result.toList();
  }
}
