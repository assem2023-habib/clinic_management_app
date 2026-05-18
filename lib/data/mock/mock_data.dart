import 'package:clinic_management_app/data/models/appointment.dart';
import 'package:clinic_management_app/data/models/doctor.dart';
import 'package:clinic_management_app/data/models/medical_record.dart';
import 'package:clinic_management_app/data/models/patient.dart';

class MockData {
  static List<Doctor> get doctors => [
        const Doctor(id: 'd1', name: 'Dr. Ahmed Al-Rashid', specialty: 'Cardiology', phone: '+966-50-123-4567', email: 'ahmed@clinic.com', isAvailable: true),
        const Doctor(id: 'd2', name: 'Dr. Sara Al-Mansour', specialty: 'Dermatology', phone: '+966-50-234-5678', email: 'sara@clinic.com', isAvailable: true),
        const Doctor(id: 'd3', name: 'Dr. Khalid Al-Otaibi', specialty: 'Orthopedics', phone: '+966-50-345-6789', email: 'khalid@clinic.com', isAvailable: false),
        const Doctor(id: 'd4', name: 'Dr. Noura Al-Harbi', specialty: 'Pediatrics', phone: '+966-50-456-7890', email: 'noura@clinic.com', isAvailable: true),
        const Doctor(id: 'd5', name: 'Dr. Faisal Al-Qahtani', specialty: 'Neurology', phone: '+966-50-567-8901', email: 'faisal@clinic.com', isAvailable: true),
      ];

  static List<Patient> get patients => [
        Patient(id: 'p1', name: 'Mohammed Ali', age: 35, gender: Gender.male, phone: '+966-55-111-2222', email: 'mohammed@email.com', address: 'Riyadh, Saudi Arabia', bloodType: 'A+', registeredDate: DateTime(2024, 1, 15)),
        Patient(id: 'p2', name: 'Fatima Hassan', age: 28, gender: Gender.female, phone: '+966-55-222-3333', email: 'fatima@email.com', address: 'Jeddah, Saudi Arabia', bloodType: 'B+', registeredDate: DateTime(2024, 2, 20)),
        Patient(id: 'p3', name: 'Omar Abdullah', age: 45, gender: Gender.male, phone: '+966-55-333-4444', email: 'omar@email.com', address: 'Dammam, Saudi Arabia', bloodType: 'O+', registeredDate: DateTime(2024, 3, 10)),
        Patient(id: 'p4', name: 'Aisha Khalil', age: 52, gender: Gender.female, phone: '+966-55-444-5555', email: 'aisha@email.com', address: 'Mecca, Saudi Arabia', bloodType: 'AB+', registeredDate: DateTime(2024, 4, 5)),
        Patient(id: 'p5', name: 'Yusuf Ibrahim', age: 12, gender: Gender.male, phone: '+966-55-555-6666', email: 'yusuf@email.com', address: 'Medina, Saudi Arabia', bloodType: 'A-', registeredDate: DateTime(2024, 5, 18)),
      ];

  static List<Appointment> get appointments {
    final now = DateTime.now();
    return [
      Appointment(id: 'a1', patientId: 'p1', patientName: 'Mohammed Ali', doctorId: 'd1', doctorName: 'Dr. Ahmed Al-Rashid', date: DateTime(now.year, now.month, now.day, 9, 0), timeSlot: '09:00 AM - 09:30 AM', status: AppointmentStatus.scheduled, notes: 'Regular checkup'),
      Appointment(id: 'a2', patientId: 'p2', patientName: 'Fatima Hassan', doctorId: 'd2', doctorName: 'Dr. Sara Al-Mansour', date: DateTime(now.year, now.month, now.day, 10, 0), timeSlot: '10:00 AM - 10:30 AM', status: AppointmentStatus.inProgress),
      Appointment(id: 'a3', patientId: 'p3', patientName: 'Omar Abdullah', doctorId: 'd3', doctorName: 'Dr. Khalid Al-Otaibi', date: DateTime(now.year, now.month, now.day + 1, 11, 0), timeSlot: '11:00 AM - 11:30 AM', status: AppointmentStatus.scheduled, notes: 'Follow-up visit'),
      Appointment(id: 'a4', patientId: 'p4', patientName: 'Aisha Khalil', doctorId: 'd4', doctorName: 'Dr. Noura Al-Harbi', date: DateTime(now.year, now.month, now.day - 1, 14, 0), timeSlot: '02:00 PM - 02:30 PM', status: AppointmentStatus.completed, notes: 'Treatment completed'),
      Appointment(id: 'a5', patientId: 'p5', patientName: 'Yusuf Ibrahim', doctorId: 'd4', doctorName: 'Dr. Noura Al-Harbi', date: DateTime(now.year, now.month, now.day + 2, 15, 0), timeSlot: '03:00 PM - 03:30 PM', status: AppointmentStatus.scheduled, notes: 'Vaccination'),
      Appointment(id: 'a6', patientId: 'p1', patientName: 'Mohammed Ali', doctorId: 'd5', doctorName: 'Dr. Faisal Al-Qahtani', date: DateTime(now.year, now.month, now.day - 2, 16, 0), timeSlot: '04:00 PM - 04:30 PM', status: AppointmentStatus.cancelled, notes: 'Patient cancelled'),
    ];
  }

  static List<MedicalRecord> get medicalRecords => [
        MedicalRecord(id: 'mr1', patientId: 'p1', patientName: 'Mohammed Ali', doctorId: 'd1', doctorName: 'Dr. Ahmed Al-Rashid', visitDate: DateTime(2024, 6, 15), diagnosis: 'High Blood Pressure', prescription: 'Amlodipine 5mg - once daily', notes: 'Monitor blood pressure weekly'),
        MedicalRecord(id: 'mr2', patientId: 'p2', patientName: 'Fatima Hassan', doctorId: 'd2', doctorName: 'Dr. Sara Al-Mansour', visitDate: DateTime(2024, 7, 20), diagnosis: 'Skin Allergy', prescription: 'Antihistamine cream - apply twice daily', notes: 'Avoid sun exposure'),
        MedicalRecord(id: 'mr3', patientId: 'p3', patientName: 'Omar Abdullah', doctorId: 'd3', doctorName: 'Dr. Khalid Al-Otaibi', visitDate: DateTime(2024, 8, 10), diagnosis: 'Knee Joint Pain', prescription: 'Ibuprofen 400mg - as needed', notes: 'Physical therapy recommended'),
        MedicalRecord(id: 'mr4', patientId: 'p4', patientName: 'Aisha Khalil', doctorId: 'd4', doctorName: 'Dr. Noura Al-Harbi', visitDate: DateTime(2024, 9, 5), diagnosis: 'Diabetes Type 2', prescription: 'Metformin 500mg - twice daily', notes: 'Diet plan provided, follow up in 3 months'),
        MedicalRecord(id: 'mr5', patientId: 'p5', patientName: 'Yusuf Ibrahim', doctorId: 'd4', doctorName: 'Dr. Noura Al-Harbi', visitDate: DateTime(2024, 10, 18), diagnosis: 'Common Cold', prescription: 'Vitamin C syrup - 5ml daily'),
      ];
}
