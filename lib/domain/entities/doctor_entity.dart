import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String? imageUrl;
  final bool isAvailable;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    this.imageUrl,
    this.isAvailable = true,
  });

  DoctorEntity copyWith({
    String? id,
    String? name,
    String? specialty,
    String? phone,
    String? email,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [id, name, specialty, phone, email, imageUrl, isAvailable];
}
