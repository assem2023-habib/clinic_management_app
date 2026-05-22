import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String id;
  final String name;
  final String nameAr;
  final String countryId;

  const CityEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.countryId,
  });

  @override
  List<Object?> get props => [id, name, nameAr, countryId];
}
