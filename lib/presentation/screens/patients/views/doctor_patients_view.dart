import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';

class DoctorPatientsView extends StatefulWidget {
  const DoctorPatientsView({super.key});

  @override
  State<DoctorPatientsView> createState() => _DoctorPatientsViewState();
}

class _DoctorPatientsViewState extends State<DoctorPatientsView> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppStrings.search,
              prefixIcon: Icon(Icons.search, color: colors.textLight),
            ),
            onChanged: (value) => context.read<PatientBloc>().add(PatientSearch(value)),
          ),
        ),
        Expanded(
          child: BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is PatientLoading) return const Center(child: CircularProgressIndicator());
              if (state is PatientLoaded) {
                if (state.patients.isEmpty) return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  itemCount: state.patients.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => AnimatedCard(
                    index: index,
                    child: _buildPatientCard(state.patients[index], colors),
                  ),
                );
              }
              if (state is PatientError) return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
              return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPatientCard(PatientEntity patient, AppColorSet colors) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: patient.gender == Gender.male ? colors.primary : Colors.pink,
          child: Icon(patient.gender == Gender.male ? Icons.male : Icons.female, color: Colors.white),
        ),
        title: Text(patient.name),
        subtitle: Text('${patient.age} years - ${patient.gender.name.toUpperCase()}'),
      ),
    );
  }
}
