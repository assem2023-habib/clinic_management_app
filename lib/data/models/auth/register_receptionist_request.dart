import 'register_patient_request.dart';

class RegisterReceptionistRequest extends RegisterPatientRequest {
  final String? shiftStart;
  final String? shiftEnd;

  const RegisterReceptionistRequest({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.password,
    super.phone,
    super.address,
    required super.gender,
    super.birthdayDate,
    this.shiftStart,
    this.shiftEnd,
  });

  @override
  Map<String, dynamic> toMap() => {
    ...super.toMap(),
    if (shiftStart != null) 'shift_start': shiftStart,
    if (shiftEnd != null) 'shift_end': shiftEnd,
  };
}
