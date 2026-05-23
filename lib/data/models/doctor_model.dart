import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.phone,
    required super.email,
    super.imageUrl,
    super.isAvailable,
    super.bio,
    super.experienceYears,
    super.rating,
    super.reviewsCount,
    super.patientsCount,
    super.surgeriesCount,
    super.qualifications,
    super.services,
    super.education,
    super.clinicName,
    super.clinicAddress,
    super.consultationFee,
    super.languages,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      imageUrl: map['imageUrl'] as String?,
      isAvailable: map['isAvailable'] as bool? ?? true,
      bio: map['bio'] as String?,
      experienceYears: map['experienceYears'] as int? ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: map['reviewsCount'] as int? ?? 0,
      patientsCount: map['patientsCount'] as int? ?? 0,
      surgeriesCount: map['surgeriesCount'] as int? ?? 0,
      qualifications: map['qualifications'] != null
          ? List<String>.from(map['qualifications'] as List)
          : [],
      services: map['services'] != null
          ? List<String>.from(map['services'] as List)
          : [],
      education: map['education'] as String?,
      clinicName: map['clinicName'] as String?,
      clinicAddress: map['clinicAddress'] as String?,
      consultationFee: (map['consultationFee'] as num?)?.toDouble(),
      languages: map['languages'] != null
          ? List<String>.from(map['languages'] as List)
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'phone': phone,
        'email': email,
        'imageUrl': imageUrl,
        'isAvailable': isAvailable,
        'bio': bio,
        'experienceYears': experienceYears,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'patientsCount': patientsCount,
        'surgeriesCount': surgeriesCount,
        'qualifications': qualifications,
        'services': services,
        'education': education,
        'clinicName': clinicName,
        'clinicAddress': clinicAddress,
        'consultationFee': consultationFee,
        'languages': languages,
      };
}
