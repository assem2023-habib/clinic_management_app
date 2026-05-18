import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/data/models/appointment.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';

class AppointmentFormDialog extends StatefulWidget {
  const AppointmentFormDialog({super.key});

  @override
  State<AppointmentFormDialog> createState() => _AppointmentFormDialogState();
}

class _AppointmentFormDialogState extends State<AppointmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String? _selectedDoctorId;
  String? _selectedPatientId;
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '09:00';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedDoctorId != null && _selectedPatientId != null) {
      final doctorState = context.read<DoctorBloc>().state;
      final patientState = context.read<PatientBloc>().state;

      String doctorName = '';
      String patientName = '';

      if (doctorState is DoctorLoaded) {
        final doc = doctorState.doctors.firstWhere((d) => d.id == _selectedDoctorId);
        doctorName = doc.name;
      }
      if (patientState is PatientLoaded) {
        final pat = patientState.patients.firstWhere((p) => p.id == _selectedPatientId);
        patientName = pat.name;
      }

      final timeParts = _selectedTime.split(':');
      final appointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: _selectedPatientId!,
        patientName: patientName,
        doctorId: _selectedDoctorId!,
        doctorName: doctorName,
        date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, int.parse(timeParts[0]), int.parse(timeParts[1])),
        timeSlot: '${_selectedTime} - ${int.parse(timeParts[0])}:${(int.parse(timeParts[1]) + 30) % 60}',
        status: AppointmentStatus.scheduled,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      context.read<AppointmentBloc>().add(AppointmentAdd(appointment));
      showSnackBar(context, 'Appointment added');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addAppointment),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoaded) {
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedDoctorId,
                      decoration: const InputDecoration(labelText: 'Doctor'),
                      items: state.doctors.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                      onChanged: (v) => setState(() => _selectedDoctorId = v),
                      validator: (v) => v == null ? 'Required' : null,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<PatientBloc, PatientState>(
                builder: (context, state) {
                  if (state is PatientLoaded) {
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedPatientId,
                      decoration: const InputDecoration(labelText: 'Patient'),
                      items: state.patients.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                      onChanged: (v) => setState(() => _selectedPatientId = v),
                      validator: (v) => v == null ? 'Required' : null,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Date', suffixIcon: Icon(Icons.calendar_today)),
                controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedTime,
                decoration: const InputDecoration(labelText: 'Time'),
                items: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedTime = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
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
