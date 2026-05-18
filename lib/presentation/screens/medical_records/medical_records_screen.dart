import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/data/mock/mock_data.dart';
import 'package:clinic_management_app/data/models/medical_record.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = MockData.medicalRecords;
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Records')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildRecordCard(context, records[index], colors),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, MedicalRecord record, AppColorSet colors) {
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
