import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/datasources/remote/doctor_remote_datasource.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/data/models/review_model.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';
import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DataSource dataSource;
  final DoctorRemoteDataSource? remoteDataSource;

  DoctorRepositoryImpl(this.dataSource, {this.remoteDataSource});

  @override
  Future<List<DoctorEntity>> getAllDoctors({String? search, String? specializationId}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getDoctors(search: search, specializationId: specializationId);
      } catch (_) {}
    }
    if (search != null && search.isNotEmpty) {
      return dataSource.searchDoctors(search);
    }
    return dataSource.allDoctors;
  }

  @override
  Future<DoctorEntity?> getDoctorById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getDoctorById(id);
      } catch (_) {}
    }
    return dataSource.doctorById(id);
  }

  @override
  Future<void> addDoctor(DoctorEntity doctor) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.createDoctor({
          'first_name': doctor.firstName, 'last_name': doctor.lastName,
          'username': doctor.username, 'email': doctor.email,
          'phone': doctor.phone, 'address': doctor.address,
          'gender': doctor.gender, 'birthday_date': doctor.birthdayDate,
          if (doctor.specialization != null) 'specialization_id': doctor.specialization!.id,
          if (doctor.experienceMonths != null) 'experience_months': doctor.experienceMonths,
        });
        return;
      } catch (_) {}
    }
    dataSource.addDoctor(DoctorModel(
      id: doctor.id, firstName: doctor.firstName, lastName: doctor.lastName,
      username: doctor.username, email: doctor.email,
      phone: doctor.phone, address: doctor.address,
      gender: doctor.gender, birthdayDate: doctor.birthdayDate,
      isActive: doctor.isActive, imageUrl: doctor.imageUrl,
      roles: doctor.roles, specialization: doctor.specialization,
      experienceMonths: doctor.experienceMonths, schedules: doctor.schedules,
    ));
  }

  @override
  Future<void> updateDoctor(DoctorEntity doctor) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updateDoctor(doctor.id, {
          'first_name': doctor.firstName, 'last_name': doctor.lastName,
          'username': doctor.username, 'email': doctor.email,
          'phone': doctor.phone, 'address': doctor.address,
          'gender': doctor.gender, 'birthday_date': doctor.birthdayDate,
        });
        return;
      } catch (_) {}
    }
    dataSource.updateDoctor(DoctorModel(
      id: doctor.id, firstName: doctor.firstName, lastName: doctor.lastName,
      username: doctor.username, email: doctor.email,
      phone: doctor.phone, address: doctor.address,
      gender: doctor.gender, birthdayDate: doctor.birthdayDate,
      isActive: doctor.isActive, imageUrl: doctor.imageUrl,
      roles: doctor.roles, specialization: doctor.specialization,
      experienceMonths: doctor.experienceMonths, schedules: doctor.schedules,
    ));
  }

  @override
  Future<void> deleteDoctor(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.deleteDoctor(id); return; } catch (_) {}
    }
    dataSource.deleteDoctor(id);
  }

  @override
  Future<List<DoctorEntity>> searchDoctors(String query) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getDoctors(search: query);
      } catch (_) {}
    }
    return dataSource.searchDoctors(query);
  }

  @override
  Future<bool> activateAccount(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.activateAccount(id);
        return true;
      } catch (_) {}
    }
    return false;
  }

  @override
  Future<DoctorProfileEntity> getDoctorProfile(String id) async {
    if (remoteDataSource != null) {
      try {
        final doctor = await remoteDataSource!.getDoctorById(id);
        final reviews = doctor.recentReviews.isNotEmpty
            ? doctor.recentReviews
            : dataSource.getDoctorReviews(id);
        final now = DateTime.now();
        final slots = dataSource.getDoctorSlots(id, DateTime(now.year, now.month));
        return DoctorProfileEntity(
          doctor: doctor,
          reviews: reviews,
          availableSlots: slots.map((s) => TimeSlotEntity(
            id: s.id,
            date: now,
            time: '${s.startTime} - ${s.endTime}',
            isAvailable: s.isActive,
          )).toList(),
        );
      } catch (_) {}
    }
    final doctor = dataSource.doctorById(id);
    if (doctor == null) throw Exception('Doctor not found');
    final reviews = dataSource.getDoctorReviews(id);
    final now = DateTime.now();
    final slots = dataSource.getDoctorSlots(id, DateTime(now.year, now.month));
    return DoctorProfileEntity(
      doctor: doctor,
      reviews: reviews,
      availableSlots: slots.map((s) => TimeSlotEntity(
        id: s.id,
        date: now,
        time: '${s.startTime} - ${s.endTime}',
        isAvailable: s.isActive,
      )).toList(),
    );
  }

  @override
  Future<List<ReviewEntity>> getDoctorReviews(String doctorId) async =>
      dataSource.getDoctorReviews(doctorId);

  @override
  Future<List<DoctorScheduleEntity>> getDoctorSlots(String doctorId, DateTime month) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getDoctorSchedules(doctorId, month);
      } catch (_) {}
    }
    return dataSource.getDoctorSlots(doctorId, month);
  }

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

  @override
  Future<List<DoctorEntity>> getDoctorsWithAppointments({required String patientId}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getDoctorsWithAppointments(patientId: patientId);
      } catch (_) {}
    }
    return dataSource.allDoctors;
  }
}
