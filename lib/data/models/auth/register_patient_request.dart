class RegisterPatientRequest {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final String gender;
  final String? birthdayDate;
  final String? cityId;

  const RegisterPatientRequest({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    required this.gender,
    this.birthdayDate,
    this.cityId,
  });

  Map<String, dynamic> toMap() => {
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'email': email,
    'password': password,
    if (phone != null) 'phone': phone,
    if (address != null) 'address': address,
    'gender': gender,
    if (birthdayDate != null) 'birthday_date': birthdayDate,
    if (cityId != null) 'city_id': cityId,
  };
}
