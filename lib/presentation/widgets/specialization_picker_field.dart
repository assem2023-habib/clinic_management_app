import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';

const _fallbackSpecs = {
  'cardiology': AppStrings.specCardiology,
  'dermatology': AppStrings.specDermatology,
  'neurology': AppStrings.specNeurology,
  'pediatrics': AppStrings.specPediatrics,
  'orthopedics': AppStrings.specOrthopedics,
  'ophthalmology': AppStrings.specOphthalmology,
  'ent': AppStrings.specENT,
  'psychiatry': AppStrings.specPsychiatry,
  'radiology': AppStrings.specRadiology,
  'surgery': AppStrings.specGeneralSurgery,
  'internal_medicine': AppStrings.specInternalMedicine,
  'obstetrics_gynecology': AppStrings.specObGyn,
  'emergency_medicine': AppStrings.specEmergency,
  'anesthesiology': AppStrings.specAnesthesia,
  'pathology': AppStrings.specPathology,
  'urology': AppStrings.specUrology,
  'gastroenterology': AppStrings.specGastroenterology,
  'endocrinology': AppStrings.specEndocrinology,
  'pulmonology': AppStrings.specPulmonology,
  'rheumatology': AppStrings.specRheumatology,
  'nephrology': AppStrings.specNephrology,
  'hematology': AppStrings.specHematology,
  'oncology': AppStrings.specOncology,
  'infectious_disease': AppStrings.specInfectious,
  'genetics': AppStrings.specGenetics,
  'immunology': AppStrings.specImmunology,
  'sports_medicine': AppStrings.specSportsMedicine,
};

class SpecializationPickerField extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final List<SpecializationEntity>? specializations;

  const SpecializationPickerField({
    super.key,
    this.value,
    required this.onChanged,
    this.validator,
    this.specializations,
  });

  bool get _useApiData => specializations != null && specializations!.isNotEmpty;

  String? get _label {
    if (value == null) return null;
    if (_useApiData) {
      final match = specializations!.where((s) => s.id == value).firstOrNull;
      return match?.nameAr;
    }
    return _fallbackSpecs[value];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextFormField(
      readOnly: true,
      style: TextStyle(color: colors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: AppStrings.specialty,
        labelStyle: TextStyle(color: colors.textSecondary),
        hintText: AppStrings.chooseSpecialty,
        hintStyle: TextStyle(color: colors.textLight),
        prefixIcon: Icon(value != null ? _specializationIcon(value!) : Icons.medical_services_outlined, color: colors.textSecondary),
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
        var filteredApi = specializations?.toList() ?? [];
        var filteredFallback = _fallbackSpecs.entries.toList();

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
                    AppStrings.chooseSpecialty,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: (v) {
                      setSheetState(() {
                        if (_useApiData) {
                          filteredApi = specializations!
                              .where((s) => s.nameAr.contains(v) || s.nameEn.contains(v) || s.slug.contains(v))
                              .toList();
                        } else {
                          filteredFallback = _fallbackSpecs.entries
                              .where((e) => e.value.contains(v) || e.key.contains(v))
                              .toList();
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      hintStyle: TextStyle(color: colors.textLight),
                      prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
                      filled: true, fillColor: colors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      itemCount: _useApiData ? filteredApi.length : filteredFallback.length,
                      itemBuilder: (_, i) {
                        if (_useApiData) {
                          final spec = filteredApi[i];
                          final isSelected = spec.id == value;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(_specializationIcon(spec.slug),
                                    color: isSelected ? colors.primary : colors.textSecondary, size: 24),
                                title: Text(spec.nameAr, style: TextStyle(color: colors.textPrimary)),
                                subtitle: Text(spec.nameEn, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                                trailing: isSelected
                                    ? Icon(Icons.check_circle_rounded, color: colors.primary, size: 22)
                                    : null,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                selected: isSelected,
                                selectedTileColor: colors.primary.withValues(alpha: 0.08),
                                onTap: () {
                                  onChanged(spec.id);
                                  Navigator.pop(ctx);
                                },
                              ),
                              if (i < filteredApi.length - 1)
                                Divider(height: 1, indent: 16, endIndent: 16, color: colors.divider.withValues(alpha: 0.3)),
                            ],
                          );
                        }
                        final e = filteredFallback[i];
                        final isSelected = e.key == value;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(_specializationIcon(e.key),
                                  color: isSelected ? colors.primary : colors.textSecondary, size: 24),
                              title: Text(e.value, style: TextStyle(color: colors.textPrimary)),
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
                            if (i < filteredFallback.length - 1)
                              Divider(height: 1, indent: 16, endIndent: 16, color: colors.divider.withValues(alpha: 0.3)),
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

IconData _specializationIcon(String key) {
  return switch (key) {
    'cardiology' => Icons.favorite_rounded,
    'dermatology' => Icons.face_rounded,
    'neurology' => Icons.psychology_rounded,
    'pediatrics' => Icons.child_care_rounded,
    'orthopedics' => Icons.accessible_rounded,
    'ophthalmology' => Icons.visibility_rounded,
    'ent' => Icons.hearing_rounded,
    'psychiatry' => Icons.psychology_alt_rounded,
    'radiology' => Icons.image_outlined,
    'surgery' => Icons.content_cut_rounded,
    'internal_medicine' => Icons.biotech_rounded,
    'obstetrics_gynecology' => Icons.pregnant_woman_rounded,
    'emergency_medicine' => Icons.local_hospital_rounded,
    'anesthesiology' => Icons.bedtime_rounded,
    'pathology' => Icons.science_rounded,
    'urology' => Icons.water_drop_rounded,
    'gastroenterology' => Icons.restaurant_rounded,
    'endocrinology' => Icons.monitor_heart_rounded,
    'pulmonology' => Icons.air_rounded,
    'rheumatology' => Icons.accessible_forward_rounded,
    'nephrology' => Icons.water_rounded,
    'hematology' => Icons.bloodtype_rounded,
    'oncology' => Icons.coronavirus_rounded,
    'infectious_disease' => Icons.bug_report_rounded,
    'genetics' => Icons.science_rounded,
    'immunology' => Icons.shield_rounded,
    'sports_medicine' => Icons.sports_kabaddi_rounded,
    _ => Icons.medical_services_outlined,
  };
}
