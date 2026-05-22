import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String id;
  final String name;
  final String nameAr;
  final String code;
  final String phoneCode;
  final String flag;

  const CountryEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.phoneCode,
    required this.flag,
  });

  @override
  List<Object?> get props => [id, name, nameAr, code, phoneCode, flag];
}
