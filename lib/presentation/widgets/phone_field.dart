import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

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

const _countries = [
  CountryCode(flag: '🇸🇾', code: 'SY', dialCode: '+963', name: 'سوريا'),
  CountryCode(flag: '🇪🇬', code: 'EG', dialCode: '+20', name: 'مصر'),
  CountryCode(flag: '🇸🇦', code: 'SA', dialCode: '+966', name: 'السعودية'),
  CountryCode(flag: '🇦🇪', code: 'AE', dialCode: '+971', name: 'الإمارات'),
  CountryCode(flag: '🇶🇦', code: 'QA', dialCode: '+974', name: 'قطر'),
  CountryCode(flag: '🇰🇼', code: 'KW', dialCode: '+965', name: 'الكويت'),
  CountryCode(flag: '🇴🇲', code: 'OM', dialCode: '+968', name: 'عُمان'),
  CountryCode(flag: '🇧🇭', code: 'BH', dialCode: '+973', name: 'البحرين'),
  CountryCode(flag: '🇯🇴', code: 'JO', dialCode: '+962', name: 'الأردن'),
  CountryCode(flag: '🇮🇶', code: 'IQ', dialCode: '+964', name: 'العراق'),
  CountryCode(flag: '🇱🇧', code: 'LB', dialCode: '+961', name: 'لبنان'),
  CountryCode(flag: '🇾🇪', code: 'YE', dialCode: '+967', name: 'اليمن'),
  CountryCode(flag: '🇵🇸', code: 'PS', dialCode: '+970', name: 'فلسطين'),
  CountryCode(flag: '🇱🇾', code: 'LY', dialCode: '+218', name: 'ليبيا'),
  CountryCode(flag: '🇹🇳', code: 'TN', dialCode: '+216', name: 'تونس'),
  CountryCode(flag: '🇩🇿', code: 'DZ', dialCode: '+213', name: 'الجزائر'),
  CountryCode(flag: '🇲🇦', code: 'MA', dialCode: '+212', name: 'المغرب'),
  CountryCode(flag: '🇸🇩', code: 'SD', dialCode: '+249', name: 'السودان'),
  CountryCode(flag: '🇺🇸', code: 'US', dialCode: '+1', name: 'الولايات المتحدة'),
  CountryCode(flag: '🇬🇧', code: 'GB', dialCode: '+44', name: 'المملكة المتحدة'),
  CountryCode(flag: '🇫🇷', code: 'FR', dialCode: '+33', name: 'فرنسا'),
  CountryCode(flag: '🇩🇪', code: 'DE', dialCode: '+49', name: 'ألمانيا'),
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
      style: TextStyle(color: colors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'رَقْمُ الهَاتِفِ',
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
                    fontSize: 14,
                  ),
                ),
                Icon(Icons.arrow_drop_down_rounded, color: colors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, AppColorSet colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final searchCtrl = TextEditingController();
            var filtered = _countries;

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
                    'اخْتَرِ الدَّوْلَةَ',
                    style: TextStyle(
                      fontSize: 16,
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
                      hintText: 'بَحْثٌ...',
                      hintStyle: TextStyle(color: colors.textLight),
                      prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final isSelected = c.code == _selected.code;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                              title: Text(c.name, style: TextStyle(color: colors.textPrimary)),
                              subtitle: Text(
                                '${c.code} ${c.dialCode}',
                                style: TextStyle(color: colors.textSecondary, fontSize: 12),
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22)
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
