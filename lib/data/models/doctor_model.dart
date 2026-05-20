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
      };
}
