import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/presentation/widgets/appointment_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/glass_card.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class AdminAppointmentsView extends StatefulWidget {
  final bool isReceptionist;

  const AdminAppointmentsView({super.key, this.isReceptionist = false});

  @override
  State<AdminAppointmentsView> createState() => _AdminAppointmentsViewState();
}

class _AdminAppointmentsViewState extends State<AdminAppointmentsView> {
  DateTime _selectedDate = DateTime.now();

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

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
                final filtered = state.appointments.where((a) {
                  final d = a.date;
                  return d != null && d.startsWith(DateFormat('yyyy-MM-dd').format(_selectedDate));
                }).toList();
                if (filtered.isEmpty) return  EmptyDataWidget(icon: Icons.calendar_month_outlined, title: AppStrings.noData, compact: true);
                return ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) => AnimatedCard(
                    index: index,
                    child: _buildAppointmentCard(filtered[index], colors),
                  ),
                );
              }
              if (state is AppointmentError) return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
              return  EmptyDataWidget(icon: Icons.calendar_month_outlined, title: AppStrings.noData, compact: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader(AppColorSet colors) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              color: colors.textPrimary,
              onPressed: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
            ),
            GestureDetector(
              onTap: _showDatePicker,
              child: Column(
                children: [
                  Text(DateFormat('EEEE').format(_selectedDate), style: TextStyle(fontSize: AppSpacing.caption, color: colors.textLight)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: colors.textPrimary,
              onPressed: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentEntity appt, AppColorSet colors) {
    final statusValue = appt.status.toValue();
    final (statusColor, statusLabel) = _statusInfo(colors, statusValue);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: statusColor.withValues(alpha: 0.2),
                child: Icon(_statusIcon(statusValue), color: statusColor, size: AppSpacing.iconSmall),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt.patientName ?? '', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    Text('${AppStrings.doctorLabel}: ${appt.doctorName ?? ''}', style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textLight)),
                  ],
                ),
              ),
              _buildStatusBadge(colors, statusColor, statusLabel),
            ],
          ),
          if (appt.timeSlot != null || appt.date != null) ...[
            const SizedBox(height: AppSpacing.ten),
            Row(
              children: [
                if (appt.date != null) ...[
                  Icon(Icons.calendar_today_rounded, size: 14, color: colors.textLight),
                  const SizedBox(width: AppSpacing.xs),
                  Text(appt.date!, style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textLight)),
                ],
                if (appt.timeSlot != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Icon(Icons.schedule_rounded, size: 14, color: colors.textLight),
                  const SizedBox(width: AppSpacing.xs),
                  Text(appt.timeSlot!, style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textLight)),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.ten),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (statusValue != 'completed' && statusValue != 'cancelled') ...[
                _smallAction(colors, AppStrings.complete, Icons.check_circle_rounded, colors.success, () {
                  context.read<AppointmentBloc>().add(AppointmentUpdateStatus(appt.id, AppointmentStatus.completed));
                }),
                const SizedBox(width: AppSpacing.sm),
                _smallAction(colors, AppStrings.cancel, Icons.cancel_rounded, colors.error, () {
                  context.read<AppointmentBloc>().add(AppointmentUpdateStatus(appt.id, AppointmentStatus.cancelled));
                }),
              ],
              if (widget.isReceptionist) ...[
                const SizedBox(width: AppSpacing.sm),
                _smallAction(colors, AppStrings.edit, Icons.edit_rounded, colors.primary, () => _showEditForm(appt)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallAction(AppColorSet colors, String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 30,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.six)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AppColorSet colors, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  (Color, String) _statusInfo(AppColorSet colors, String status) {
    return switch (status) {
      'set' || 'accepted' => (colors.primary, AppStrings.scheduled),
      'completed' => (colors.success, AppStrings.completed),
      'cancelled' => (colors.error, AppStrings.cancelled),
      'in_progress' => (colors.accent, AppStrings.inProgress),
      'requested' => (colors.warning, 'قيد المراجعة'),
      _ => (colors.textLight, status),
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'set' || 'accepted' => Icons.event_available_rounded,
      'completed' => Icons.check_circle_rounded,
      'cancelled' => Icons.cancel_rounded,
      'in_progress' => Icons.pending_actions_rounded,
      'requested' => Icons.hourglass_empty_rounded,
      _ => Icons.event_rounded,
    };
  }

  void _showEditForm(AppointmentEntity appt) async {
    final result = await showDialog<ConfirmationData>(
      context: context,
      builder: (_) => const AppointmentFormDialog(),
    );
    if (result != null && mounted) {
      Navigator.pushNamed(context, AppRoutes.appointmentConfirmation, arguments: result);
    }
  }
}
