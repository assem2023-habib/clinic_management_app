import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/presentation/widgets/appointment_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class AdminAppointmentsView extends StatefulWidget {
  const AdminAppointmentsView({super.key});

  @override
  State<AdminAppointmentsView> createState() => _AdminAppointmentsViewState();
}

class _AdminAppointmentsViewState extends State<AdminAppointmentsView> {
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
              if (state is AppointmentLoading) return const SkeletonList();
              if (state is AppointmentLoaded) {
                if (state.appointments.isEmpty) return const EmptyDataWidget(icon: Icons.calendar_month_outlined, title: AppStrings.noData, compact: true);
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
              return const EmptyDataWidget(icon: Icons.calendar_month_outlined, title: AppStrings.noData, compact: true);
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
                if (value == 'edit') _showAppointmentForm(context);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text(AppStrings.edit)])),
                const PopupMenuItem(value: 'complete', child: Text(AppStrings.complete)),
                const PopupMenuItem(value: 'cancel', child: Text(AppStrings.cancel)),
                const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text(AppStrings.delete, style: TextStyle(color: Colors.red))])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AppColorSet colors, String status) {
    return switch (status) {
      'scheduled' => colors.primary,
      'completed' => colors.success,
      'cancelled' => colors.error,
      'inProgress' => colors.accent,
      _ => colors.textLight,
    };
  }

  Widget _buildStatusBadge(AppColorSet colors, String status) {
    final (color, label) = switch (status) {
      'scheduled' => (colors.primary, AppStrings.scheduled),
      'completed' => (colors.success, AppStrings.completed),
      'cancelled' => (colors.error, AppStrings.cancelled),
      'inProgress' => (colors.accent, AppStrings.inProgress),
      _ => (colors.textLight, status),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  void _showAppointmentForm(BuildContext context) async {
    final result = await showDialog<ConfirmationData>(
      context: context,
      builder: (_) => const AppointmentFormDialog(),
    );
    if (result != null && context.mounted) {
      Navigator.pushNamed(context, AppRoutes.appointmentConfirmation, arguments: result);
    }
  }

  void _deleteAppointment(BuildContext context, String id) {
    showDeleteDialog(context).then((confirmed) {
      if (confirmed == true) {
        context.read<AppointmentBloc>().add(AppointmentDelete(id));
        showSnackBar(context, AppStrings.appointmentDeleted);
      }
    });
  }

  void _updateStatus(BuildContext context, String id, AppointmentStatus status) {
    context.read<AppointmentBloc>().add(AppointmentUpdateStatus(id, status));
    showSnackBar(context, AppStrings.statusUpdated);
  }
}
