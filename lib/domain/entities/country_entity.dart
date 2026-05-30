import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String code;
  final String? flag;
  final String? createdAt;
  final String? updatedAt;

  const CountryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.code,
    this.flag,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr, code, flag, createdAt, updatedAt];
}
