import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/review_model.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DataSource dataSource;

  DoctorRepositoryImpl(this.dataSource);

  @override
  Future<List<DoctorEntity>> getAllDoctors() async => dataSource.allDoctors;

  @override
  Future<DoctorEntity?> getDoctorById(String id) async => dataSource.doctorById(id);

  @override
  Future<void> addDoctor(DoctorEntity doctor) async {
    dataSource.addDoctor(DoctorModel(
      id: doctor.id, firstName: doctor.firstName, lastName: doctor.lastName,
      username: doctor.username, email: doctor.email,
      phone: doctor.phone, address: doctor.address,
      gender: doctor.gender, birthdayDate: doctor.birthdayDate,
      isActive: doctor.isActive, imageUrl: doctor.imageUrl,
      roles: doctor.roles,
    ));
  }

  @override
  Future<void> updateDoctor(DoctorEntity doctor) async {
    dataSource.updateDoctor(DoctorModel(
      id: doctor.id, firstName: doctor.firstName, lastName: doctor.lastName,
      username: doctor.username, email: doctor.email,
      phone: doctor.phone, address: doctor.address,
      gender: doctor.gender, birthdayDate: doctor.birthdayDate,
      isActive: doctor.isActive, imageUrl: doctor.imageUrl,
      roles: doctor.roles,
    ));
  }

  @override
  Future<void> deleteDoctor(String id) async => dataSource.deleteDoctor(id);

  @override
  Future<List<DoctorEntity>> searchDoctors(String query) async => dataSource.searchDoctors(query);

  @override
  Future<DoctorProfileEntity> getDoctorProfile(String id) async {
    final doctor = dataSource.doctorById(id);
    if (doctor == null) throw Exception('الطبيب غير موجود');
    final reviews = dataSource.getDoctorReviews(id);
    final now = DateTime.now();
    final slots = dataSource.getDoctorSlots(id, DateTime(now.year, now.month));
    return DoctorProfileEntity(doctor: doctor, reviews: reviews, availableSlots: slots);
  }

  @override
  Future<List<ReviewEntity>> getDoctorReviews(String doctorId) async =>
      dataSource.getDoctorReviews(doctorId);

  @override
  Future<List<DoctorScheduleEntity>> getDoctorSlots(String doctorId, DateTime month) async =>
      dataSource.getDoctorSlots(doctorId, month);

  @override
  Future<void> toggleSlotAvailability(String slotId) async =>
      dataSource.toggleSlotAvailability(slotId);

  @override
  Future<void> addReview(String doctorId, ReviewEntity review) async {
    dataSource.addReview(doctorId, ReviewModel(
      id: review.id, rating: review.rating, comment: review.comment,
      rater: review.rater, type: review.type,
      rateableId: review.rateableId, rateableType: review.rateableType,
      createdAt: review.createdAt, updatedAt: review.updatedAt,
    ));
  }
}
