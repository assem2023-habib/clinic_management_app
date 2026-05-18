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

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Records')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildRecordCard(context, records[index]),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, MedicalRecord record) {
    return Card(
      child: ExpansionTile(
        leading: const CircleAvatar(child: Icon(Icons.description)),
        title: Text(record.patientName),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(record.visitDate)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Doctor', record.doctorName),
                const SizedBox(height: 12),
                _buildInfoRow('Diagnosis', record.diagnosis),
                const SizedBox(height: 12),
                _buildInfoRow('Prescription', record.prescription),
                if (record.notes != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow('Notes', record.notes!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      ],
    );
  }
}
