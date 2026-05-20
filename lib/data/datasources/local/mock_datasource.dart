import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/data/models/appointment_model.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class MockDataSource {
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

  List<DoctorModel> get allDoctors => List.unmodifiable(_doctors);
  List<PatientModel> get allPatients => List.unmodifiable(_patients);
  List<AppointmentModel> get allAppointments => List.unmodifiable(_appointments);
  List<MedicalRecordModel> get allMedicalRecords => List.unmodifiable(_medicalRecords);

  DoctorModel? doctorById(String id) {
    try { return _doctors.firstWhere((d) => d.id == id); } catch (_) { return null; }
  }

  PatientModel? patientById(String id) {
    try { return _patients.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }

  void addDoctor(DoctorModel doctor) => _doctors.add(doctor);
  void updateDoctor(DoctorModel doctor) {
    final i = _doctors.indexWhere((d) => d.id == doctor.id);
    if (i != -1) _doctors[i] = doctor;
  }
  void deleteDoctor(String id) => _doctors.removeWhere((d) => d.id == id);
  List<DoctorModel> searchDoctors(String query) =>
      _doctors.where((d) => d.name.contains(query) || d.specialty.contains(query)).toList();

  void addPatient(PatientModel patient) => _patients.add(patient);
  void updatePatient(PatientModel patient) {
    final i = _patients.indexWhere((p) => p.id == patient.id);
    if (i != -1) _patients[i] = patient;
  }
  void deletePatient(String id) => _patients.removeWhere((p) => p.id == id);
  List<PatientModel> searchPatients(String query) =>
      _patients.where((p) => p.name.contains(query)).toList();

  void addAppointment(AppointmentModel appointment) => _appointments.add(appointment);
  void addMedicalRecord(MedicalRecordModel record) => _medicalRecords.add(record);
  void updateAppointment(AppointmentModel appointment) {
    final i = _appointments.indexWhere((a) => a.id == appointment.id);
    if (i != -1) _appointments[i] = appointment;
  }
  void deleteAppointment(String id) => _appointments.removeWhere((a) => a.id == id);
  List<AppointmentModel> appointmentsByDate(DateTime date) =>
      _appointments.where((a) =>
          a.date.year == date.year && a.date.month == date.month && a.date.day == date.day).toList();
  List<AppointmentModel> appointmentsByPatient(String patientId) =>
      _appointments.where((a) => a.patientId == patientId).toList();
  int get todayAppointmentCount {
    final now = DateTime.now();
    return _appointments.where((a) =>
        a.date.year == now.year && a.date.month == now.month && a.date.day == now.day).length;
  }
}
