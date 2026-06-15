import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';

abstract class DoctorRepository {
  Future<List<DoctorEntity>> getAllDoctors({String? search, String? specializationId});
  Future<DoctorEntity?> getDoctorById(String id);
  Future<void> addDoctor(DoctorEntity doctor);
  Future<void> updateDoctor(DoctorEntity doctor);
  Future<void> deleteDoctor(String id);
  Future<List<DoctorEntity>> searchDoctors(String query);
  Future<bool> activateAccount(String id);

  Future<DoctorProfileEntity> getDoctorProfile(String id);
  Future<List<ReviewEntity>> getDoctorReviews(String doctorId);
  Future<List<DoctorScheduleEntity>> getDoctorSlots(String doctorId, DateTime month);
  Future<void> toggleSlotAvailability(String slotId);
  Future<void> addReview(String doctorId, ReviewEntity review);
  Future<List<DoctorEntity>> getDoctorsWithAppointments({required String patientId});
}
