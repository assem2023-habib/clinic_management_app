class DoctorEntity {
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
}
