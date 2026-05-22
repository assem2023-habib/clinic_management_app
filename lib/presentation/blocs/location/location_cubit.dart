import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';

class LocationState extends Equatable {
  final List<CountryEntity> countries;
  final List<CityEntity> cities;
  final CountryEntity? selectedCountry;
  final bool isLoadingCountries;
  final bool isLoadingCities;
  final String? error;

  const LocationState({
    this.countries = const [],
    this.cities = const [],
    this.selectedCountry,
    this.isLoadingCountries = false,
    this.isLoadingCities = false,
    this.error,
  });

  LocationState copyWith({
    List<CountryEntity>? countries,
    List<CityEntity>? cities,
    CountryEntity? selectedCountry,
    bool? isLoadingCountries,
    bool? isLoadingCities,
    String? error,
  }) {
    return LocationState(
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      isLoadingCountries: isLoadingCountries ?? this.isLoadingCountries,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      error: error,
    );
  }

  @override
  List<Object?> get props => [countries, cities, selectedCountry, isLoadingCountries, isLoadingCities, error];
}

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;

  LocationCubit({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(const LocationState());

  Future<void> loadCountries() async {
    emit(state.copyWith(isLoadingCountries: true, error: null));
    try {
      final countries = await _locationRepository.getAllCountries();
      emit(state.copyWith(isLoadingCountries: false, countries: countries));
    } catch (e) {
      emit(state.copyWith(isLoadingCountries: false, error: e.toString()));
    }
  }

  Future<void> selectCountry(CountryEntity country) async {
    emit(state.copyWith(selectedCountry: country, cities: [], isLoadingCities: true, error: null));
    try {
      final cities = await _locationRepository.getCitiesByCountry(country.id);
      emit(state.copyWith(isLoadingCities: false, cities: cities));
    } catch (e) {
      emit(state.copyWith(isLoadingCities: false, error: e.toString()));
    }
  }

  Future<void> searchCities(String query, {String? countryId}) async {
    emit(state.copyWith(isLoadingCities: true, error: null));
    try {
      final cities = await _locationRepository.searchCities(query, countryId: countryId);
      emit(state.copyWith(isLoadingCities: false, cities: cities));
    } catch (e) {
      emit(state.copyWith(isLoadingCities: false, error: e.toString()));
    }
  }

  void clearError() => emit(state.copyWith(error: null));
}
