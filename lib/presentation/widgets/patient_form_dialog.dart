import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';

class PatientFormDialog extends StatefulWidget {
  final PatientEntity? patient;
  const PatientFormDialog({super.key, this.patient});

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.patient?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.patient?.lastName ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _addressController = TextEditingController(text: widget.patient?.address ?? '');
    _gender = widget.patient?.gender ?? 'male';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final patient = PatientEntity(
        id: widget.patient?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _gender,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        username: widget.patient?.username ?? '',
        birthdayDate: widget.patient?.birthdayDate,
        isActive: true,
        imageUrl: widget.patient?.imageUrl,
        roles: widget.patient?.roles ?? ['Patient'],
        createdAt: widget.patient?.createdAt ?? DateTime.now().toIso8601String(),
        updatedAt: widget.patient?.updatedAt ?? DateTime.now().toIso8601String(),
      );

      if (widget.patient == null) {
        context.read<PatientBloc>().add(PatientAdd(patient));
        showSnackBar(context, 'Patient added successfully');
      } else {
        context.read<PatientBloc>().add(PatientUpdate(patient));
        showSnackBar(context, 'Patient updated successfully');
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.patient == null ? AppStrings.addPatient : AppStrings.edit),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name'), validator: (v) => v!.isEmpty ? AppStrings.required : null),
              const SizedBox(height: 12),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name'), validator: (v) => v!.isEmpty ? AppStrings.required : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [DropdownMenuItem(value: 'male', child: Text('Male')), DropdownMenuItem(value: 'female', child: Text('Female'))],
                onChanged: (v) => setState(() => _gender = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: AppStrings.phone), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? AppStrings.required : null),
              const SizedBox(height: 12),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: AppStrings.email), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? AppStrings.required : null),
              const SizedBox(height: 12),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: AppStrings.address)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(onPressed: _submit, child: const Text(AppStrings.save)),
      ],
    );
  }
}
