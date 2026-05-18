import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/data/models/doctor.dart';
import 'package:clinic_management_app/data/models/patient.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';
import 'package:clinic_management_app/presentation/widgets/patient_form_dialog.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(PatientLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.patients)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.patients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _buildPatientCard(state.patients[index]),
                  );
                }
                if (state is PatientError) return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
                return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPatientForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    final colors = AppColors.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: patient.gender == Gender.male ? colors.primary : Colors.pink,
          child: Icon(patient.gender == Gender.male ? Icons.male : Icons.female, color: Colors.white),
        ),
        title: Text(patient.name),
        subtitle: Text('${patient.age} years - ${patient.gender.name.toUpperCase()}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _showPatientForm(context, patient: patient);
            if (value == 'delete') _deletePatient(context, patient.id);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')])),
            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
          ],
        ),
      ),
    );
  }

  void _showPatientForm(BuildContext context, {Patient? patient}) {
    showDialog(context: context, builder: (_) => PatientFormDialog(patient: patient));
  }

  void _deletePatient(BuildContext context, String id) {
    showDeleteDialog(context).then((confirmed) {
      if (confirmed == true) {
        context.read<PatientBloc>().add(PatientDelete(id));
        showSnackBar(context, 'Patient deleted successfully');
      }
    });
  }
}
