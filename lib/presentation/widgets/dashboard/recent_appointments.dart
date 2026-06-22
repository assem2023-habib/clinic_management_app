import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class RecentAppointments extends StatelessWidget {
  final int limit;

  const RecentAppointments({super.key, this.limit = 3});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const SkeletonList();
        }
        if (state is AppointmentLoaded) {
          final recent = state.appointments.take(limit).toList();
          if (recent.isEmpty) {
            return const EmptyDataWidget(icon: Icons.event_busy_rounded, title: AppStrings.noAppointments, compact: true);
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recent.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final a = recent[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _statusColor(colors, a.status.toValue()),
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(a.patientName ?? ''),
                  subtitle: Text(a.doctorName ?? ''),
                  trailing: _statusBadge(colors, a.status.toValue()),
                ),
              );
            },
          );
        }
        return const EmptyDataWidget(icon: Icons.event_busy_rounded, title: AppStrings.noAppointments, compact: true);
      },
    );
  }

  Color _statusColor(AppColorSet colors, String status) {
    return switch (status) {
      'set' || 'accepted' => colors.primary,
      'completed' => colors.success,
      'cancelled' => colors.error,
      'in_progress' => colors.accent,
      _ => colors.textLight,
    };
  }

  Widget _statusBadge(AppColorSet colors, String status) {
    final (color, label) = switch (status) {
      'set' || 'accepted' => (colors.primary, AppStrings.scheduled),
      'completed' => (colors.success, AppStrings.completed),
      'cancelled' => (colors.error, AppStrings.cancelled),
      'in_progress' => (colors.accent, AppStrings.inProgress),
      _ => (colors.textLight, status),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}
