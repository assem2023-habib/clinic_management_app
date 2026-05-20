import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/presentation/blocs/medical_record/medical_record_bloc.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordBloc>().add(const MedicalRecordLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Records')),
      body: BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
        builder: (context, state) {
          if (state is MedicalRecordLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MedicalRecordLoaded) {
            if (state.records.isEmpty) {
              return Center(child: Text('No records', style: TextStyle(color: colors.textSecondary)));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildRecordCard(context, state.records[index], colors),
            );
          }
          if (state is MedicalRecordError) {
            return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
          }
          return Center(child: Text('No records', style: TextStyle(color: colors.textSecondary)));
        },
      ),
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
                _buildInfoRow('Doctor', record.doctorName, colors),
                const SizedBox(height: 12),
                _buildInfoRow('Diagnosis', record.diagnosis, colors),
                const SizedBox(height: 12),
                _buildInfoRow('Prescription', record.prescription, colors),
                if (record.notes != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow('Notes', record.notes!, colors),
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
