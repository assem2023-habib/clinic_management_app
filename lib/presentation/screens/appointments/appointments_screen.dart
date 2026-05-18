import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/data/models/appointment.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/widgets/appointment_form_dialog.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(AppointmentLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appointments)),
      body: Column(
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
                    itemBuilder: (context, index) => _buildAppointmentCard(state.appointments[index], colors),
                  );
                }
                if (state is AppointmentError) return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
                return Center(child: Text(AppStrings.noData, style: TextStyle(color: colors.textSecondary)));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAppointmentForm(context),
        child: const Icon(Icons.add),
      ),
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

  Widget _buildAppointmentCard(Appointment appointment, AppColorSet colors) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: _getStatusColor(colors, appointment.status.name), child: const Icon(Icons.event, color: Colors.white)),
        title: Text(appointment.patientName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.doctorName),
            Text(appointment.timeSlot, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusBadge(colors, appointment.status.name),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') _deleteAppointment(context, appointment.id);
                if (value == 'complete') _updateStatus(context, appointment.id, AppointmentStatus.completed);
                if (value == 'cancel') _updateStatus(context, appointment.id, AppointmentStatus.cancelled);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'complete', child: Text('Complete')),
                const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AppColorSet colors, String status) {
    switch (status) {
      case 'scheduled': return colors.primary;
      case 'completed': return colors.success;
      case 'cancelled': return colors.error;
      case 'inProgress': return colors.accent;
      default: return colors.textLight;
    }
  }

  Widget _buildStatusBadge(AppColorSet colors, String status) {
    Color color;
    String label;
    switch (status) {
      case 'scheduled': color = colors.primary; label = 'Scheduled'; break;
      case 'completed': color = colors.success; label = 'Completed'; break;
      case 'cancelled': color = colors.error; label = 'Cancelled'; break;
      case 'inProgress': color = colors.accent; label = 'In Progress'; break;
      default: color = colors.textLight; label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  void _showAppointmentForm(BuildContext context) {
    showDialog(context: context, builder: (_) => const AppointmentFormDialog());
  }

  void _deleteAppointment(BuildContext context, String id) {
    showDeleteDialog(context).then((confirmed) {
      if (confirmed == true) {
        context.read<AppointmentBloc>().add(AppointmentDelete(id));
        showSnackBar(context, 'Appointment deleted');
      }
    });
  }

  void _updateStatus(BuildContext context, String id, AppointmentStatus status) {
    context.read<AppointmentBloc>().add(AppointmentUpdateStatus(id, status));
    showSnackBar(context, 'Status updated');
  }
}
