import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

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
    final role = context.watch<AuthCubit>().state.role;
    final canManage = role == UserRole.admin || role == UserRole.receptionist;

    return AppShell(
      title: AppStrings.doctors,
      currentRoute: AppRoutes.doctors,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
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
                  return const SkeletonList();
                }
                if (state is DoctorLoaded) {
                  if (state.doctors.isEmpty) {
                    return const EmptyDataWidget(icon: Icons.medical_services_outlined, title: AppStrings.noData, compact: true);
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    itemCount: state.doctors.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return _buildDoctorCard(doctor, canManage);
                    },
                  );
                }
                if (state is DoctorError) {
                  return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
                }
                return const EmptyDataWidget(icon: Icons.medical_services_outlined, title: AppStrings.noData, compact: true);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: canManage
          ? FloatingActionButton(
              onPressed: () => _showDoctorForm(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildDoctorCard(DoctorEntity doctor, bool canManage) {
    final colors = AppColors.of(context);

    return Card(
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, AppRoutes.doctorProfile, arguments: doctor.id),
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
            if (canManage)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showDoctorForm(context, doctor: doctor);
                  } else if (value == 'delete') {
                    _deleteDoctor(context, doctor.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text(AppStrings.edit)])),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text(AppStrings.delete, style: TextStyle(color: Colors.red))])),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showDoctorForm(BuildContext context, {DoctorEntity? doctor}) {
    showDialog(
      context: context,
      builder: (_) => DoctorFormDialog(doctor: doctor),
    );
  }

  void _deleteDoctor(BuildContext context, String id) {
    showDeleteDialog(context).then((confirmed) {
      if (confirmed == true) {
        context.read<DoctorBloc>().add(DoctorDelete(id));
        showSnackBar(context, AppStrings.doctorDeleted);
      }
    });
  }
}
