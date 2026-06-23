import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/screens/receptionist_home/widgets/rh_queue_card.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';

class RhActiveQueue extends StatelessWidget {
  const RhActiveQueue({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        final appointments = state is AppointmentLoaded ? state.appointments : <AppointmentEntity>[];
        final today = DateTime.now();
        final todayAppts = appointments.where((a) {
          final d = a.date;
          return d != null && DateTime.tryParse(d)?.year == today.year && DateTime.tryParse(d)?.month == today.month && DateTime.tryParse(d)?.day == today.day;
        }).toList();

        final queueOrder = [AppointmentStatus.inProgress, AppointmentStatus.scheduled, AppointmentStatus.cancelled];
        todayAppts.sort((a, b) {
          final aIdx = queueOrder.indexOf(a.status);
          final bIdx = queueOrder.indexOf(b.status);
          if (aIdx != bIdx) return aIdx.compareTo(bIdx);
          return (a.timeSlot ?? '').compareTo(b.timeSlot ?? '');
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.rhActiveQueue,
                  style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: colors.textLight),
                ),
                Row(
                  children: [
                    Icon(Icons.filter_list_rounded, size: AppSpacing.iconSmall, color: colors.textLight),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.search_rounded, size: AppSpacing.iconSmall, color: colors.textLight),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (todayAppts.isEmpty)
               EmptyDataWidget(icon: Icons.event_busy_rounded, title: AppStrings.rhNoApptsToday, compact: true)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: todayAppts.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: index < todayAppts.length - 1 ? AppSpacing.sm : 0),
                  child: RhQueueCard(appointment: todayAppts[index], index: index),
                ),
              ),
          ],
        );
      },
    );
  }
}
