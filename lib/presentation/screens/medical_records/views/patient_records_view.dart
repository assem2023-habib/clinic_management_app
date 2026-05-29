import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_patient_summary.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_conditions_grid.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_medications_list.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_appointments_timeline.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_documents_grid.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_bottom_nav.dart';

class PatientRecordsView extends StatefulWidget {
  const PatientRecordsView({super.key});

  @override
  State<PatientRecordsView> createState() => _PatientRecordsViewState();
}

class _PatientRecordsViewState extends State<PatientRecordsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00180B),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildBody()),
            const MrpBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF00180B).withValues(alpha: 0.4),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF80D8A6),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            AppStrings.mrTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF80D8A6),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.lock_rounded,
            size: 24,
            color: Color(0xFF80D8A6),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          const MrpPatientSummary(),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrConditionsTitle, AppStrings.mrActiveLabel),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Expanded(
                child: MrpConditionCard(
                  icon: Icons.monitor_heart_rounded,
                  iconBg: Color(0xFF80D8A6),
                  iconColor: Color(0xFF80D8A6),
                  label: 'ارتفاع ضغط الدم',
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: MrpConditionCard(
                  icon: Icons.medication_rounded,
                  iconBg: Color(0xFFFFB3B1),
                  iconColor: Color(0xFFFFB3B1),
                  label: 'نقص فيتامين د',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrMedicationsTitle, null),
          const SizedBox(height: AppSpacing.sm),
          const MrpMedicationCard(
            icon: Icons.medication_rounded,
            name: 'ليسينوبريل (Lisinopril)',
            dosage: '10 ملغ • مرة واحدة يومياً',
          ),
          const SizedBox(height: AppSpacing.sm),
          const MrpMedicationCard(
            icon: Icons.medication_liquid_rounded,
            name: 'فيتامين د3 مكمل',
            dosage: '5000 وحدة • أسبوعياً',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrAppointmentsTitle, AppStrings.mrViewAll),
          const SizedBox(height: AppSpacing.sm),
          const MrpTimelineItem(
            isPrimary: true,
            date: '15 أكتوبر 2023',
            doctorName: 'د. محمد القحطاني',
            specialty: 'أخصائي القلب',
          ),
          const MrpTimelineItem(
            isPrimary: false,
            date: '02 سبتمبر 2023',
            doctorName: 'د. ليلى السعيد',
            specialty: 'طبيب عام',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrDocumentsTitle, null),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Expanded(
                child: MrpDocumentCard(
                  title: 'نتائج المختبر - دم',
                  subtitle: 'PDF • 1.2 MB',
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: MrpDocumentCard(
                  title: 'أشعة سينية للصدر',
                  subtitle: 'JPG • 4.5 MB',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const MrpUploadButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String? action) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFFC6EBD1),
          ),
        ),
        const Spacer(),
        if (action != null)
          Text(
            action,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF80D8A6),
            ),
          ),
      ],
    );
  }
}
