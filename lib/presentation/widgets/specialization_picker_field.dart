import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

const _specializations = {
  'cardiology': 'أمراض القلب',
  'dermatology': 'الأمراض الجلدية',
  'neurology': 'الأمراض العصبية',
  'pediatrics': 'طب الأطفال',
  'orthopedics': 'جراحة العظام',
  'ophthalmology': 'طب العيون',
  'ent': 'الأذن والأنف والحنجرة',
  'psychiatry': 'الطب النفسي',
  'radiology': 'الأشعة',
  'surgery': 'الجراحة العامة',
  'internal_medicine': 'الباطنة',
  'obstetrics_gynecology': 'النساء والتوليد',
  'emergency_medicine': 'طب الطوارئ',
  'anesthesiology': 'التخدير',
  'pathology': 'علم الأمراض',
  'urology': 'المسالك البولية',
  'gastroenterology': 'الجهاز الهضمي',
  'endocrinology': 'الغدد الصماء',
  'pulmonology': 'أمراض الصدر',
  'rheumatology': 'الروماتيزم',
  'nephrology': 'أمراض الكلى',
  'hematology': 'أمراض الدم',
  'oncology': 'الأورام',
  'infectious_disease': 'الأمراض المعدية',
  'genetics': 'علم الوراثة',
  'immunology': 'علم المناعة',
  'sports_medicine': 'الطب الرياضي',
};

class SpecializationPickerField extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const SpecializationPickerField({
    super.key,
    this.value,
    required this.onChanged,
    this.validator,
  });

  String? get _label => value != null ? _specializations[value] : null;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextFormField(
      readOnly: true,
      style: TextStyle(color: colors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: 'التَّخَصُّصُ',
        labelStyle: TextStyle(color: colors.textSecondary),
        hintText: 'اخْتَرِ التَّخَصُّصَ',
        hintStyle: TextStyle(color: colors.textLight),
        prefixIcon: Icon(Icons.medical_services_outlined, color: colors.textSecondary),
        suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: colors.textSecondary, size: 22),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      controller: value != null ? TextEditingController(text: _label) : null,
      validator: validator != null ? (v) => validator!(value) : null,
      onTap: () => _showPicker(context, colors),
    );
  }

  void _showPicker(BuildContext context, AppColorSet colors) {
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
        var filtered = _specializations.entries.toList();

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
                    'اخْتَرِ التَّخَصُّصَ',
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
                        filtered = _specializations.entries
                            .where((e) =>
                                e.value.contains(v) || e.key.contains(v))
                            .toList();
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
                  Flexible(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final e = filtered[i];
                        final isSelected = e.key == value;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.medical_services_outlined,
                                  color: isSelected ? colors.primary : colors.textSecondary, size: 22),
                              title: Text(e.value, style: TextStyle(color: colors.textPrimary)),
                              subtitle: Text(
                                _specializationEnglish(e.key),
                                style: TextStyle(color: colors.textSecondary, fontSize: 12),
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22)
                                  : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              selected: isSelected,
                              selectedTileColor: colors.primary.withValues(alpha: 0.08),
                              onTap: () {
                                onChanged(e.key);
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

String _specializationEnglish(String key) {
  return switch (key) {
    'cardiology' => 'Cardiology',
    'dermatology' => 'Dermatology',
    'neurology' => 'Neurology',
    'pediatrics' => 'Pediatrics',
    'orthopedics' => 'Orthopedics',
    'ophthalmology' => 'Ophthalmology',
    'ent' => 'ENT',
    'psychiatry' => 'Psychiatry',
    'radiology' => 'Radiology',
    'surgery' => 'General Surgery',
    'internal_medicine' => 'Internal Medicine',
    'obstetrics_gynecology' => 'OB/GYN',
    'emergency_medicine' => 'Emergency Medicine',
    'anesthesiology' => 'Anesthesiology',
    'pathology' => 'Pathology',
    'urology' => 'Urology',
    'gastroenterology' => 'Gastroenterology',
    'endocrinology' => 'Endocrinology',
    'pulmonology' => 'Pulmonology',
    'rheumatology' => 'Rheumatology',
    'nephrology' => 'Nephrology',
    'hematology' => 'Hematology',
    'oncology' => 'Oncology',
    'infectious_disease' => 'Infectious Disease',
    'genetics' => 'Genetics',
    'immunology' => 'Immunology',
    'sports_medicine' => 'Sports Medicine',
    _ => key,
  };
}
