import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class DoctorFormDialog extends StatefulWidget {
  final DoctorEntity? doctor;

  const DoctorFormDialog({super.key, this.doctor});

  @override
  State<DoctorFormDialog> createState() => _DoctorFormDialogState();
}

class _DoctorFormDialogState extends State<DoctorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor?.name ?? '');
    _specialtyController = TextEditingController(text: widget.doctor?.specialty ?? '');
    _phoneController = TextEditingController(text: widget.doctor?.phone ?? '');
    _emailController = TextEditingController(text: widget.doctor?.email ?? '');
    _isAvailable = widget.doctor?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final nameParts = _nameController.text.trim().split(' ');
      final doctor = DoctorEntity(
        id: widget.doctor?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: nameParts.isNotEmpty ? nameParts.first : '',
        lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
        username: _emailController.text.trim().split('@').first,
        email: _emailController.text.trim(),
        gender: 'male',
        phone: _phoneController.text.trim(),
      );

      if (widget.doctor == null) {
        context.read<DoctorBloc>().add(DoctorAdd(doctor));
        showSnackBar(context, 'Doctor added successfully');
      } else {
        context.read<DoctorBloc>().add(DoctorUpdate(doctor));
        showSnackBar(context, 'Doctor updated successfully');
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.doctor == null ? AppStrings.addDoctor : AppStrings.edit),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(labelText: AppStrings.name),
                validator: (v) => v!.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              TextFormField(
                controller: _specialtyController,
                decoration:  InputDecoration(labelText: AppStrings.specialty),
                validator: (v) => v!.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              TextFormField(
                controller: _phoneController,
                decoration:  InputDecoration(labelText: AppStrings.phone),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              TextFormField(
                controller: _emailController,
                decoration:  InputDecoration(labelText: AppStrings.email),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              SwitchListTile(
                title: Text(AppStrings.availableTitle),
                value: _isAvailable,
                onChanged: (v) => setState(() => _isAvailable = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child:  Text(AppStrings.cancel)),
        ElevatedButton(onPressed: _submit, child:  Text(AppStrings.save)),
      ],
    );
  }
}

