import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

final _fallbackSpecs = {
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
      style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.bodyLarge),
      decoration: InputDecoration(
        labelText: AppStrings.specialty,
        labelStyle: TextStyle(color: colors.textSecondary),
        hintText: AppStrings.chooseSpecialty,
        hintStyle: TextStyle(color: colors.textLight),
        prefixIcon: Icon(value != null ? _specializationIcon(value!) : AppIcons.medicalServices, color: colors.textSecondary),
        suffixIcon: Icon(AppIcons.arrowDropDown, color: colors.textSecondary, size: AppSpacing.iconMedium),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
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
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: colors.divider,
                      borderRadius: BorderRadius.circular(AppSpacing.xxs),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.chooseSpecialty,
                    style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.bold, color: colors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
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
                      prefixIcon: Icon(AppIcons.search, color: colors.textSecondary),
                      filled: true, fillColor: colors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
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
                                    color: isSelected ? colors.primary : colors.textSecondary, size: AppSpacing.iconSize),
                                title: Text(spec.nameAr, style: TextStyle(color: colors.textPrimary)),
                                subtitle: Text(spec.nameEn, style: TextStyle(color: colors.textSecondary, fontSize: AppSpacing.bodySmall)),
                                trailing: isSelected
                                    ? Icon(AppIcons.checkCircle, color: colors.primary, size: AppSpacing.iconMedium)
                                    : null,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
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
                                  color: isSelected ? colors.primary : colors.textSecondary, size: AppSpacing.iconSize),
                              title: Text(e.value, style: TextStyle(color: colors.textPrimary)),
                              trailing: isSelected
                                  ? Icon(AppIcons.checkCircle, color: colors.primary, size: AppSpacing.iconMedium)
                                  : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
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
    'cardiology' => AppIcons.favorite,
    'dermatology' => AppIcons.face,
    'neurology' => AppIcons.psychology,
    'pediatrics' => AppIcons.childCare,
    'orthopedics' => AppIcons.accessible,
    'ophthalmology' => AppIcons.visibility,
    'ent' => AppIcons.hearing,
    'psychiatry' => AppIcons.psychologyAlt,
    'radiology' => AppIcons.imageOutline,
    'surgery' => AppIcons.contentCut,
    'internal_medicine' => AppIcons.biotech,
    'obstetrics_gynecology' => AppIcons.pregnantWoman,
    'emergency_medicine' => AppIcons.localHospital,
    'anesthesiology' => AppIcons.bedtime,
    'pathology' => AppIcons.science,
    'urology' => AppIcons.waterDrop,
    'gastroenterology' => AppIcons.restaurant,
    'endocrinology' => AppIcons.monitorHeart,
    'pulmonology' => AppIcons.air,
    'rheumatology' => AppIcons.accessibleForward,
    'nephrology' => AppIcons.water,
    'hematology' => AppIcons.bloodtype,
    'oncology' => AppIcons.coronavirus,
    'infectious_disease' => AppIcons.bugReport,
    'genetics' => AppIcons.science,
    'immunology' => AppIcons.shield,
    'sports_medicine' => AppIcons.sportsKabaddi,
    _ => AppIcons.medicalServices,
  };
}

