import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/data/models/doctor.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String phone;
  final String email;
  final String address;
  final String? bloodType;
  final DateTime? registeredDate;

  const Patient({
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

  Patient copyWith({
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
    return Patient(
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender.name,
      'phone': phone,
      'email': email,
      'address': address,
      'bloodType': bloodType,
      'registeredDate': registeredDate?.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      gender: map['gender'] == 'male' ? Gender.male : Gender.female,
      phone: map['phone'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      bloodType: map['bloodType'] as String?,
      registeredDate: map['registeredDate'] != null
          ? DateTime.parse(map['registeredDate'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, age, gender, phone, email, address, bloodType, registeredDate];
}
