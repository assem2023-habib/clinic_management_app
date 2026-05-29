import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class DoctorRecordsView extends StatefulWidget {
  const DoctorRecordsView({super.key});

  @override
  State<DoctorRecordsView> createState() => _DoctorRecordsViewState();
}

class _DoctorRecordsViewState extends State<DoctorRecordsView> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordBloc>().add(const MedicalRecordLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
      builder: (context, state) {
        if (state is MedicalRecordLoading) {
          return const SkeletonList();
        }
        if (state is MedicalRecordLoaded) {
          if (state.records.isEmpty) {
            return const EmptyDataWidget(icon: Icons.folder_open_rounded, title: AppStrings.noRecords, compact: true);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => AnimatedCard(
              index: index,
              child: _buildRecordCard(context, state.records[index], colors),
            ),
          );
        }
        if (state is MedicalRecordError) {
          return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
        }
        return const EmptyDataWidget(icon: Icons.folder_open_rounded, title: AppStrings.noRecords, compact: true);
      },
    );
  }

  Widget _buildRecordCard(BuildContext context, MedicalRecordEntity record, AppColorSet colors) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(child: Icon(Icons.description, color: colors.primary)),
        title: Text(record.patientName),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(record.visitDate)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(AppStrings.doctorLabel, record.doctorName, colors),
                const SizedBox(height: 12),
                _buildInfoRow(AppStrings.diagnosis, record.diagnosis, colors),
                const SizedBox(height: 12),
                _buildInfoRow(AppStrings.prescription, record.prescription, colors),
                if (record.notes != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(AppStrings.notesLabel, record.notes!, colors),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: colors.textLight, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, color: colors.textPrimary)),
      ],
    );
  }
}
