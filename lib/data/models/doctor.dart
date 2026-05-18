import 'package:equatable/equatable.dart';

enum Gender { male, female }

class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String? imageUrl;
  final bool isAvailable;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    this.imageUrl,
    this.isAvailable = true,
  });

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    String? phone,
    String? email,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      imageUrl: map['imageUrl'] as String?,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, name, specialty, phone, email, imageUrl, isAvailable];
}
