import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';

class CountryCityPickerField extends StatefulWidget {
  final String? cityId;
  final ValueChanged<String> onCityChanged;
  final String? Function(String?)? validator;

  const CountryCityPickerField({
    super.key,
    this.cityId,
    required this.onCityChanged,
    this.validator,
  });

  @override
  State<CountryCityPickerField> createState() => _CountryCityPickerFieldState();
}

class _CountryCityPickerFieldState extends State<CountryCityPickerField> {
  CountryEntity? _selectedCountry;
  List<CountryEntity> _countries = [];
  bool _isLoading = false;
  String? _label;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoading = true);
    try {
      final repo = RepositoryProvider.of<LocationRepository>(context);
      final countries = await repo.getAllCountries();
      setState(() {
        _countries = countries;
        _isLoading = false;
      });
      if (_countries.isNotEmpty && _selectedCountry == null) {
        setState(() => _selectedCountry = _countries.first);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCitiesAndShowPicker(CountryEntity country, AppColorSet colors) async {
    setState(() => _isLoading = true);
    List<CityEntity> cities = [];
    try {
      final repo = RepositoryProvider.of<LocationRepository>(context);
      cities = await repo.getCitiesByCountry(country.id);
    } catch (_) {}
    setState(() => _isLoading = false);

    if (!mounted) return;
    _showCityPicker(colors, cities);
  }

  void _showCountriesPicker(AppColorSet colors) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: screenHeight * 0.65),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        var filtered = _countries.toList();

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: colors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.chooseCountry,
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: (v) {
                      setSheetState(() {
                        filtered = _countries.where((c) =>
                          c.nameAr.contains(v) || c.nameEn.contains(v)).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      hintStyle: TextStyle(color: colors.textLight),
                      prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final country = filtered[i];
                        final isSelected = country.id == _selectedCountry?.id;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Text(country.flag ?? '🌍', style: const TextStyle(fontSize: 24)),
                              title: Text(country.nameAr, style: TextStyle(color: colors.textPrimary)),
                              subtitle: Text(country.nameEn, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22)
                                  : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              selected: isSelected,
                              selectedTileColor: colors.primary.withValues(alpha: 0.08),
                              onTap: () {
                                setState(() => _selectedCountry = country);
                                Navigator.pop(ctx);
                                _loadCitiesAndShowPicker(country, colors);
                              },
                            ),
                            if (i < filtered.length - 1)
                              Divider(
                                height: 1, indent: 16, endIndent: 16,
                                color: colors.divider.withValues(alpha: 0.3),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCityPicker(AppColorSet colors, List<CityEntity> cities) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: screenHeight * 0.65),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        var filtered = cities.toList();

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: colors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          _showCountriesPicker(colors);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_rounded, size: 18, color: colors.primary),
                            const SizedBox(width: 4),
                            Text(_selectedCountry?.nameAr ?? '', style: TextStyle(color: colors.primary, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.chooseCity,
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 60),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: (v) {
                      setSheetState(() {
                        filtered = cities.where((c) =>
                          c.nameAr.contains(v) || c.nameEn.contains(v)).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      hintStyle: TextStyle(color: colors.textLight),
                      prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final city = filtered[i];
                        final isSelected = city.id == widget.cityId;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.location_city_rounded,
                                  color: isSelected ? colors.primary : colors.textSecondary, size: 24),
                              title: Text(city.nameAr, style: TextStyle(color: colors.textPrimary)),
                              subtitle: Text(city.nameEn, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22)
                                  : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              selected: isSelected,
                              selectedTileColor: colors.primary.withValues(alpha: 0.08),
                              onTap: () {
                                setState(() {
                                  _label = '${_selectedCountry?.nameAr} / ${city.nameAr}';
                                });
                                widget.onCityChanged(city.id);
                                Navigator.pop(ctx);
                              },
                            ),
                            if (i < filtered.length - 1)
                              Divider(
                                height: 1, indent: 16, endIndent: 16,
                                color: colors.divider.withValues(alpha: 0.3),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextFormField(
      readOnly: true,
      style: TextStyle(color: colors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: AppStrings.countryCity,
        labelStyle: TextStyle(color: colors.textSecondary),
        hintText: _isLoading ? AppStrings.loading : AppStrings.chooseCountryCity,
        hintStyle: TextStyle(color: colors.textLight),
        prefixIcon: Icon(Icons.public_rounded, color: colors.textSecondary),
        suffixIcon: _isLoading
            ? SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
              )
            : Icon(Icons.arrow_drop_down_rounded, color: colors.textSecondary, size: 22),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      controller: _label != null ? TextEditingController(text: _label) : null,
      validator: widget.validator != null ? (v) => widget.validator!(widget.cityId) : null,
      onTap: _isLoading ? null : () => _showCountriesPicker(colors),
    );
  }
}
