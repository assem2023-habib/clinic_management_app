import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';
import 'package:clinic_management_app/presentation/blocs/location/location_cubit.dart';
import 'package:clinic_management_app/presentation/widgets/location_picker_field.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late MockLocationRepository repository;
  late LocationCubit cubit;

  final testCountries = <CountryEntity>[
    CountryEntity(id: 'sy', nameEn: 'Syria', nameAr: 'سُورِيَا', code: 'SY', flag: '🇸🇾'),
    CountryEntity(id: 'sa', nameEn: 'Saudi Arabia', nameAr: 'السُّعُودِيَّةُ', code: 'SA', flag: '🇸🇦'),
  ];

  final testCities = <CityEntity>[
    CityEntity(id: 'sy-1', nameEn: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    CityEntity(id: 'sy-2', nameEn: 'Aleppo', nameAr: 'حَلَبُ', countryId: 'sy'),
  ];

  setUp(() {
    repository = MockLocationRepository();
    cubit = LocationCubit(locationRepository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: BlocProvider<LocationCubit>.value(
        value: cubit,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  group('CountryPickerField', () {
    testWidgets('renders label and hint when nothing selected', (tester) async {
      cubit.emit(LocationState(countries: testCountries));

      await tester.pumpWidget(buildTestWidget(
        CountryPickerField(
          selectedCountry: null,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('الدَّوْلَةُ'), findsOneWidget);
      expect(find.text('اخْتَرِ الدَّوْلَةَ'), findsOneWidget);
    });

    testWidgets('shows selected country name and flag', (tester) async {
      cubit.emit(LocationState(countries: testCountries));

      await tester.pumpWidget(buildTestWidget(
        CountryPickerField(
          selectedCountry: testCountries[0],
          onChanged: (_) {},
        ),
      ));

      expect(find.textContaining('سُورِيَا'), findsOneWidget);
    });
  });

  group('CityPickerField', () {
    testWidgets('displays disabled hint when no country selected', (tester) async {
      cubit.emit(LocationState(cities: testCities, selectedCountry: null));

      await tester.pumpWidget(buildTestWidget(
        CityPickerField(
          selectedCity: null,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('المَدِينَةُ'), findsOneWidget);
      expect(find.text('اخْتَرِ الدَّوْلَةَ أَوَّلًا'), findsOneWidget);
    });

    testWidgets('displays city hint when country selected but no city', (tester) async {
      cubit.emit(LocationState(
        cities: testCities,
        selectedCountry: testCountries[0],
      ));

      await tester.pumpWidget(buildTestWidget(
        CityPickerField(
          selectedCity: null,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('اخْتَرِ المَدِينَةَ'), findsOneWidget);
    });

    testWidgets('shows selected city name', (tester) async {
      cubit.emit(LocationState(
        cities: testCities,
        selectedCountry: testCountries[0],
      ));

      await tester.pumpWidget(buildTestWidget(
        CityPickerField(
          selectedCity: testCities[0],
          onChanged: (_) {},
        ),
      ));

      expect(find.text('دِمَشْقُ'), findsOneWidget);
    });
  });
}
