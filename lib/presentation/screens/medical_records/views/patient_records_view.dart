import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/prescription/prescription_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_patient_summary.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_conditions_grid.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_medications_list.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_appointments_timeline.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/widgets/mrp_bottom_nav.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class PatientRecordsView extends StatefulWidget {
  const PatientRecordsView({super.key});

  @override
  State<PatientRecordsView> createState() => _PatientRecordsViewState();
}

class _PatientRecordsViewState extends State<PatientRecordsView> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordBloc>().add(const MedicalRecordLoadAll());
    context.read<PrescriptionBloc>().add(LoadMedicines());
    context.read<AppointmentBloc>().add(AppointmentLoadAll());
  }

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
    final user = context.watch<AuthCubit>().state.user;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          MrpPatientSummary(
            name: user != null ? '${user.firstName} ${user.lastName}' : '',
            age: user?.birthdayDate != null ? _ageFromBirthday(user!.birthdayDate!) : 0,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrConditionsTitle, AppStrings.mrActiveLabel),
          const SizedBox(height: AppSpacing.sm),
          _buildConditionsSection(),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrMedicationsTitle, null),
          const SizedBox(height: AppSpacing.sm),
          _buildMedicationsSection(),
          const SizedBox(height: AppSpacing.md),
          _buildSectionTitle(AppStrings.mrAppointmentsTitle, null),
          const SizedBox(height: AppSpacing.sm),
          _buildTimelineSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildConditionsSection() {
    return BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
      builder: (context, state) {
        if (state is MedicalRecordLoading) {
          return const SkeletonBox(width: double.infinity, height: 56);
        }
        if (state is MedicalRecordLoaded) {
          final diagnoses = state.records.where((r) => r.diagnosis.isNotEmpty).map((r) => r.diagnosis).toSet().toList();
          if (diagnoses.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('لا توجد تشخيصات مسجلة', style: TextStyle(color: Color(0xFF88938A))),
            );
          }
          return Column(
            children: [
              for (final diagnosis in diagnoses.take(2))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MrpConditionCard(
                    icon: Icons.monitor_heart_rounded,
                    iconBg: const Color(0xFF80D8A6),
                    iconColor: const Color(0xFF80D8A6),
                    label: diagnosis,
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMedicationsSection() {
    return BlocBuilder<PrescriptionBloc, PrescriptionState>(
      builder: (context, state) {
        final medicines = switch (state) {
          MedicinesLoaded(:final medicines) => medicines,
          _ => <dynamic>[],
        };
        if (medicines.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('لا توجد أدوية مسجلة', style: TextStyle(color: Color(0xFF88938A))),
          );
        }
        return Column(
          children: [
            for (final med in medicines.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MrpMedicationCard(
                  icon: Icons.medication_rounded,
                  name: med.nameAr,
                  dosage: med.manufacturer ?? '',
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineSection() {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        final appointments = state is AppointmentLoaded ? state.appointments : <dynamic>[];
        if (appointments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('لا توجد مواعيد سابقة', style: TextStyle(color: Color(0xFF88938A))),
          );
        }
        return Column(
          children: [
            for (int i = 0; i < appointments.length && i < 5; i++)
              MrpTimelineItem(
                isPrimary: i == 0,
                date: appointments[i].createdAt ?? '',
                doctorName: appointments[i].doctorName ?? '',
                specialty: appointments[i].doctor?.specialty ?? '',
              ),
          ],
        );
      },
    );
  }

  int _ageFromBirthday(String birthday) {
    final date = DateTime.tryParse(birthday);
    if (date == null) return 0;
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
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
