import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/presentation/blocs/location/location_cubit.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';

class CountryPickerField extends StatelessWidget {
  final CountryEntity? selectedCountry;
  final ValueChanged<CountryEntity> onChanged;

  const CountryPickerField({
    super.key,
    this.selectedCountry,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final selected = selectedCountry;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showPicker(context, colors, state.countries),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'الدَّوْلَةُ',
              filled: true,
              fillColor: colors.cardBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.public_rounded),
            ),
            child: Text(
              selected != null ? '${selected.flag} ${selected.nameAr}' : 'اخْتَرِ الدَّوْلَةَ',
              style: TextStyle(color: selected != null ? colors.textPrimary : colors.textLight, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void _showPicker(BuildContext context, AppColorSet colors, List<CountryEntity> countries) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: screenHeight * 0.55),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        var filtered = countries;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.divider, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text('اخْتَرِ الدَّوْلَةَ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: (v) => setSheetState(() {
                      filtered = countries.where((c) => c.nameAr.contains(v) || c.name.contains(v) || c.code.contains(v.toUpperCase())).toList();
                    }),
                    decoration: InputDecoration(
                      hintText: 'بَحْثٌ...',
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
                        final c = filtered[i];
                        final isSelected = selectedCountry?.id == c.id;
                        return ListTile(
                          leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                          title: Text(c.nameAr, style: TextStyle(color: colors.textPrimary)),
                          subtitle: Text('${c.name} | ${c.phoneCode}', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                          trailing: isSelected ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22) : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          selected: isSelected,
                          selectedTileColor: colors.primary.withValues(alpha: 0.08),
                          onTap: () {
                            onChanged(c);
                            Navigator.pop(ctx);
                          },
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
}

class CityPickerField extends StatelessWidget {
  final CityEntity? selectedCity;
  final ValueChanged<CityEntity> onChanged;

  const CityPickerField({
    super.key,
    this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final selected = selectedCity;
        final enabled = state.selectedCountry != null;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled ? () => _showPicker(context, colors, state.cities) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'المَدِينَةُ',
              filled: true,
              fillColor: colors.cardBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.location_city_rounded),
            ),
            child: Text(
              selected != null ? selected.nameAr : (!enabled ? 'اخْتَرِ الدَّوْلَةَ أَوَّلًا' : 'اخْتَرِ المَدِينَةَ'),
              style: TextStyle(color: selected != null ? colors.textPrimary : colors.textLight, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void _showPicker(BuildContext context, AppColorSet colors, List<CityEntity> cities) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: screenHeight * 0.55),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        var filtered = cities;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.divider, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text('اخْتَرِ المَدِينَةَ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: (v) => setSheetState(() {
                      filtered = cities.where((c) => c.nameAr.contains(v) || c.name.contains(v)).toList();
                    }),
                    decoration: InputDecoration(
                      hintText: 'بَحْثٌ...',
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
                        final c = filtered[i];
                        final isSelected = selectedCity?.id == c.id;
                        return ListTile(
                          title: Text(c.nameAr, style: TextStyle(color: colors.textPrimary)),
                          subtitle: Text(c.name, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                          trailing: isSelected ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22) : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          selected: isSelected,
                          selectedTileColor: colors.primary.withValues(alpha: 0.08),
                          onTap: () {
                            onChanged(c);
                            Navigator.pop(ctx);
                          },
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
}
