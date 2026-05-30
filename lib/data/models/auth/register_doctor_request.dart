import 'register_patient_request.dart';

class RegisterDoctorRequest extends RegisterPatientRequest {
  final String specializationId;
  final int experienceMonths;

  const RegisterDoctorRequest({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.password,
    super.phone,
    super.address,
    required super.gender,
    super.birthdayDate,
    required this.specializationId,
    required this.experienceMonths,
  });

  @override
  Map<String, dynamic> toMap() => {
    ...super.toMap(),
    'specialization_id': specializationId,
    'experience_months': experienceMonths,
  };
}
