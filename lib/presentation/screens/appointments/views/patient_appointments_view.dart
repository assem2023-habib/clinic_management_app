import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';

class PatientAppointmentsView extends StatefulWidget {
  const PatientAppointmentsView({super.key});

  @override
  State<PatientAppointmentsView> createState() => _PatientAppointmentsViewState();
}

class _PatientAppointmentsViewState extends State<PatientAppointmentsView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        _buildCalendarHeader(colors),
        Expanded(
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              if (state is AppointmentLoading) return const Center(child: CircularProgressIndicator());
              if (state is AppointmentLoaded) {
                if (state.appointments.isEmpty) return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.appointments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => AnimatedCard(
                    index: index,
                    child: _buildAppointmentCard(state.appointments[index], colors),
                  ),
                );
              }
              if (state is AppointmentError) return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
              return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader(AppColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)))),
          Column(
            children: [
              Text(DateFormat('EEEE').format(_selectedDate), style: TextStyle(fontSize: 14, color: colors.textSecondary)),
              Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary)),
            ],
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)))),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentEntity appointment, AppColorSet colors) {
    final (color, label) = _statusInfo(colors, appointment.status.name);
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: const Icon(Icons.event, color: Colors.white)),
        title: Text(appointment.doctorName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.patientName),
            Text(appointment.timeSlot, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
          child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  (Color, String) _statusInfo(AppColorSet colors, String status) {
    return switch (status) {
      'scheduled' => (colors.primary, AppStrings.scheduled),
      'completed' => (colors.success, AppStrings.completed),
      'cancelled' => (colors.error, AppStrings.cancelled),
      'inProgress' => (colors.accent, AppStrings.inProgress),
      _ => (colors.textLight, status),
    };
  }

}
