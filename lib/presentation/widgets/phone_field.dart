import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class CountryCode {
  final String flag;
  final String code;
  final String dialCode;
  final String name;

  const CountryCode({
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.name,
  });
}

final _countries = [
  CountryCode(flag: '🇸🇾', code: 'SY', dialCode: '+963', name: AppStrings.countriesSyria),
  CountryCode(flag: '🇪🇬', code: 'EG', dialCode: '+20', name: AppStrings.countriesEgypt),
  CountryCode(flag: '🇸🇦', code: 'SA', dialCode: '+966', name: AppStrings.countriesSaudi),
  CountryCode(flag: '🇦🇪', code: 'AE', dialCode: '+971', name: AppStrings.countriesUAE),
  CountryCode(flag: '🇶🇦', code: 'QA', dialCode: '+974', name: AppStrings.countriesQatar),
  CountryCode(flag: '🇰🇼', code: 'KW', dialCode: '+965', name: AppStrings.countriesKuwait),
  CountryCode(flag: '🇴🇲', code: 'OM', dialCode: '+968', name: AppStrings.countriesOman),
  CountryCode(flag: '🇧🇭', code: 'BH', dialCode: '+973', name: AppStrings.countriesBahrain),
  CountryCode(flag: '🇯🇴', code: 'JO', dialCode: '+962', name: AppStrings.countriesJordan),
  CountryCode(flag: '🇮🇶', code: 'IQ', dialCode: '+964', name: AppStrings.countriesIraq),
  CountryCode(flag: '🇱🇧', code: 'LB', dialCode: '+961', name: AppStrings.countriesLebanon),
  CountryCode(flag: '🇾🇪', code: 'YE', dialCode: '+967', name: AppStrings.countriesYemen),
  CountryCode(flag: '🇵🇸', code: 'PS', dialCode: '+970', name: AppStrings.countriesPalestine),
  CountryCode(flag: '🇱🇾', code: 'LY', dialCode: '+218', name: AppStrings.countriesLibya),
  CountryCode(flag: '🇹🇳', code: 'TN', dialCode: '+216', name: AppStrings.countriesTunisia),
  CountryCode(flag: '🇩🇿', code: 'DZ', dialCode: '+213', name: AppStrings.countriesAlgeria),
  CountryCode(flag: '🇲🇦', code: 'MA', dialCode: '+212', name: AppStrings.countriesMorocco),
  CountryCode(flag: '🇸🇩', code: 'SD', dialCode: '+249', name: AppStrings.countriesSudan),
  CountryCode(flag: '🇺🇸', code: 'US', dialCode: '+1', name: AppStrings.countriesUSA),
  CountryCode(flag: '🇬🇧', code: 'GB', dialCode: '+44', name: AppStrings.countriesUK),
  CountryCode(flag: '🇫🇷', code: 'FR', dialCode: '+33', name: AppStrings.countriesFrance),
  CountryCode(flag: '🇩🇪', code: 'DE', dialCode: '+49', name: AppStrings.countriesGermany),
];

class PhoneField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? hintText;

  const PhoneField({
    super.key,
    this.onChanged,
    this.validator,
    this.hintText,
  });

  @override
  State<PhoneField> createState() => PhoneFieldState();
}

class PhoneFieldState extends State<PhoneField> {
  final _localController = TextEditingController();
  CountryCode _selected = _countries[0];

  String get fullPhoneNumber => '${_selected.dialCode}${_localController.text}';

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(fullPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextFormField(
      controller: _localController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: widget.validator,
      onChanged: _onChanged,
      style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.bodyLarge),
      decoration: InputDecoration(
        hintText: widget.hintText ?? AppStrings.phone,
        hintStyle: TextStyle(color: colors.textLight),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: _buildCountryPicker(colors),
        prefixIconConstraints: const BoxConstraints(minWidth: 96, minHeight: 48),
      ),
    );
  }

  Widget _buildCountryPicker(AppColorSet colors) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showPicker(context, colors),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: colors.divider.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selected.flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(
                  _selected.dialCode,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSpacing.bodyMedium,
                  ),
                ),
                Icon(Icons.arrow_drop_down_rounded, color: colors.textSecondary, size: AppSpacing.iconSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, AppColorSet colors) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: screenHeight * 0.75),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        var filtered = _countries;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.chooseCountry,
                    style: TextStyle(
                      fontSize: AppSpacing.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: (v) {
                      setSheetState(() {
                        filtered = _countries.where((c) =>
                          c.name.contains(v) ||
                          c.code.contains(v.toUpperCase()) ||
                          c.dialCode.contains(v),
                        ).toList();
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
                        final c = filtered[i];
                        final isSelected = c.code == _selected.code;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Text(c.flag, style: const TextStyle(fontSize: AppSpacing.titleError)),
                              title: Text(c.name, style: TextStyle(color: colors.textPrimary)),
                              subtitle: Text(
                                '${c.code} ${c.dialCode}',
                                style: TextStyle(color: colors.textSecondary, fontSize: AppSpacing.bodySmall),
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle_rounded, color: colors.primary, size: AppSpacing.iconMedium)
                                  : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              selected: isSelected,
                              selectedTileColor: colors.primary.withValues(alpha: 0.08),
                              onTap: () {
                                setState(() => _selected = c);
                                _onChanged(_localController.text);
                                Navigator.pop(ctx);
                              },
                            ),
                            if (i < filtered.length - 1)
                              Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
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
}

