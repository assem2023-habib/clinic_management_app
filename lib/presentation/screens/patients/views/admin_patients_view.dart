import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';
import 'package:clinic_management_app/presentation/widgets/patient_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class AdminPatientsView extends StatefulWidget {
  const AdminPatientsView({super.key});

  @override
  State<AdminPatientsView> createState() => _AdminPatientsViewState();
}

class _AdminPatientsViewState extends State<AdminPatientsView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - 200) {
      final state = context.read<PatientBloc>().state;
      if (state is PatientLoaded && !state.isLoadingMore && state.hasMore) {
        context.read<PatientBloc>().add(PatientLoadMore(page: state.page + 1));
      }
    }
  }

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
              if (state is PatientLoading) return const SkeletonList();
              if (state is PatientLoaded) {
                if (state.patients.isEmpty) return  EmptyDataWidget(icon: Icons.people_outline_rounded, title: AppStrings.noData, compact: true);
                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  itemCount: state.patients.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index >= state.patients.length) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    return AnimatedCard(
                      index: index,
                      child: _buildPatientCard(state.patients[index], colors),
                    );
                  },
                );
              }
              if (state is PatientError) return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
              return  EmptyDataWidget(icon: Icons.people_outline_rounded, title: AppStrings.noData, compact: true);
            },
          ),
        ),
      ],
    );
  }

  int _ageFromBirthday(String? birthdayDate) {
    if (birthdayDate == null) return 0;
    final birth = DateTime.tryParse(birthdayDate);
    if (birth == null) return 0;
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) age--;
    return age;
  }

  Widget _buildPatientCard(PatientEntity patient, AppColorSet colors) {
    final isMale = patient.gender == 'male';
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMale ? colors.primary : Colors.pink,
          child: Icon(isMale ? Icons.male : Icons.female, color: Colors.white),
        ),
        title: Text('${patient.firstName} ${patient.lastName}'),
        subtitle: Text('${_ageFromBirthday(patient.birthdayDate)} years - ${patient.gender.toUpperCase()}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _showPatientForm(context, patient: patient);
            if (value == 'delete') _deletePatient(context, patient.id);
          },
          itemBuilder: (context) => [
             PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: AppSpacing.sm), Flexible(child: Text(AppStrings.edit, overflow: TextOverflow.ellipsis))])),
             PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: AppSpacing.sm), Flexible(child: Text(AppStrings.delete, style: TextStyle(color: Colors.red), overflow: TextOverflow.ellipsis))])),
          ],
        ),
      ),
    );
  }

  void _showPatientForm(BuildContext context, {PatientEntity? patient}) {
    showDialog(context: context, builder: (_) => PatientFormDialog(patient: patient));
  }

  Future<void> _deletePatient(BuildContext context, String id) async {
    final confirmed = await showDeleteDialog(context);
    if (!context.mounted) return;
    if (confirmed == true) {
      context.read<PatientBloc>().add(PatientDelete(id));
      showSnackBar(context, AppStrings.patientDeleted);
    }
  }
}
