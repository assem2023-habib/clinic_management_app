import 'package:equatable/equatable.dart';

enum Gender { male, female }

class PatientEntity extends Equatable {
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String phone;
  final String email;
  final String address;
  final String? bloodType;
  final DateTime? registeredDate;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    required this.address,
    this.bloodType,
    this.registeredDate,
  });

  PatientEntity copyWith({
    String? id,
    String? name,
    int? age,
    Gender? gender,
    String? phone,
    String? email,
    String? address,
    String? bloodType,
    DateTime? registeredDate,
  }) {
    return PatientEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      bloodType: bloodType ?? this.bloodType,
      registeredDate: registeredDate ?? this.registeredDate,
    );
  }

  @override
  List<Object?> get props => [id, name, age, gender, phone, email, address, bloodType, registeredDate];
}
