import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/data/models/doctor.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_form_dialog.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(DoctorLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.doctors)),
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
              onChanged: (value) {
                context.read<DoctorBloc>().add(DoctorSearch(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DoctorLoaded) {
                  if (state.doctors.isEmpty) {
                    return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return _buildDoctorCard(doctor);
                    },
                  );
                }
                if (state is DoctorError) {
                  return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
                }
                return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDoctorForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    final colors = AppColors.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: doctor.isAvailable ? colors.secondary : colors.textLight,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(doctor.name),
        subtitle: Text(doctor.specialty),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: doctor.isAvailable ? colors.success : colors.error,
                shape: BoxShape.circle,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showDoctorForm(context, doctor: doctor);
                } else if (value == 'delete') {
                  _deleteDoctor(context, doctor.id);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')])),
                const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDoctorForm(BuildContext context, {Doctor? doctor}) {
    showDialog(
      context: context,
      builder: (_) => DoctorFormDialog(doctor: doctor),
    );
  }

  void _deleteDoctor(BuildContext context, String id) {
    showDeleteDialog(context).then((confirmed) {
      if (confirmed == true) {
        context.read<DoctorBloc>().add(DoctorDelete(id));
        showSnackBar(context, 'Doctor deleted successfully');
      }
    });
  }
}
