import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String? imageUrl;
  final bool isAvailable;
  final String? bio;
  final int experienceYears;
  final double rating;
  final int reviewsCount;
  final int patientsCount;
  final int surgeriesCount;
  final List<String> qualifications;
  final List<String> services;
  final String? education;
  final String? clinicName;
  final String? clinicAddress;
  final double? consultationFee;
  final List<String> languages;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    this.imageUrl,
    this.isAvailable = true,
    this.bio,
    this.experienceYears = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.patientsCount = 0,
    this.surgeriesCount = 0,
    this.qualifications = const [],
    this.services = const [],
    this.education,
    this.clinicName,
    this.clinicAddress,
    this.consultationFee,
    this.languages = const [],
  });

  DoctorEntity copyWith({
    String? id,
    String? name,
    String? specialty,
    String? phone,
    String? email,
    String? imageUrl,
    bool? isAvailable,
    String? bio,
    int? experienceYears,
    double? rating,
    int? reviewsCount,
    int? patientsCount,
    int? surgeriesCount,
    List<String>? qualifications,
    List<String>? services,
    String? education,
    String? clinicName,
    String? clinicAddress,
    double? consultationFee,
    List<String>? languages,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      bio: bio ?? this.bio,
      experienceYears: experienceYears ?? this.experienceYears,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      patientsCount: patientsCount ?? this.patientsCount,
      surgeriesCount: surgeriesCount ?? this.surgeriesCount,
      qualifications: qualifications ?? this.qualifications,
      services: services ?? this.services,
      education: education ?? this.education,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      consultationFee: consultationFee ?? this.consultationFee,
      languages: languages ?? this.languages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        phone,
        email,
        imageUrl,
        isAvailable,
        bio,
        experienceYears,
        rating,
        reviewsCount,
        patientsCount,
        surgeriesCount,
        qualifications,
        services,
        education,
        clinicName,
        clinicAddress,
        consultationFee,
        languages,
      ];
}
