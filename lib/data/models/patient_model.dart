import 'package:clinic_management_app/domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.phone,
    required super.email,
    required super.address,
    super.bloodType,
    super.registeredDate,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map) => PatientModel(
        id: map['id'] as String,
        name: map['name'] as String,
        age: map['age'] as int,
        gender: map['gender'] == 'male' ? Gender.male : Gender.female,
        phone: map['phone'] as String,
        email: map['email'] as String,
        address: map['address'] as String,
        bloodType: map['bloodType'] as String?,
        registeredDate: map['registeredDate'] != null ? DateTime.parse(map['registeredDate'] as String) : null,
      );

  Map<String, dynamic> toMap() => {
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
