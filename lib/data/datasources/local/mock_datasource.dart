import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';
import 'package:clinic_management_app/data/models/review_model.dart';
import 'package:clinic_management_app/data/models/time_slot_model.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class MockDataSource implements DataSource {
  final List<CountryModel> _countries = [
      const CountryModel(id: 'sy', nameEn: 'Syria', nameAr: 'سُورِيَا', code: 'SY', flag: '🇸🇾'),
    const CountryModel(id: 'eg', nameEn: 'Egypt', nameAr: 'مِصْرُ', code: 'EG', flag: '🇪🇬'),
    const CountryModel(id: 'sa', nameEn: 'Saudi Arabia', nameAr: 'السُّعُودِيَّةُ', code: 'SA', flag: '🇸🇦'),
    const CountryModel(id: 'ae', nameEn: 'UAE', nameAr: 'الإِمَارَاتُ', code: 'AE', flag: '🇦🇪'),
    const CountryModel(id: 'qa', nameEn: 'Qatar', nameAr: 'قَطَرُ', code: 'QA', flag: '🇶🇦'),
    const CountryModel(id: 'kw', nameEn: 'Kuwait', nameAr: 'الكُوَيْتُ', code: 'KW', flag: '🇰🇼'),
    const CountryModel(id: 'jo', nameEn: 'Jordan', nameAr: 'الأُرْدُنُّ', code: 'JO', flag: '🇯🇴'),
    const CountryModel(id: 'lb', nameEn: 'Lebanon', nameAr: 'لُبْنَانُ', code: 'LB', flag: '🇱🇧'),
    const CountryModel(id: 'ps', nameEn: 'Palestine', nameAr: 'فِلَسْطِينُ', code: 'PS', flag: '🇵🇸'),
    const CountryModel(id: 'iq', nameEn: 'Iraq', nameAr: 'العِرَاقُ', code: 'IQ', flag: '🇮🇷'),
    const CountryModel(id: 'ye', nameEn: 'Yemen', nameAr: 'اليَمَنُ', code: 'YE', flag: '🇾🇪'),
    const CountryModel(id: 'ly', nameEn: 'Libya', nameAr: 'لِيبِيَا', code: 'LY', flag: '🇱🇾'),
    const CountryModel(id: 'tn', nameEn: 'Tunisia', nameAr: 'تُونِسُ', code: 'TN', flag: '🇹🇳'),
    const CountryModel(id: 'dz', nameEn: 'Algeria', nameAr: 'الجَزَائِرُ', code: 'DZ', flag: '🇩🇿'),
    const CountryModel(id: 'ma', nameEn: 'Morocco', nameAr: 'المَغْرِبُ', code: 'MA', flag: '🇲🇦'),
    const CountryModel(id: 'sd', nameEn: 'Sudan', nameAr: 'السُّودَانُ', code: 'SD', flag: '🇸🇩'),
    const CountryModel(id: 'om', nameEn: 'Oman', nameAr: 'عُمَانُ', code: 'OM', flag: '🇴🇲'),
    const CountryModel(id: 'bh', nameEn: 'Bahrain', nameAr: 'البَحْرَيْنُ', code: 'BH', flag: '🇧🇭'),
    const CountryModel(id: 'us', nameEn: 'United States', nameAr: 'الوِلَايَاتُ المُتَّحِدَةُ', code: 'US', flag: '🇺🇸'),
    const CountryModel(id: 'gb', nameEn: 'United Kingdom', nameAr: 'المَمْلَكَةُ المُتَّحِدَةُ', code: 'GB', flag: '🇬🇧'),
    const CountryModel(id: 'fr', nameEn: 'France', nameAr: 'فَرَنْسَا', code: 'FR', flag: '🇫🇷'),
    const CountryModel(id: 'de', nameEn: 'Germany', nameAr: 'أَلْمَانِيَا', code: 'DE', flag: '🇩🇪'),
  ];

  final List<CityModel> _cities = [
    const CityModel(id: 'sy-1', nameEn: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    const CityModel(id: 'sy-2', nameEn: 'Aleppo', nameAr: 'حَلَبُ', countryId: 'sy'),
    const CityModel(id: 'sy-3', nameEn: 'Homs', nameAr: 'حِمْصُ', countryId: 'sy'),
    const CityModel(id: 'sy-4', nameEn: 'Latakia', nameAr: 'اللَّاذِقِيَّةُ', countryId: 'sy'),
    const CityModel(id: 'eg-1', nameEn: 'Cairo', nameAr: 'القَاهِرَةُ', countryId: 'eg'),
    const CityModel(id: 'eg-2', nameEn: 'Alexandria', nameAr: 'الإِسْكَنْدَرِيَّةُ', countryId: 'eg'),
    const CityModel(id: 'eg-3', nameEn: 'Giza', nameAr: 'الجِيزَةُ', countryId: 'eg'),
    const CityModel(id: 'sa-1', nameEn: 'Riyadh', nameAr: 'الرِّيَاضُ', countryId: 'sa'),
    const CityModel(id: 'sa-2', nameEn: 'Jeddah', nameAr: 'جِدَّةُ', countryId: 'sa'),
    const CityModel(id: 'sa-3', nameEn: 'Mecca', nameAr: 'مَكَّةُ المُكَرَّمَةُ', countryId: 'sa'),
    const CityModel(id: 'sa-4', nameEn: 'Medina', nameAr: 'المَدِينَةُ المُنَوَّرَةُ', countryId: 'sa'),
    const CityModel(id: 'sa-5', nameEn: 'Dammam', nameAr: 'الدَّمَّامُ', countryId: 'sa'),
    const CityModel(id: 'ae-1', nameEn: 'Dubai', nameAr: 'دُبَيٌّ', countryId: 'ae'),
    const CityModel(id: 'ae-2', nameEn: 'Abu Dhabi', nameAr: 'أَبُو ظَبْيٍ', countryId: 'ae'),
    const CityModel(id: 'ae-3', nameEn: 'Sharjah', nameAr: 'الشَّارِقَةُ', countryId: 'ae'),
    const CityModel(id: 'qa-1', nameEn: 'Doha', nameAr: 'الدَّوْحَةُ', countryId: 'qa'),
    const CityModel(id: 'kw-1', nameEn: 'Kuwait City', nameAr: 'مَدِينَةُ الكُوَيْتِ', countryId: 'kw'),
    const CityModel(id: 'jo-1', nameEn: 'Amman', nameAr: 'عَمَّانُ', countryId: 'jo'),
    const CityModel(id: 'jo-2', nameEn: 'Irbid', nameAr: 'إِرْبِدُ', countryId: 'jo'),
    const CityModel(id: 'lb-1', nameEn: 'Beirut', nameAr: 'بَيْرُوتُ', countryId: 'lb'),
    const CityModel(id: 'lb-2', nameEn: 'Tripoli', nameAr: 'طَرَابُلُسُ', countryId: 'lb'),
    const CityModel(id: 'ps-1', nameEn: 'Jerusalem', nameAr: 'القُدْسُ', countryId: 'ps'),
    const CityModel(id: 'ps-2', nameEn: 'Ramallah', nameAr: 'رَامُ اللَّهِ', countryId: 'ps'),
    const CityModel(id: 'ps-3', nameEn: 'Gaza', nameAr: 'غَزَّةُ', countryId: 'ps'),
    const CityModel(id: 'iq-1', nameEn: 'Baghdad', nameAr: 'بَغْدَادُ', countryId: 'iq'),
    const CityModel(id: 'iq-2', nameEn: 'Basra', nameAr: 'البَصْرَةُ', countryId: 'iq'),
    const CityModel(id: 'iq-3', nameEn: 'Erbil', nameAr: 'أَرْبِيلُ', countryId: 'iq'),
    const CityModel(id: 'tn-1', nameEn: 'Tunis', nameAr: 'تُونِسُ', countryId: 'tn'),
    const CityModel(id: 'dz-1', nameEn: 'Algiers', nameAr: 'الجَزَائِرُ', countryId: 'dz'),
    const CityModel(id: 'ma-1', nameEn: 'Rabat', nameAr: 'الرِّبَاطُ', countryId: 'ma'),
    const CityModel(id: 'ma-2', nameEn: 'Casablanca', nameAr: 'الدَّارُ البَيْضَاءُ', countryId: 'ma'),
    const CityModel(id: 'us-1', nameEn: 'New York', nameAr: 'نِيُويُورْكُ', countryId: 'us'),
    const CityModel(id: 'us-2', nameEn: 'Washington DC', nameAr: 'وَاشِنْطُنُ', countryId: 'us'),
    const CityModel(id: 'gb-1', nameEn: 'London', nameAr: 'لَنْدَنُ', countryId: 'gb'),
    const CityModel(id: 'fr-1', nameEn: 'Paris', nameAr: 'بَارِيسُ', countryId: 'fr'),
    const CityModel(id: 'de-1', nameEn: 'Berlin', nameAr: 'بَرْلِينُ', countryId: 'de'),
  ];

  final List<DoctorModel> _doctors = [
    DoctorModel(
      id: 'd1', name: 'د. أحمد الرشيد', specialty: 'استشاري أمراض القلب والأوعية الدموية',
      phone: '+966-50-123-4567', email: 'ahmed@clinic.com',
      isAvailable: true, experienceYears: 15, rating: 4.9,
      reviewsCount: 248, patientsCount: 5230, surgeriesCount: 850,
      bio: 'يتمتع الدكتور أحمد الرشيد بخبرة تزيد عن 15 عاماً في مجال طب القلب التداخلي. يجمع بين الخبرة السريرية الواسعة وأحدث التقنيات الطبية لضمان أفضل نتائج التعافي لمرضاه.',
      qualifications: ['دكتوراه في جراحة القلب - جامعة القاهرة', 'زمالة الكلية الملكية للجراحين - لندن', 'البورد الأمريكي في أمراض القلب'],
      services: ['استشارات القلب', 'تخطيط القلب (ECG)', 'الموجات فوق الصوتية للقلب', 'القسطرة القلبية'],
      education: 'دكتوراه في جراحة القلب - جامعة القاهرة',
      clinicName: 'مركز الرياض للتميز الطبي', clinicAddress: 'طريق الملك فهد، الرياض',
      consultationFee: 300, languages: ['العربية', 'الإنجليزية'],
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDGziAiGni5H4sYvlMH_algaAEEphNQZzi8xRG7raEm71flKtfQDOLwQVnL4Cen59jcpuKnNJz5yACkI6gxD1EpTu68B8Xx50u576Rx8rXh1YGZBUK-cDFuPu1iIn0ebNu4Eapxayv7mZKf2MSZPCYfJE87-IpdPa1_RV7gqWbRbvoszeGDaMwtTld_T2K6Kgd5VLhZsbaY8rAx-rbKOT1msiVYsen9SE87H3Ahxs2RbJkML9ciKTaftVOKkz6eadEOI26yb2iDTHE',
    ),
    DoctorModel(
      id: 'd2', name: 'د. سارة المنصور', specialty: 'استشارية الأمراض الجلدية والتجميل',
      phone: '+966-50-234-5678', email: 'sara@clinic.com',
      isAvailable: true, experienceYears: 12, rating: 4.8,
      reviewsCount: 185, patientsCount: 3410, surgeriesCount: 520,
      bio: 'متخصصة في علاج الأمراض الجلدية وجراحات التجميل بأحدث التقنيات.',
      qualifications: ['بورد في الأمراض الجلدية', 'زمالة جراحة التجميل - ألمانيا'],
      services: ['علاج حب الشباب', 'إزالة الندبات', 'الليزر التجميلي', 'البوتوكس والفيلر'],
      clinicName: 'مجمع العيادات التخصصي', clinicAddress: 'جدة',
      consultationFee: 250, languages: ['العربية', 'الإنجليزية'],
    ),
    DoctorModel(
      id: 'd3', name: 'د. خالد العتيبي', specialty: 'استشاري جراحة العظام والمفاصل',
      phone: '+966-50-345-6789', email: 'khalid@clinic.com',
      isAvailable: false, experienceYears: 18, rating: 4.7,
      reviewsCount: 320, patientsCount: 6800, surgeriesCount: 1200,
      bio: 'أخصائي جراحة العظام مع خبرة واسعة في عمليات استبدال المفاصل وإصابات الملاعب.',
      qualifications: ['زمالة جراحة العظام - كندا', 'ماجستير جراحة المفاصل - بريطانيا'],
      services: ['استبدال مفصل الركبة', 'منظار المفصل', 'علاج إصابات الملاعب', 'جراحة العمود الفقري'],
      clinicName: 'مستشفى الرعاية العامة', clinicAddress: 'الخبر',
      consultationFee: 350, languages: ['العربية', 'الإنجليزية'],
    ),
    DoctorModel(
      id: 'd4', name: 'د. نورة الحربي', specialty: 'استشارية طب الأطفال وحديثي الولادة',
      phone: '+966-50-456-7890', email: 'noura@clinic.com',
      isAvailable: true, experienceYears: 10, rating: 4.9,
      reviewsCount: 410, patientsCount: 4200, surgeriesCount: 300,
      bio: 'رعاية متكاملة للأطفال منذ الولادة حتى سن المراهقة بأحدث الأساليب الطبية.',
      qualifications: ['البورد السعودي لطب الأطفال', 'زمالة حديثي الولادة - أمريكا'],
      services: ['فحص الأطفال الشامل', 'متابعة النمو', 'التطعيمات', 'علاج الحساسية والربو'],
      clinicName: 'عيادات الأمومة والطفولة', clinicAddress: 'الرياض',
      consultationFee: 200, languages: ['العربية', 'الإنجليزية'],
    ),
    DoctorModel(
      id: 'd5', name: 'د. فيصل القحطاني', specialty: 'استشاري جراحة المخ والأعصاب',
      phone: '+966-50-567-8901', email: 'faisal@clinic.com',
      isAvailable: true, experienceYears: 20, rating: 4.9,
      reviewsCount: 560, patientsCount: 7800, surgeriesCount: 2100,
      bio: 'متخصص في جراحات المخ والأعصاب الدقيقة مع أكثر من 2000 عملية ناجحة.',
      qualifications: ['زمالة جراحة الأعصاب - ألمانيا', 'البورد الأوروبي لجراحة المخ'],
      services: ['جراحة أورام المخ', 'جراحة العمود الفقري', 'علاج الصرع', 'جراحة الأعصاب الطرفية'],
      clinicName: 'مركز الرياض للتميز الطبي', clinicAddress: 'طريق الملك فهد، الرياض',
      consultationFee: 400, languages: ['العربية', 'الإنجليزية', 'الألمانية'],
    ),
  ];

  final List<PatientModel> _patients = [
    PatientModel(id: 'p1', name: 'محمد علي', age: 35, gender: Gender.male, phone: '+966-55-111-2222', email: 'mohammed@email.com', address: 'الرياض', bloodType: 'A+', registeredDate: DateTime(2024, 1, 15)),
    PatientModel(id: 'p2', name: 'فاطمة حسن', age: 28, gender: Gender.female, phone: '+966-55-222-3333', email: 'fatima@email.com', address: 'جدة', bloodType: 'B+', registeredDate: DateTime(2024, 2, 20)),
    PatientModel(id: 'p3', name: 'عمر عبدالله', age: 45, gender: Gender.male, phone: '+966-55-333-4444', email: 'omar@email.com', address: 'الدمام', bloodType: 'O+', registeredDate: DateTime(2024, 3, 10)),
    PatientModel(id: 'p4', name: 'عائشة خليل', age: 52, gender: Gender.female, phone: '+966-55-444-5555', email: 'aisha@email.com', address: 'مكة المكرمة', bloodType: 'AB+', registeredDate: DateTime(2024, 4, 5)),
    PatientModel(id: 'p5', name: 'يوسف إبراهيم', age: 12, gender: Gender.male, phone: '+966-55-555-6666', email: 'yusuf@email.com', address: 'المدينة المنورة', bloodType: 'A-', registeredDate: DateTime(2024, 5, 18)),
  ];

  final List<ReviewModel> _reviews = [
    ReviewModel(id: 'r1', patientName: 'أحمد السعدني', patientImage: null, rating: 5.0, comment: 'طبيب ممتاز جداً، شرح لي حالتي بكل تفصيل وكان صبوراً جداً.', date: DateTime.now().subtract(const Duration(days: 2)), likesCount: 24),
    ReviewModel(id: 'r2', patientName: 'سارة العامري', patientImage: null, rating: 5.0, comment: 'تجربة ممتازة جداً! الفريق الطبي محترف للغاية والتعامل راقي.', date: DateTime.now().subtract(const Duration(days: 7)), likesCount: 18),
    ReviewModel(id: 'r3', patientName: 'فيصل الحربي', patientImage: null, rating: 4.0, comment: 'برنامج ممتاز وموثوق. أنصح به الجميع.', date: DateTime.now().subtract(const Duration(days: 14)), likesCount: 12),
    ReviewModel(id: 'r4', patientName: 'ليلى حسن', patientImage: null, rating: 5.0, comment: 'أفضل طبيب تعاملت معه على الإطلاق.', date: DateTime.now().subtract(const Duration(days: 21)), likesCount: 30),
  ];

  final List<TimeSlotModel> _timeSlots = [];

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

    for (final doctor in _doctors) {
      final times = ['09:00', '09:30', '10:00', '10:30', '11:00', '14:00', '14:30', '15:00', '15:30', '16:00'];
      for (int d = 0; d < 7; d++) {
        for (final time in times) {
          _timeSlots.add(TimeSlotModel(
            id: '${doctor.id}_${now.day + d}_${time.replaceAll(':', '')}',
            date: DateTime(now.year, now.month, now.day + d),
            time: time,
            isAvailable: d > 0 || d == 0 && !time.contains('09'),
          ));
        }
      }
    }
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
        c.nameEn.toLowerCase().contains(query.toLowerCase()) || c.nameAr.contains(query));
    if (countryId != null) {
      result = result.where((c) => c.countryId == countryId);
    }
    return result.toList();
  }

  @override
  List<ReviewModel> getDoctorReviews(String doctorId) => List.unmodifiable(_reviews);

  @override
  List<TimeSlotModel> getDoctorSlots(String doctorId, DateTime month) =>
      _timeSlots.where((s) => s.id.startsWith('${doctorId}_')).toList();

  @override
  void addReview(String doctorId, ReviewModel review) => _reviews.add(review);

  @override
  void toggleSlotAvailability(String slotId) {
    final i = _timeSlots.indexWhere((s) => s.id == slotId);
    if (i != -1) {
      _timeSlots[i] = TimeSlotModel(
        id: _timeSlots[i].id,
        date: _timeSlots[i].date,
        time: _timeSlots[i].time,
        isAvailable: !_timeSlots[i].isAvailable,
      );
    }
  }
}
