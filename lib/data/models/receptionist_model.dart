import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/domain/entities/receptionist_entity.dart';

class ReceptionistModel extends ReceptionistEntity {
  const ReceptionistModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    super.phone,
    super.address,
    required super.gender,
    super.birthdayDate,
    super.roles = const [],
    super.isActive = true,
    super.imageUrl,
    super.countryId,
    super.cityId,
    super.fcmTokens,
    super.emailVerifiedAt,
    super.createdAt,
    super.updatedAt,
    super.shiftStart,
    super.shiftEnd,
  });

  factory ReceptionistModel.fromMap(Map<String, dynamic> map) {
    final userModel = UserModel.fromMap(map);
    final recData = map['receptionist'] as Map<String, dynamic>?;
    return ReceptionistModel(
      id: userModel.id, firstName: userModel.firstName,
      lastName: userModel.lastName, username: userModel.username,
      email: userModel.email, phone: userModel.phone,
      address: userModel.address, gender: userModel.gender,
      birthdayDate: userModel.birthdayDate, roles: userModel.roles,
      isActive: userModel.isActive, imageUrl: userModel.imageUrl,
      countryId: userModel.countryId, cityId: userModel.cityId,
      fcmTokens: userModel.fcmTokens,
      emailVerifiedAt: userModel.emailVerifiedAt,
      createdAt: userModel.createdAt, updatedAt: userModel.updatedAt,
      shiftStart: recData?['shift_start'] as String?,
      shiftEnd: recData?['shift_end'] as String?,
    );
  }

  Map<String, dynamic> toCreateRequest() {
    return {
      'first_name': firstName, 'last_name': lastName,
      'username': username, 'email': email,
      'phone': phone, 'address': address,
      'gender': gender, 'birthday_date': birthdayDate,
      'city_id': cityId, 'country_id': countryId,
      'shift_start': shiftStart, 'shift_end': shiftEnd,
    };
  }

  Map<String, dynamic> toUpdateRequest() {
    return {
      'first_name': firstName, 'last_name': lastName,
      'username': username, 'email': email,
      'phone': phone, 'address': address,
      'gender': gender, 'birthday_date': birthdayDate,
      'city_id': cityId, 'country_id': countryId,
      'shift_start': shiftStart, 'shift_end': shiftEnd,
    };
  }
}
